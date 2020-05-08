let mongoose = require('mongoose');
let cardSchema = require('./cardSchema');

// Details on each pack, how to draft and what's in it.
const Pack = {
  trash: {
    type: Number,
    default: 0,
  },
  cards: [Number],
};

//data for each seat, human or bot
const Seat = {
  bot: [String], //null bot value means human player
  name: String,
  userid: String,
  drafted: [[Number]], //organized draft picks
  sideboard: [[Number]], //organized draft picks
  pickorder: [Number],
  packbacklog: [Pack],
};

// Cube schema
let draftSchema = mongoose.Schema({
  basics: {
    Plains: cardSchema,
    Island: cardSchema,
    Swamp: cardSchema,
    Mountain: cardSchema,
    Forest: cardSchema,
    Wastes: cardSchema,
  },
  cards: [cardSchema],
  cube: String,
  initial_state: [[Pack]],
  seats: [Seat],
  synergies: [[Number]],
  unopenedPacks: [[Pack]],
});

let Draft = (module.exports = mongoose.model('Draft', draftSchema));
