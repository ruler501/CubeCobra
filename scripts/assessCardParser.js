const { Grammar, Parser } = require('nearley');

const magicCardGrammar = require('../dist/generated/magicCardGrammar');
const carddb = require('../serverjs/cards');

const compiledGrammar = Grammar.fromCompiled(magicCardGrammar);

const makeUnique = (lst) => {
  const seen = [];
  const result = [];
  for (const elem of lst) {
    const stringified = JSON.stringify(elem);
    if (!seen.includes(stringified)) {
      result.push(elem);
      seen.push(stringified);
    }
  }
  return result;
};

const tryParsing = ({ name, oracle_text }) => {
  const magicCardParser = new Parser(compiledGrammar);
  const oracleText = oracle_text.split(name).join('~');
  try {
    magicCardParser.feed(oracleText);
  } catch (error) {
    return { parsed: null, error, oracleText };
  }

  const { results } = magicCardParser;
  const result = makeUnique(results);
  if (result.length === 0) {
    return { result: null, error: 'Incomplete parse', oracleText };
  }
  if (result.length > 1) {
    return { result, error: 'Ambiguous parse.', oracleText };
  }
  return { result, error: null, oracleText };
};

carddb.initializeCardDb().then(() => {
  const successes = [];
  const ambiguous = [];
  const failures = [];
  const cards = carddb.allCards();
  const oracleIds = [];
  let index = 1;
  for (const card of cards) {
    const {
      isToken,
      name,
      oracle_id,
      border_color: borderColor,
      type,
      set,
      parsed_cost: parsedCost,
      power,
      toughness,
      loyalty,
      _id: cardID,
    } = card;
    const typeLineLower = type && type.toLowerCase();
    if (
      !isToken &&
      !oracleIds.includes(oracle_id) &&
      borderColor !== 'silver' &&
      type &&
      !typeLineLower.includes('vanguard') &&
      !typeLineLower.includes('conspiracy') &&
      !typeLineLower.includes('hero') &&
      !typeLineLower.includes('plane ') &&
      !typeLineLower.includes('contraption ') &&
      set !== 'cmb1'
    ) {
      oracleIds.push(oracle_id);
      const { result, error, oracleText } = tryParsing(card);
      if (!error) {
        successes.push({
          cardID,
          name,
          parsedCost,
          types: type.split('—').map((t) => t.split(' ')),
          parsed: result[0],
          power,
          toughness,
          loyalty,
        });
      } else if (result) {
        ambiguous.push({
          cardID,
          name,
          parsedCost,
          types: type.split('—').map((t) => t.split(' ')),
          oracleText,
          parsed: result[0],
          otherParses: result.slice(1),
          power,
          toughness,
          loyalty,
        });
      } else {
        failures.push({ name, oracleText, error });
      }
    }
    if (index % 500 === 0) {
      console.warn(`Finished ${index} of ${cards.length}`);
    }
    index += 1;
  }
  console.info('successes', successes.length);
  // console.debug(
  //   JSON.stringify(
  //     successes.concat(ambiguous).map(({ cardID, name, parsedCost, types, parsed, power, toughness, loyalty }) => ({
  //       cardID,
  //       name,
  //       parsedCost,
  //       types,
  //       parsed,
  //       power,
  //       toughness,
  //       loyalty,
  //     })),
  //   ),
  // );
  console.info('ambiguous', ambiguous.length);
  for (let i = 0; i < 1; i++) {
    console.info(ambiguous[Math.floor(Math.random() * ambiguous.length)]);
  }
  console.info('failures', failures.length);
  for (let i = 0; i < 8; i++) {
    console.info(JSON.stringify(failures[Math.floor(Math.random() * failures.length)]));
  }
  // console.debug(failures.join('\n,'));
  console.info(
    'parse rate',
    successes.length + ambiguous.length,
    '/',
    successes.length + ambiguous.length + failures.length,
  );
});
