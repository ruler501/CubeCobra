const fs = require('fs');
const path = require('path');

const carddb = require('../serverjs/cards');

const date = new Date();
const folder = `${process.argv[2]}/exports/${date.getUTCFullYear()}${(date.getUTCMonth() + 1)
  .toString()
  .padStart(2, '0')}${date.getDate().toString().padStart(2, '0')}`;

const writeFile = (filename, object) => {
  const fullPath = `${folder}/${filename}`;
  const dirname = path.dirname(fullPath);
  fs.mkdirSync(dirname, { recursive: true });
  fs.writeFileSync(`${folder}/${dirname}/${filename}`, JSON.stringify(object));
};

const loadCardToInt = async () => {
  await carddb.initializeCardDb('private', false);
  const cardToIntFile = 'card_to_int.json';
  const intToCardFile = 'int_to_card.json';
  if (fs.existsSync(`${folder}/${cardToIntFile}`) && fs.existsSync(`${folder}/${intToCardFile}`)) {
    const intToCard = JSON.parse(fs.readFileSync(`${folder}/${intToCardFile}`));
    const cardToInt = JSON.parse(fs.readFileSync(`${folder}/${cardToIntFile}`));
    return { cardToInt, intToCard };
  }
  const cardNames = new Set(carddb.allCards().map((c) => c.name_lower));
  const cardToInt = Object.fromEntries([...cardNames].map((name, index) => [name, index]));
  const intToCard = new Array([...cardNames].length);
  for (const card of carddb.allCards()) {
    intToCard[cardToInt[card.name_lower]] = card;
  }

  writeFile('card_to_int.json', cardToInt);
  writeFile('int_to_card.json', intToCard);
  return { cardToInt, intToCard };
};

module.exports = { loadCardToInt, writeFile };