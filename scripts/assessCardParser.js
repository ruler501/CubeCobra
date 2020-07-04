const { Grammar, Parser } = require('nearley');

const carddb = require('../serverjs/cards');
const magicCardGrammar = require('../dist/generated/magicCardGrammar');

const compiledGrammar = Grammar.fromCompiled(magicCardGrammar);

const tryParsing = (card) => {
  const magicCardParser = new Parser(compiledGrammar);
  try {
    magicCardParser.feed(card.oracle_text);
  } catch (error) {
    return { parsed: null, error };
  }

  const { results: result } = magicCardParser;
  return { result, error: null };
};

carddb.initializeCardDb().then(() => {
  const successes = [];
  const failures = [];
  const cards = carddb.allCards();
  const oracleIds = [];
  let index = 1;
  for (const card of cards) {
    const { oracle_id } = card;
    if (!oracleIds.includes(oracle_id)) {
      oracleIds.push(oracle_id);
      const { result, error } = tryParsing(card);
      if (!error) {
        successes.push(JSON.stringify([card.name, result]));
      } else {
        failures.push(card.name);
      }
    }
    if (index % 500 === 0) {
      console.info(`Finished ${index} of ${cards.length}`);
    }
    index += 1;
  }
  console.log('successes', successes.length);
  // console.debug(successes.join('\n'));
  console.log('failures', failures.length);
  // console.debug(failures.join('\n'));
});
