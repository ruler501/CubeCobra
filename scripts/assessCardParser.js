const { Grammar, Parser } = require('nearley');

const magicCardGrammar = require('../dist/generated/magicCardGrammar');
const carddb = require('../serverjs/cards');

const compiledGrammar = Grammar.fromCompiled(magicCardGrammar);

const tryParsing = ({ name, oracle_text }) => {
  const magicCardParser = new Parser(compiledGrammar);
  const oracleText = oracle_text.split(name).join('~');
  try {
    magicCardParser.feed(oracleText);
  } catch (error) {
    return { parsed: null, error, oracleText };
  }

  const { results: result } = magicCardParser;
  if (result.length !== 1) {
    return { result, error: 'Ambiguous or failed parse.', oracleText };
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
    const { isToken, name, oracle_id, border_color: borderColor, type } = card;
    const typeLineLower = type && type.toLowerCase();
    if (
      !isToken &&
      !oracleIds.includes(oracle_id) &&
      borderColor !== 'silver' &&
      type &&
      !typeLineLower.includes('vanguard') &&
      !typeLineLower.includes('conspiracy') &&
      !typeLineLower.includes('hero') &&
      !typeLineLower.includes('plane ')
    ) {
      oracleIds.push(oracle_id);
      const { result, error, oracleText } = tryParsing(card);
      if (!error) {
        successes.push(JSON.stringify([name, result]));
      } else if (result) {
        ambiguous.push(JSON.stringify([name, oracleText, error, result]));
      } else {
        failures.push(JSON.stringify([name, oracleText, error]));
      }
    }
    if (index % 500 === 0) {
      console.info(`Finished ${index} of ${cards.length}`);
    }
    index += 1;
  }
  console.log('successes', successes.length);
  // console.debug(successes.join('\n'));
  console.log('ambiguous', ambiguous.length);
  for (let i = 0; i < 1; i++) {
    console.log(ambiguous[Math.floor(Math.random() * ambiguous.length)]);
  }
  console.log('failures', failures.length);
  for (let i = 0; i < 5; i++) {
    console.log(failures[Math.floor(Math.random() * failures.length)]);
  }
  // console.debug(failures.join('\n'));
});
