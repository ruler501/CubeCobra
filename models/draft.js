let mongoose = require('mongoose');
let cardSchema = require('./cardSchema');

//data for each seat, human or bot
const Seat = {
  bot: [String], //null bot value means human player
  name: String,
  userid: String,
  drafted: [[Number]], //organized draft picks
  sideboard: [[Number]], //organized draft picks
  pickorder: [Number],
  packbacklog: [[Number]],
};

// Cube schema
let draftSchema = mongoose.Schema({
  cards: [cardSchema],
  cube: String,
  initial_state: [[[Number]]],
  seats: [Seat],
  synergies: [[Number]],
  basics: {
    Plains: cardSchema,
    Island: cardSchema,
    Swamp: cardSchema,
    Mountain: cardSchema,
    Forest: cardSchema,
  },
  unopenedPacks: [[[Number]]],
});

let Draft = (module.exports = mongoose.model('Draft', draftSchema));
