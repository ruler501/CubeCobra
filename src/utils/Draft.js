import { csrfFetch } from 'utils/CSRF';
import { arrayIsSubset, arrayShuffle, fromEntries } from 'utils/Util';
import { COLOR_COMBINATIONS, cardCmc, cardColorIdentity, cardName, cardType } from 'utils/Card';

import { getRating, botRatingAndCombination, considerInCombination, fetchLands, getSynergy } from 'utils/draftbots';

let draft = null;

export function addSeen(seen, cards) {
  for (const card of cards) {
    const colors = card.colors ?? card.details.colors ?? [];
    // We ignore colorless because they just reduce variance by
    // being in all color combinations.
    if (colors.length > 0) {
      for (const comb of COLOR_COMBINATIONS) {
        if (arrayIsSubset(colors, comb)) {
          seen[comb.join('')] += getRating(comb, card);
        }
      }
    }
    seen.cards.push(card);
  }
}

function init(newDraft) {
  draft = newDraft;
  for (const seat of draft.seats) {
    const { cards } = draft;
    seat.seen = fromEntries(COLOR_COMBINATIONS.map((comb) => [comb.join(''), 0]));
    seat.seen.cards = [];
    addSeen(
      seat.seen,
      seat.packbacklog[0].cards.map((cardIndex) => cards[cardIndex]),
    );
    seat.picked = fromEntries(COLOR_COMBINATIONS.map((comb) => [comb.join(''), 0]));
    seat.picked.cards = [];
  }
}

function id() {
  return draft._id;
}

function cube() {
  return draft.cube;
}

function pack() {
  return (draft.seats[0].packbacklog[0] || { trash: 0, cards: [] }).cards.map((cardIndex) => draft.cards[cardIndex]);
}

function packPickNumber() {
  let picks = draft.seats[draft.seats.length - 1].pickorder.length;
  let packnum = 0;

  while (
    draft.initial_state[0][packnum] &&
    picks >= draft.initial_state[0][packnum].cards.length - draft.initial_state[0][packnum].trash
  ) {
    picks -= draft.initial_state[0][packnum].cards.length - draft.initial_state[0][packnum].trash;
    packnum += 1;
  }

  return [packnum + 1, picks + 1];
}

function arrangePicks(picks) {
  if (!Array.isArray(picks) || picks.length !== 16) {
    throw new Error('Picks must be an array of length 16.');
  }
  draft.seats[0].drafted = picks.map((pile) =>
    pile.map((pileCard) => draft.cards.findIndex((card) => card.cardID === pileCard.cardID)),
  );
}

const botRating = (cards, card, picked, seen, synergies, initialState, inPack = 1, packNum = 1) =>
  botRatingAndCombination(cards, card, picked, seen, synergies, initialState, inPack, packNum)[0];
const botColors = (cards, card, picked, seen, synergies, initialState, inPack = 1, packNum = 1) =>
  botRatingAndCombination(cards, card, picked, seen, synergies, initialState, inPack, packNum)[1];

function getSortFn(bot, draftCards) {
  return (a, b) => {
    if (bot) {
      return getRating(bot, draftCards[b]) - getRating(bot, draftCards[a]);
    }
    return draftCards[b].rating - draftCards[a].rating;
  };
}

const isPlayableLand = (colors, card) =>
  considerInCombination(colors, card) ||
  (fetchLands[cardName(card)] && fetchLands[cardName(card)].some((c) => colors.includes(c)));

async function buildDeck(cards, cardIndices, picked, synergies, initialState, basics) {
  let nonlands = cardIndices.filter((card) => !cardType(cards[card]).toLowerCase().includes('land'));
  const lands = cardIndices.filter((card) => cardType(cards[card]).toLowerCase().includes('land'));

  const colors = botColors(cards, null, picked, null, synergies, initialState, 1, initialState[0].length);
  const sortFn = getSortFn(colors, cards);
  const inColor = nonlands.filter((cardIndex) => considerInCombination(colors, cards[cardIndex]));
  const outOfColor = nonlands.filter((cardIndex) => !considerInCombination(colors, cards[cardIndex]));

  lands.sort(sortFn);
  inColor.sort(sortFn);

  nonlands = inColor;
  let side = outOfColor;
  if (nonlands.length < 23) {
    outOfColor.sort(sortFn);
    nonlands.push(...outOfColor.splice(0, 23 - nonlands.length));
    side = [...outOfColor];
  }

  // add highest synergy card, then add cards based on a combo of elo and synergy
  const chosen = [];
  const played = fromEntries(COLOR_COMBINATIONS.map((comb) => [comb.join(''), 0]));
  played.cards = [];

  const size = Math.min(23, nonlands.length);
  for (let i = 0; i < size; i++) {
    // add in new synergy data
    const scores = [];
    scores.push(nonlands.map((card) => getSynergy(colors, cards[card], played, synergies)));

    let best = 0;

    for (let j = 1; j < nonlands.length; j++) {
      if (scores[j] > scores[best]) {
        best = j;
      }
    }
    const current = nonlands.splice(best, 1)[0];
    addSeen(played, [cards[current]]);
    chosen.push(current);
  }

  const playableLands = lands.filter((land) => isPlayableLand(colors, cards[land]));
  const unplayableLands = lands.filter((land) => !isPlayableLand(colors, cards[land]));

  const main = chosen.concat(playableLands.slice(0, 17));
  side.push(...playableLands.slice(17));
  side.push(...unplayableLands);
  side.push(...nonlands);

  // add basics
  if (basics) {
    // add up colors
    const symbols = {
      W: 0,
      U: 0,
      B: 0,
      R: 0,
      G: 0,
    };

    for (const card of main) {
      for (const symbol of cardColorIdentity(cards[card])) {
        symbols[symbol] += 1;
      }
    }
    const colorWeights = Object.keys(symbols).map((c) => symbols[c]);
    const totalColor = colorWeights.reduce((a, b) => {
      return a + b;
    }, 0);
    const landDict = {
      W: 'Plains',
      U: 'Island',
      B: 'Swamp',
      R: 'Mountain',
      G: 'Forest',
    };

    console.log(colorWeights);
    console.log(totalColor);
    console.log(40 - main.length);
    for (let i = 0; i < 5; i++) {
      const amount = Math.floor((colorWeights[i] / totalColor) * (40 - main.length));
      console.log(`Adding ${amount} ${landDict[Object.keys(symbols)[i]]}`);
      for (let j = 0; j < amount; j++) {
        main.push(cards.findIndex((card) => card.cardID === basics[landDict[Object.keys(symbols)[i]]].cardID));
      }
    }
    for (let i = main.length; i < 40; i++) {
      main.push(cards.findIndex((card) => card.cardID === basics[landDict[colors[i % colors.length]]].cardID));
    }
  }

  const deck = [];
  const sideboard = [];
  for (let i = 0; i < 16; i += 1) {
    deck.push([]);
    if (i < 8) {
      sideboard.push([]);
    }
  }

  for (const cardIndex of main) {
    const card = cards[cardIndex];
    let index = Math.min(cardCmc(card) ?? 0, 7);
    if (!cardType(card).toLowerCase().includes('creature') && !cardType(card).toLowerCase().includes('basic')) {
      index += 8;
    }
    deck[index].push(cardIndex);
  }

  // sort the basic land col
  deck[0].sort((a, b) => cardName(cards[a]).localeCompare(cardName(cards[b])));

  for (const cardIndex of side) {
    sideboard[Math.min(cardCmc(cards[cardIndex]) ?? 0, 7)].push(cardIndex);
  }

  return {
    deck,
    sideboard,
    colors,
  };
}

function botPicks() {
  // make bots take one pick out of active packs
  for (let botIndex = 0; botIndex < draft.seats.length; botIndex++) {
    const {
      seen,
      picked,
      packbacklog: [packFrom],
      bot,
    } = draft.seats[botIndex];
    if (packFrom.cards.length > 0 && bot) {
      const { cards, initial_state, synergies } = draft;
      let ratedPicks = [];
      const unratedPicks = [];
      const inPack = packFrom.length;
      const [packNum] = packPickNumber();
      for (let cardIndex = 0; cardIndex < packFrom.length; cardIndex++) {
        if (cards[packFrom[cardIndex]].rating) {
          ratedPicks.push(cardIndex);
        } else {
          unratedPicks.push(cardIndex);
        }
      }
      ratedPicks = ratedPicks
        .map((cardIndex) => [
          botRating(cards, packFrom[cardIndex], picked, seen, synergies, initial_state, inPack, packNum),
          cardIndex,
        ])
        .sort(([a], [b]) => b - a)
        .map(([, cardIndex]) => cardIndex);
      arrayShuffle(unratedPicks);

      const pickOrder = ratedPicks.concat(unratedPicks);
      const [pickedCard] = draft.seats[botIndex].packbacklog[0].cards.splice(pickOrder[0], 1);
      draft.seats[botIndex].pickorder.push(pickedCard);
      addSeen(picked, [cards[pickedCard]]);
    }
  }
}

function passPack() {
  botPicks();
  // check if pack is done
  if (draft.seats.every((seat) => seat.packbacklog[0].cards.length <= seat.packbacklog[0].trash)) {
    // splice the first pack out
    for (const seat of draft.seats) {
      seat.packbacklog.splice(0, 1);
    }

    if (draft.unopenedPacks[0].length > 0) {
      // give new pack
      for (let i = 0; i < draft.seats.length; i++) {
        draft.seats[i].packbacklog.push(draft.unopenedPacks[i].shift());
      }
    }
  } else if (draft.unopenedPacks[0].length % 2 === 0) {
    // pass left
    for (let i = 0; i < draft.seats.length; i++) {
      draft.seats[(i + 1) % draft.seats.length].packbacklog.push(draft.seats[i].packbacklog.splice(0, 1)[0]);
    }
  } else {
    // pass right
    for (let i = draft.seats.length - 1; i >= 0; i--) {
      const packFrom = draft.seats[i].packbacklog.splice(0, 1)[0];
      if (i === 0) {
        draft.seats[draft.seats.length - 1].packbacklog.push(packFrom);
      } else {
        draft.seats[i - 1].packbacklog.push(packFrom);
      }
    }
  }
  const { cards } = draft;
  for (const seat of draft.seats) {
    if (seat.packbacklog && seat.packbacklog.length > 0) {
      addSeen(
        seat.seen,
        seat.packbacklog[0].cards.map((cardIndex) => cards[cardIndex]),
      );
    }
  }
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function pick(cardIndex) {
  await sleep(0);
  const ci = draft.seats[0].packbacklog[0].cards.splice(cardIndex, 1)[0];
  const card = draft.cards[ci];
  const packFrom = draft.seats[0].packbacklog[0];
  draft.seats[0].pickorder.push(ci);
  passPack();
  const [packNum] = packPickNumber();
  csrfFetch(`/cube/api/draftpickcard/${draft.cube}`, {
    method: 'POST',
    body: JSON.stringify({
      draft_id: draft._id,
      pick: card.details.name,
      packNum,
      pack: packFrom.cards.map((c) => draft.cards[c].details.name),
    }),
    headers: {
      'Content-Type': 'application/json',
    },
  });
}

async function finish() {
  // build bot decks
  const decksPromise = draft.seats.map(
    (seat) =>
      seat.bot &&
      buildDeck(draft.cards, seat.pickorder, seat.picked, draft.synergies, draft.initial_state, draft.basics),
  );
  const decks = await Promise.all(decksPromise);
  const { cards } = draft;

  let botIndex = 1;
  for (let i = 0; i < draft.seats.length; i++) {
    if (draft.seats[i].bot) {
      const { deck, sideboard, colors } = decks[i];
      draft.seats[i].drafted = deck;
      draft.seats[i].sideboard = sideboard;
      draft.seats[i].name = `Bot ${botIndex}: ${colors.length > 0 ? colors.join(', ') : 'C'}`;
      draft.seats[i].description = `This deck was drafted by a bot with color preference for ${colors.join('')}.`;
      botIndex += 1;
    } else {
      const picked = fromEntries(COLOR_COMBINATIONS.map((comb) => [comb.join(''), 0]));
      picked.cards = [];
      addSeen(
        picked,
        draft.seats[i].pickorder.map((cardIndex) => cards[cardIndex]),
      );
      const colors = botColors(
        draft.cards,
        null,
        picked,
        null,
        null,
        draft.synergies,
        draft.initial_state,
        1,
        draft.initial_state[0].length,
      );
      draft.seats[i].name = `${draft.seats[i].name}: ${colors.join(', ')}`;
    }
  }

  for (const seat of draft.seats) {
    delete seat.seen;
    delete seat.picked;
  }

  for (const card of draft.cards) {
    delete card.details;
  }

  // save draft. if we fail, we fail
  await csrfFetch(`/cube/api/draftpick/${draft.cube}`, {
    method: 'POST',
    body: JSON.stringify(draft),
    headers: {
      'Content-Type': 'application/json',
    },
  });
}

async function allBotsDraft() {
  for (const seat of draft.seats) {
    seat.bot = [];
  }
  while (draft.seats[0].packbacklog.length > 0 && draft.seats[0].packbacklog[0].cards.length > 0) {
    passPack();
  }
  try {
    await finish();
  } catch (error) {
    // ignore since it throws on fetch when using from routes.
    console.debug(error);
  }
}

export default {
  addSeen,
  allBotsDraft,
  arrangePicks,
  botColors,
  buildDeck,
  cube,
  finish,
  id,
  init,
  pack,
  packPickNumber,
  pick,
};
