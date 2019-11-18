import { CstParser, EOF, Lexer, createToken } from 'chevrotain';

let category_token = createToken({ name: 'Field', pattern: Lexer.NA });
let string_value_field = createToken({ name: 'StringValueField', pattern: Lexer.NA });
let ordered_value_field = createToken({ name: 'OrderedValueField', pattern: Lexer.NA });
let set_value_field = createToken({ name: 'SetValueField', pattern: Lexer.NA });
let operation_token = createToken({ name: 'Operation', pattern: Lexer.NA });

let colon_operation = createToken({
  name: 'ColonOperation',
  pattern: /:/,
  push_mode: 'value',
  categories: [operation_token],
});
let less_than_operation = createToken({
  name: 'LessThanOperation',
  pattern: /</,
  push_mode: 'value',
  categories: [operation_token],
});
let greater_than_operation = createToken({
  name: 'GreaterThanOperation',
  pattern: />/,
  push_mode: 'value',
  categories: [operation_token],
});
let less_or_equal_operation = createToken({
  name: 'LessOrEqualOperation',
  pattern: /<=/,
  push_mode: 'value',
  categories: [operation_token],
});
let greater_or_equal_operation = createToken({
  name: 'GreaterOrEqualOperation',
  pattern: />=/,
  push_mode: 'value',
  categories: [operation_token],
});
let equals_operation = createToken({
  name: 'EqualsOperation',
  pattern: /=/,
  push_mode: 'value',
  categories: [operation_token],
});

let negation_operator = createToken({ name: 'NegationOperator', pattern: /-/ });

let type_field = createToken({
  name: 'TypeField',
  pattern: /t(ype)?/,
  push_mode: 'operation',
  categories: [category_token, string_value_field],
});
let oracle_field = createToken({
  name: 'OracleField',
  pattern: /o(racle)?/,
  push_mode: 'operation',
  categories: [category_token, string_value_field],
});
let set_field = createToken({
  name: 'SetField',
  pattern: /s(et)?/,
  push_mode: 'operation',
  categories: [category_token, string_value_field],
});
let name_field = createToken({
  name: 'NameField',
  pattern: /name/,
  push_mode: 'operation',
  categories: [category_token, string_value_field],
});
let status_field = createToken({
  name: 'StatusField',
  pattern: /stat(us)?/,
  push_mode: 'operation',
  categories: [category_token, string_value_field],
});
let artist_field = createToken({
  name: 'ArtistField',
  pattern: /a(rt(ist)?)?/,
  push_mode: 'operation',
  categories: [category_token, string_value_field],
});
let mana_field = createToken({
  name: 'ManaField',
  pattern: /m(ana)?/,
  push_mode: 'operation',
  categories: [category_token, string_value_field],
});
let tag_field = createToken({
  name: 'TagField',
  pattern: /tag/,
  push_mode: 'operation',
  categories: [category_token, string_value_field],
});

let power_field = createToken({
  name: 'PowerField',
  pattern: /pow(er)?/,
  push_mode: 'operation',
  categories: [category_token, ordered_value_field],
});
power_field.field_accessor = (card) => parseFloat(card.details.power, 10);
let toughness_field = createToken({
  name: 'ToughnessField',
  pattern: /tou(ghness)?/,
  push_mode: 'operation',
  categories: [category_token, ordered_value_field],
});
let price_field = createToken({
  name: 'PriceField',
  pattern: /p(rice)?/,
  push_mode: 'operation',
  categories: [category_token, ordered_value_field],
});
let foilprice_field = createToken({
  name: 'Field',
  pattern: /((fp)|(foilprice)|(pricefoil)|(pf))/,
  push_mode: 'operation',
  categories: [category_token, ordered_value_field],
});
let cmc_field = createToken({
  name: 'CmcField',
  pattern: /c(mc)?/,
  push_mode: 'operation',
  categories: [category_token, ordered_value_field],
});
let loyalty_field = createToken({
  name: 'LoyaltyField',
  pattern: /loy(alty)?/,
  push_mode: 'operation',
  categories: [category_token, ordered_value_field],
});
let rarity_field = createToken({
  name: 'RarityField',
  pattern: /r(arity)?/,
  push_mode: 'operation',
  categories: [category_token, ordered_value_field],
});

let color_field = createToken({
  name: 'ColorField',
  pattern: /c(olor)?/,
  push_mode: 'operation',
  categories: [category_token, set_value_field],
});
let identity_field = createToken({
  name: 'IdentityField',
  pattern: /((ci)|(id(entity)?))/,
  push_mode: 'operation',
  categories: [category_token, set_value_field],
});

let string_value = createToken({ name: 'StringValue', pattern: /[^\s"]+/, push_mode: 'field' });
let quoted_value = createToken({
  name: 'QuotedValue',
  pattern: /"((\\")|(\\n)|[^\\"])+"/,
  push_mode: 'field',
  categories: [string_value],
});
// TODO: regex_value
// TODO: mana_value
let dollar_value = createToken({
  name: 'DollarValue',
  pattern: /\$?((\d+(\.\d{1,2}?)?)|(\.\d{1,2}))/,
  push_mode: 'field',
  categories: [string_value],
});
let power_toughness_value = createToken({
  name: 'PowerToughnessValue',
  pattern: /(-?\d+)|(\d+(\.5)?)/,
  push_mode: 'field',
  categories: [string_value],
});
let cmc_value = createToken({
  name: 'CmcValue',
  pattern: /(0?\.5)|(\d+)/,
  push_mode: 'field',
  categories: [string_value, power_toughness_value, dollar_value],
});
let positive_integer_value = createToken({
  name: 'PositiveIntegerValue',
  pattern: /\d+/,
  push_mode: 'field',
  categories: [string_value, power_toughness_value, cmc_value, dollar_value],
});
let rarity_value = createToken({ name: 'RarityValue', pattern: Lexer.NA });
let common_value = createToken({
  name: 'CommonValue',
  pattern: /c(ommon)?/,
  push_mode: 'field',
  categories: [string_value, rarity_value],
});
common_value.rarity_index = 0;
let uncommon_value = createToken({
  name: 'UncommonValue',
  pattern: /u(ncommon)?/,
  push_mode: 'field',
  categories: [string_value, rarity_value],
});
uncommon_value.rarity_index = 1;
let rare_value = createToken({
  name: 'RareValue',
  pattern: /r(are)?/,
  push_mode: 'field',
  categories: [string_value, rarity_value],
});
rare_value.rarity_index = 2;
let mythic_value = createToken({
  name: 'MythicValue',
  pattern: /m(ythic)?/,
  push_mode: 'field',
  categories: [string_value, rarity_value],
});
mythic_value.rarity_index = 3;
let whitespace_token = createToken({ name: 'WhiteSpace', pattern: /\s+/, group: Lexer.SKIPPED });
let filter_tokens = [
  category_token,
  string_value_field,
  ordered_value_field,
  set_value_field,
  mana_field,
  cmc_field,
  color_field,
  identity_field,
  tag_field,
  oracle_field,
  set_field,
  power_field,
  toughness_field,
  name_field,
  type_field,
  price_field,
  foilprice_field,
  status_field,
  rarity_field,
  loyalty_field,
  artist_field,
  cmc_value,
  power_toughness_value,
  dollar_value,
  positive_integer_value,
  rarity_value,
  common_value,
  uncommon_value,
  rare_value,
  mythic_value,
  string_value,
  quoted_value,
  operation_token,
  whitespace_token,
];
let filter_lexer_modes = {
  modes: {
    field: [
      negation_operator,
      tag_field,
      oracle_field,
      set_field,
      name_field,
      status_field,
      artist_field,
      mana_field,
      type_field,
      power_field,
      toughness_field,
      price_field,
      foilprice_field,
      cmc_field,
      loyalty_field,
      rarity_field,
      color_field,
      identity_field,
      whitespace_token,
      category_token,
      string_value_field,
      ordered_value_field,
      set_value_field,
    ],
    operation: [
      colon_operation,
      less_or_equal_operation,
      greater_or_equal_operation,
      less_than_operation,
      greater_than_operation,
      equals_operation,
      operation_token,
      whitespace_token,
    ],
    value: [
      quoted_value,
      positive_integer_value,
      cmc_value,
      power_toughness_value,
      dollar_value,
      common_value,
      uncommon_value,
      rare_value,
      mythic_value,
      string_value,
      rarity_value,
    ],
  },
  defaultMode: 'field',
};

class FilterParser extends CstParser {
  constructor() {
    super(filter_tokens);

    this.RULE('filter', () => {
      this.AT_LEAST_ONE({
        DEF: () => {
          this.SUBRULE(this.filterParameter);
        },
      });
    });

    this.RULE('filterParameter', () => {
      this.OPTION(() => this.CONSUME(negation_operator, { LABEL: 'negation' }));
      this.OR(
        [
          {
            ALT: () => {
              this.SUBRULE(this.orderedParameter, { LABEL: 'inner' });
            },
          },
          {
            ALT: () => {
              this.SUBRULE(this.stringParameter, { LABEL: 'inner' });
            },
          },
          {
            ALT: () => {
              this.SUBRULE(this.setParameter, { LABEL: 'inner' });
            },
          },
        ],
        { NAME: 'inner' },
      );
    });

    this.RULE('orderedParameter', () => {
      this.OR([
        {
          ALT: () => {
            this.SUBRULE(this.powerToughnessParameter, { LABEL: 'inner' });
          },
        },
        {
          ALT: () => {
            this.SUBRULE(this.dollarParameter, { LABEL: 'inner' });
          },
        },
        {
          ALT: () => {
            this.SUBRULE(this.cmcParameter, { LABEL: 'inner' });
          },
        },
        {
          ALT: () => {
            this.SUBRULE(this.positiveIntegerParameter, { LABEL: 'inner' });
          },
        },
        {
          ALT: () => {
            this.SUBRULE(this.rarityParameter, { LABEL: 'inner' });
          },
        },
      ]);
    });
    this.RULE('powerToughnessParameter', () => {
      this.OR([
        {
          ALT: () => {
            this.CONSUME(power_field, { LABEL: 'field' });
          },
        },
        {
          ALT: () => {
            this.CONSUME(toughness_field, { LABEL: 'field' });
          },
        },
      ]);
      this.CONSUME(operation_token, { LABEL: 'operation' });
      this.CONSUME(power_toughness_value, { LABEL: 'value' });
    });
    this.RULE('dollarParameter', () => {
      this.OR([
        {
          ALT: () => {
            this.CONSUME(price_field, { LABEL: 'field' });
          },
        },
        {
          ALT: () => {
            this.CONSUME(foilprice_field, { LABEL: 'field' });
          },
        },
      ]);
      this.CONSUME(operation_token, { LABEL: 'operation' });
      this.CONSUME(dollar_value, { LABEL: 'value' });
    });
    this.RULE('cmcParameter', () => {
      this.CONSUME(cmc_field, { LABEL: 'field' });
      this.CONSUME(operation_token, { LABEL: 'operation' });
      this.CONSUME(cmc_value, { LABEL: 'value' });
    });
    this.RULE('positiveIntegerParameter', () => {
      this.CONSUME(loyalty_field, { LABEL: 'field' });
      this.CONSUME(operation_token, { LABEL: 'operation' });
      this.CONSUME(positive_integer_value, { LABEL: 'value' });
    });
    this.RULE('rarityParameter', () => {
      this.CONSUME(rarity_field, { LABEL: 'field' });
      this.CONSUME(operation_token, { LABEL: 'operation' });
      this.CONSUME(rarity_value, { LABEL: 'value' });
    });

    this.RULE('stringParameter', () => {
      this.OR([
        {
          ALT: () => {
            this.SUBRULE(this.plainStringParameter, { LABEL: 'inner' });
          },
        },
        {
          ALT: () => {
            this.SUBRULE(this.manaParameter, { LABEL: 'inner' });
          },
        },
      ]);
    });
    this.RULE('plainStringParameter', () => {
      this.OR([
        {
          ALT: () => {
            this.CONSUME(type_field, { LABEL: 'field' });
          },
        },
        {
          ALT: () => {
            this.CONSUME(set_field, { LABEL: 'field' });
          },
        },
        {
          ALT: () => {
            this.CONSUME(oracle_field, { LABEL: 'field' });
          },
        },
        {
          ALT: () => {
            this.CONSUME(name_field, { LABEL: 'field' });
          },
        },
        {
          ALT: () => {
            this.CONSUME(status_field, { LABEL: 'field' });
          },
        },
        {
          ALT: () => {
            this.CONSUME(artist_field, { LABEL: 'field' });
          },
        },
        {
          ALT: () => {
            this.CONSUME(tag_field, { LABEL: 'field' });
          },
        },
      ]);
      this.CONSUME(equals_operation, { LABEL: 'operation' });
      this.CONSUME(quoted_value, { LABEL: 'value' });
    });
    this.RULE('manaParameter', () => {
      this.CONSUME(mana_field, { LABEL: 'field' });
      this.CONSUME(operation_token, { LABEL: 'operation' });
      // TODO: Replace with mana_value
      this.CONSUME(string_value, { LABEL: 'value' });
    });

    this.RULE('setParameter', () => {
      this.OR([
        {
          ALT: () => {
            this.CONSUME(color_field, { LABEL: 'field' });
          },
        },
        {
          ALT: () => {
            this.CONSUME(identity_field, { LABEL: 'field' });
          },
        },
      ]);
      this.CONSUME(operation_token, { LABEL: 'operation' });
      this.AT_LEAST_ONE({
        DEF: () => {
          // TODO: Replace with mana_value
          this.CONSUME(string_value, { LABEL: 'value' });
        },
      });
    });

    this.performSelfAnalysis();
  }
}

let filter_parser = new FilterParser();

const BaseCstVisitor = filter_parser.getBaseCstVisitorConstructor();
class FilterInterpreter extends BaseCstVisitor {
  constructor(card) {
    super();
    this.validateVisitor();
  }

  filter(ctx) {
    let result = ctx.filterParameter.map((param) => {
      return this.visit(param);
    });
    return result;
  }

  filterParameter(ctx) {
    let inner = this.visit(ctx.inner);
    console.log('filterParameter');
    console.log(ctx);
    console.log(inner);
    if (ctx.negation) {
      return (card) => !inner.operation(inner.field.tokenType.field_accessor(card), inner.value);
    } else {
      return (card) => inner.operation(inner.field.tokenType.field_accessor(card), inner.value);
    }
    return this.visit(ctx.inner);
  }

  orderedParameter(ctx) {
    let { value, operation, field } = this.visit(ctx.inner);
    console.log('orderedParameter');
    console.log(field);
    // TODO: Correctly Translate this
    operation = (left, right) => true;
    return { value: value, operation: operation, field: field[0] };
  }

  powerToughnessParameter(ctx) {
    ctx.value.image = parseFloat(ctx.value.image, 10);
    return ctx;
  }

  dollarParameter(ctx) {
    let value = ctx['value'];
    if (value.getIndex(0) == '$') value.image = value.image.slice(1);
    value.image = parseFloat(value.image, 10);
    return { value: value, operation: ctx.operation, field: ctx.field };
  }

  cmcParameter(ctx) {
    ctx.value.image = parseFloat(ctx.value.image, 10);
    return ctx;
  }

  positiveIntegerParameter(ctx) {
    ctx.value.image = parseInt(ctx.value.image, 10);
    return ctx;
  }

  rarityParameter(ctx) {
    let value = ctx.value.tokenType.rarity_index;
    return { value: value, operation: ctx.operation, field: ctx.field };
  }

  stringParameter(ctx) {
    let inner = this.visit(ctx.inner);
    return (card) => {
      let { card_value, query_value } = inner(card);
      return card_value == query_value;
    };
  }

  plainStringParameter(ctx) {
    return ctx;
  }

  manaParameter(ctx) {
    return ctx;
  }

  setParameter(ctx) {
    return (card) => true;
  }
}

let filter_lexer = new Lexer(filter_lexer_modes, { position_tracking: 'onlyOffset' });
let filter_interpreter = new FilterInterpreter();

let rarity_order = ['common', 'uncommon', 'rare', 'mythic'];

let categoryMap = new Map([
  ['m', 'mana'],
  ['mana', 'mana'],
  ['cmc', 'cmc'],
  ['c', 'color'],
  ['color', 'color'],
  ['ci', 'identity'],
  ['id', 'identity'],
  ['identity', 'identity'],
  ['t', 'type'],
  ['type', 'type'],
  ['o', 'oracle'],
  ['oracle', 'oracle'],
  ['s', 'set'],
  ['set', 'set'],
  ['pow', 'power'],
  ['power', 'power'],
  ['tou', 'toughness'],
  ['toughness', 'toughness'],
  ['name', 'name'],
  ['tag', 'tag'],
  ['price', 'price'],
  ['pricefoil', 'pricefoil'],
  ['p', 'price'],
  ['pf', 'pricefoil'],
  ['status', 'status'],
  ['stat', 'status'],
  ['r', 'rarity'],
  ['rarity', 'rarity'],
  ['loy', 'loyalty'],
  ['loyalty', 'loyalty'],
  ['a', 'artist'],
  ['art', 'artist'],
  ['artist', 'artist'],
]);

function findEndingQuotePosition(filterText, num) {
  if (!num) {
    num = 1;
  }
  for (let i = 1; i < filterText.length; i++) {
    if (filterText[i] == '(') num++;
    else if (filterText[i] == ')') num--;
    if (num === 0) {
      return i;
    }
  }
  return false;
}

function tokenizeInput(filterText) {
  let evaluated_tokens = filter_lexer.tokenize(filterText);
  console.log('tokenizeInput');
  console.log(evaluated_tokens);
  return evaluated_tokens;
}

const colorMap = new Map([
  ['white', 'w'],
  ['blue', 'u'],
  ['black', 'b'],
  ['red', 'r'],
  ['green', 'g'],
  ['colorless', 'c'],
  ['azorius', 'uw'],
  ['dimir', 'ub'],
  ['rakdos', 'rb'],
  ['gruul', 'rg'],
  ['selesnya', 'gw'],
  ['orzhov', 'bw'],
  ['izzet', 'ur'],
  ['golgari', 'gb'],
  ['boros', 'wr'],
  ['simic', 'ug'],
  ['bant', 'gwu'],
  ['esper', 'wub'],
  ['grixis', 'ubr'],
  ['jund', 'brg'],
  ['naya', 'rgw'],
  ['abzan', 'wbg'],
  ['jeskai', 'urw'],
  ['sultai', 'bgu'],
  ['mardu', 'rwb'],
  ['temur', 'rug'],
]);

const rarityMap = new Map([['c', 'common'], ['u', 'uncommon'], ['r', 'rare'], ['m', 'mythic']]);

//change arguments into their verifiable counteraprts, i.e. 'azorius' becomes 'uw'
function simplifyArg(arg, category) {
  let res = arg.toLowerCase();
  switch (category) {
    case 'color':
    case 'identity':
      res = colorMap.get(res) || res;
      res = res.toUpperCase().split('');
      break;
    case 'mana':
      res = parseManaCost(res);
      break;
    case 'rarity':
      res = rarityMap.get(res) || res;
      break;
  }
  return res;
}

const verifyTokens = (tokens) => {
  filter_parser.input = tokens.tokens;
  let parsed = filter_parser.filter();
  parsed.errors = filter_parser.errors;
  console.log('verifyTokens');
  console.log(parsed);
  return parsed;
};

const hybridMap = new Map([
  ['u-w', 'w-u'],
  ['b-w', 'w-b'],
  ['b-u', 'u-b'],
  ['r-u', 'u-r'],
  ['r-b', 'b-r'],
  ['g-b', 'b-g'],
  ['g-r', 'r-g'],
  ['w-r', 'r-w'],
  ['w-g', 'g-w'],
  ['u-g', 'g-u'],
]);

function parseManaCost(cost) {
  let res = [];
  for (let i = 0; i < cost.length; i++) {
    if (cost[i] == '{') {
      let str = cost.slice(i + 1, i + 4).toLowerCase();
      if (str.search(/[wubrg]\/p/) > -1) {
        res.push(cost[i + 1] + '-p');
        i = i + 4;
      } else if (str.search(/2\/[wubrg]/) > -1) {
        res.push('2-' + cost[i + 3]);
        i = i + 4;
      } else if (str.search(/[wubrg]\/[wubrg]/) > -1) {
        let symbol = cost[i + 1] + '-' + cost[i + 3];
        if (hybridMap.has(symbol)) {
          symbol = hybridMap.get(symbol);
        }
        res.push(symbol);
        i = i + 4;
      } else if (str.search(/^[wubrgscxyz]}/) > -1) {
        res.push(cost[i + 1]);
        i = i + 2;
      } else if (str.search(/^[0-9]+}/) > -1) {
        let num = str.match(/[0-9]+/)[0];
        if (num.length <= 2) {
          res.push(num);
        }
        i = i + num.length + 1;
      }
    } else if (cost[i].search(/[wubrgscxyz]/) > -1) {
      res.push(cost[i]);
    } else if (cost[i].search(/[0-9]/) > -1) {
      let num = cost.slice(i).match(/[0-9]+/)[0];
      if (num.length <= 2) {
        res.push(num);
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
  return res;
}

const findClose = (tokens, pos) => {
  if (!pos) pos = 0;
  let num = 1;
  for (let i = pos + 1; i < tokens.length; i++) {
    if (tokens[i].type == 'close') num--;
    else if (tokens[i].type == 'open') num++;
    if (num === 0) {
      return i;
    }
  }
  return false;
};

const parseTokens = (parsed) => {
  let interpreted = filter_interpreter.visit(parsed);
  console.log('parseTokens');
  console.log(parsed);
  console.log(interpreted);
  return interpreted;
};

function filterCard(card, filters) {
  let result = filters.every((filter) => filter(card));
  console.log('filterCard');
  console.log(card);
  console.log(filters);
  console.log(result);
  return result;
}

function areArraysEqualSets(a1, a2) {
  if (a1.length != a2.length) return false;
  let superSet = {};
  for (let i = 0; i < a1.length; i++) {
    const e = a1[i] + typeof a1[i];
    superSet[e] = 1;
  }

  for (let i = 0; i < a2.length; i++) {
    const e = a2[i] + typeof a2[i];
    if (!superSet[e]) {
      return false;
    }
    superSet[e] = 2;
  }

  for (let e in superSet) {
    if (superSet[e] === 1) {
      return false;
    }
  }

  return true;
}

function arrayContainsOtherArray(arr1, arr2) {
  return arr2.every((v) => arr1.includes(v));
}

function filterApply(card, filter, inCube) {
  let res = null;
  if (filter.operand === '!=') {
    filter.not = true;
    filter.operand = '=';
  }

  if (typeof inCube === 'undefined') {
    inCube = true;
  }
  let cmc = inCube ? card.cmc : card.details.cmc;
  let colors = inCube ? card.colors : card.details.color_identity;
  if (filter.category == 'name') {
    res = card.details.name_lower.indexOf(filter.arg.toLowerCase()) > -1;
  }
  if (filter.category == 'oracle' && card.details.oracle_text) {
    res = card.details.oracle_text.toLowerCase().indexOf(filter.arg) > -1;
  }
  if (filter.category == 'color' && card.details.colors) {
    switch (filter.operand) {
      case ':':
      case '=':
        if (filter.arg.length == 1 && filter.arg[0] == 'C') {
          res = !card.details.colors.length;
        } else {
          res = areArraysEqualSets(card.details.colors, filter.arg);
        }
        break;
      case '<':
        res =
          arrayContainsOtherArray(filter.arg, card.details.colors) && card.details.colors.length < filter.arg.length;
        break;
      case '>':
        res =
          arrayContainsOtherArray(card.details.colors, filter.arg) && card.details.colors.length > filter.arg.length;
        break;
      case '<=':
        res =
          arrayContainsOtherArray(filter.arg, card.details.colors) && card.details.colors.length <= filter.arg.length;
        break;
      case '>=':
        res =
          arrayContainsOtherArray(card.details.colors, filter.arg) && card.details.colors.length >= filter.arg.length;
        break;
    }
  }
  if (filter.category == 'identity' && colors) {
    switch (filter.operand) {
      case ':':
      case '=':
        if (filter.arg.length == 1 && filter.arg[0] == 'C') {
          res = colors.length === 0;
        } else {
          res = areArraysEqualSets(colors, filter.arg);
        }
        break;
      case '<':
        res = arrayContainsOtherArray(filter.arg, colors) && colors.length < filter.arg.length;
        break;
      case '>':
        res = arrayContainsOtherArray(colors, filter.arg) && colors.length > filter.arg.length;
        break;
      case '<=':
        res = arrayContainsOtherArray(filter.arg, colors) && colors.length <= filter.arg.length;
        break;
      case '>=':
        res = arrayContainsOtherArray(colors, filter.arg) && colors.length >= filter.arg.length;
        break;
    }
  }
  if (filter.category == 'mana' && card.details.parsed_cost) {
    res = areArraysEqualSets(card.details.parsed_cost, filter.arg);
  }
  if (filter.category == 'cmc' && cmc !== undefined) {
    let arg = parseInt(filter.arg, 10);
    cmc = parseInt(cmc, 10);
    switch (filter.operand) {
      case ':':
      case '=':
        res = arg == cmc;
        break;
      case '<':
        res = cmc < arg;
        break;
      case '>':
        res = cmc > arg;
        break;
      case '<=':
        res = cmc <= arg;
        break;
      case '>=':
        res = cmc >= arg;
        break;
    }
  }
  if (filter.category == 'type' && card.details.type) {
    if (card.details.type.toLowerCase().indexOf(filter.arg.toLowerCase()) > -1) {
      res = true;
    }
  }
  if (filter.category == 'set' && card.details.set) {
    if (card.details.set.toLowerCase().indexOf(filter.arg.toLowerCase()) > -1) {
      res = true;
    }
  }
  if (filter.category == 'power') {
    if (card.details.power) {
      let cardPower = parseInt(card.details.power, 10);
      let arg = parseInt(filter.arg, 10);
      switch (filter.operand) {
        case ':':
        case '=':
          res = arg == cardPower;
          break;
        case '<':
          res = cardPower < arg;
          break;
        case '>':
          res = cardPower > arg;
          break;
        case '<=':
          res = cardPower <= arg;
          break;
        case '>=':
          res = cardPower >= arg;
          break;
      }
    }
  }
  if (filter.category == 'toughness') {
    if (card.details.toughness) {
      let cardToughness = parseInt(card.details.toughness, 10);
      let arg = parseInt(filter.arg, 10);
      switch (filter.operand) {
        case ':':
        case '=':
          res = arg == cardToughness;
          break;
        case '<':
          res = cardToughness < arg;
          break;
        case '>':
          res = cardToughness > arg;
          break;
        case '<=':
          res = cardToughness <= arg;
          break;
        case '>=':
          res = cardToughness >= arg;
          break;
      }
    }
  }
  if (filter.category == 'loyalty') {
    if (card.details.loyalty) {
      let cardLoyalty = parseInt(card.details.loyalty, 10);
      let arg = parseInt(filter.arg, 10);
      switch (filter.operand) {
        case ':':
        case '=':
          res = cardLoyalty == arg;
          break;
        case '<':
          res = cardLoyalty < arg;
          break;
        case '>':
          res = cardLoyalty > arg;
          break;
        case '<=':
          res = cardLoyalty <= arg;
          break;
        case '>=':
          res = cardLoyalty >= arg;
          break;
      }
    }
  }
  if (filter.category == 'tag') {
    res = card.tags.some((element) => {
      return element.toLowerCase() == filter.arg.toLowerCase();
    });
  }
  if (filter.category == 'status') {
    if (card.status.toLowerCase() == filter.arg.toLowerCase()) {
      res = true;
    }
  }

  if (filter.category == 'price') {
    var price = null;
    if (card.details.price) {
      price = card.details.price;
    } else if (card.details.price_foil) {
      price = card.details.price_foil;
    }
    if (price) {
      price = parseInt(price, 10);
      let arg = parseInt(filter.arg, 10);
      switch (filter.operand) {
        case ':':
        case '=':
          res = arg == price;
          break;
        case '<':
          res = price < arg;
          break;
        case '>':
          res = price > arg;
          break;
        case '<=':
          res = price <= arg;
          break;
        case '>=':
          res = price >= arg;
          break;
      }
    }
  }
  if (filter.category == 'pricefoil') {
    var price = card.details.price_foil || null;
    if (price) {
      price = parseInt(price, 10);
      let arg = parseInt(filter.arg, 10);
      switch (filter.operand) {
        case ':':
        case '=':
          res = arg == price;
          break;
        case '<':
          res = price < arg;
          break;
        case '>':
          res = price > arg;
          break;
        case '<=':
          res = price <= arg;
          break;
        case '>=':
          res = price >= arg;
          break;
      }
    }
  }
  if (filter.category == 'rarity') {
    let rarity = card.details.rarity;
    switch (filter.operand) {
      case ':':
      case '=':
        res = rarity == filter.arg;
        break;
      case '<':
        res = rarity_order.indexOf(rarity) < rarity_order.indexOf(filter.arg);
        break;
      case '>':
        res = rarity_order.indexOf(rarity) > rarity_order.indexOf(filter.arg);
        break;
      case '<=':
        res = rarity_order.indexOf(rarity) <= rarity_order.indexOf(filter.arg);
        break;
      case '>=':
        res = rarity_order.indexOf(rarity) >= rarity_order.indexOf(filter.arg);
        break;
    }
  }
  if (filter.category == 'artist') {
    res = card.details.artist.toLowerCase().indexOf(filter.arg.toLowerCase()) > -1;
  }

  if (filter.not) {
    return !res;
  } else {
    return res;
  }
}

export default {
  tokenizeInput,
  verifyTokens,
  parseTokens,
  filterCard,
  filter_lexer,
  filter_parser,
  filter_interpreter,
};
