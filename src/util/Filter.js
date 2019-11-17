import Chevrotain, {CstParser, Lexer, createToken} from 'chevrotain';

let category_token = createToken({name: 'Category', pattern: Lexer.NA});
let string_value_category = createToken({name: 'StringValueCategory', pattern: Lexer.NA});
let ordered_value_category = createToken({name: 'OrderedValueCategory', pattern: Lexer.NA});
let set_value_category = createToken({name: 'SetValueCategory', pattern: Lexer.NA});
let operation_token = createToken({name: 'Operation', pattern: Lexer.NA});

let colon_operation = createToken({name: 'ColonOperation', pattern: /:/, push_mode: 'value',
                                   categories: ['operation_token']});
let less_than_operation = createToken({name: 'LessThanOperation', pattern: /</, push_mode: 'value',
                                       categories: ['operation_token']});
let greater_than_operation = createToken({name: 'GreaterThanOperation', pattern: />/, push_mode: 'value',
                                          categories: ['operation_token']});
let less_or_equal_operation = createToken({name: 'LessOrEqualOperation', pattern: /<=/, push_mode: 'value',
                                           categories: ['operation_token']});
let greater_or_equal_operation = createToken({name: 'GreaterOrEqualOperation', pattern: />=/, push_mode: 'value',
                                              categories: ['operation_token']});
let equals_operation = createToken({name: 'EqualsOperation', pattern: /=/, push_mode: 'value',
                                    categories: ['operation_token']});

let negation_operator = createToken({name: 'NegationOperator', pattern: /-/});

let type_category = createToken({name: "TypeCategory", pattern: /t(ype)?/, push_mode: 'operation',
                                 categories: [category_token, string_value_category]});
let oracle_category = createToken({name: "OracleCategory", pattern: /o(racle)?/, push_mode: 'operation',
                                   categories: [category_token, string_value_category]});
let set_category = createToken({name: "SetCategory", pattern: /s(et)?/, push_mode: 'operation',
                                categories: [category_token, string_value_category]});
let name_category = createToken({name: "NameCategory", pattern: /name/, push_mode: 'operation',
                                 categories: [category_token, string_value_category]});
let status_category = createToken({name: "StatusCategory", pattern: /stat(us)?/, push_mode: 'operation',
                                   categories: [category_token, string_value_category]});
let artist_category = createToken({name: "ArtistCategory", pattern: /a(rt(ist)?)?/, push_mode: 'operation',
                                   categories: [category_token, string_value_category]});
let mana_category = createToken({name: "ManaCategory", pattern: /m(ana)?/, push_mode: 'operation',
                                 categories: [category_token, string_value_category]});
let tag_category = createToken({name: "TagCategory", pattern: /tag/, push_mode: 'operation',
                                categories: [category_token, string_value_category]});

let power_category = createToken({name: "PowerCategory", pattern: /pow(er)?/, push_mode: 'operation',
                                  categories: [category_token, ordered_value_category]});
let toughness_category = createToken({name: "ToughnessCategory", pattern: /tou(ghness)?/, push_mode: 'operation',
                                      categories:[category_token, ordered_value_category]});
let price_category = createToken({name: "PriceCategory", pattern: /p(rice)?/, push_mode: 'operation',
                                 categories: [category_token, ordered_value_category]});
let foilprice_category = createToken({name: "Category", pattern: /((fp)|(foilprice)|(pricefoil)|(pf))/, push_mode: 'operation',
                                      categories:[category_token, ordered_value_category]});
let cmc_category = createToken({name: "CmcCategory", pattern: /c(mc)?/, push_mode: 'operation',
                                categories: [category_token, ordered_value_category]});
let loyalty_category = createToken({name: "LoyaltyCategory", pattern: /loy(alty)?/, push_mode: 'operation',
                                    categories:[category_token, ordered_value_category]});
let rarity_category = createToken({name: "RarityCategory", pattern: /r(arity)?/, push_mode: 'operation',
                                   categories: [category_token, ordered_value_category]});

let color_category = createToken({name: "ColorCategory", pattern: /c(olor)?/, push_mode: 'operation',
                                  categories: [category_token, set_value_category]});
let identity_category = createToken({name: "IdentityCategory", pattern: /((ci)|(id(entity)?))/, push_mode: 'operation',
                                     categories: [category_token, set_value_category]});

let string_value = createToken({name: "StringValue", pattern: /[^\s"]+/, push_mode: 'field'});
let quoted_value = createToken({name: "QuotedValue", pattern: /"((\\")|(\\n)|[^\\"])+"/, push_mode: 'field',
                                categories: [string_value]});
// TODO: regex_value
// TODO: mana_value
let dollar_value = createToken({name: "DollarValue", pattern: /\$?((\d+(\.\d{1,2}?)?)|(\.\d{1,2}))/, push_mode: 'field',
                                categories: [string_value]})
let power_toughness_value = createToken({name: "PowerToughnessValue", pattern: /(-?\d+)|(\d+(\.5)?)/, push_mode: 'field',
                                         categories: [string_value]});
let cmc_value = createToken({name: "CmcValue", pattern: /(0?\.5)|(\d+)/, push_mode: 'field',
                             categories: [string_value, power_toughness_value, dollar_value]});
let positive_integer_value = createToken({name: "PositiveIntegerValue", pattern: /\d+/, push_mode: 'field',
                                          categories: [string_value, power_toughness_value, cmc_value, dollar_value]});
let rarity_value = createToken({name: "RarityValue", pattern: Lexer.NA});
let common_value = createToken({name: "CommonValue", pattern: /c(ommon)?/, push_mode: 'field',
                                categories: [string_value, rarity_value]});
common_value.rarity_index = 0
let uncommon_value = createToken({name: "UncommonValue", pattern: /u(ncommon)?/, push_mode: 'field',
                                  categories: [string_value, rarity_value]});
uncommon_value.rarity_index = 1
let rare_value = createToken({name: "RareValue", pattern: /r(are)?/, push_mode: 'field',
                              categories: [string_value, rarity_value]});
rare_value.rarity_index = 2
let mythic_value = createToken({name: "MythicValue", pattern: /m(ythic)?/, push_mode: 'field',
                                categories: [string_value, rarity_value]});
mythic_value.rarity_index = 3
let whitespace_token = createToken({name: "WhiteSpace", pattern: /\s+/, group: Lexer.SKIPPED})
let filter_tokens = [category_token, string_value_category, ordered_value_category, set_value_category,
                     mana_category, cmc_category, color_category, identity_category,
                     type_category, oracle_category, set_category, power_category, toughness_category,
                     name_category, tag_category, price_category, foilprice_category,
                     status_category, rarity_category, loyalty_category, artist_category,
                     cmc_value, power_toughness_value, dollar_value, positive_integer_value, 
                     rarity_value, common_value, uncommon_value, rare_value, mythic_value,
                     string_value, quoted_value, whitespace_token];
let filter_lexer_modes = {
    modes: {
        field: [
            negation_operator, type_category, oracle_category, set_category, name_category, status_category,
            artist_category, mana_category, tag_category, power_category, toughness_category, price_category,
            foilprice_category, cmc_category, loyalty_category, rarity_category, color_category, identity_category,
            whitespace_token
        ],
        operation: [
            colon_operation, less_than_operation, greater_than_operation, less_or_equal_operation,
            greater_or_equal_operation, equals_operation, whitespace_token
        ],
        value: [
            quoted_value, positive_integer_value, cmc_value, power_toughness_value, dollar_value, common_value,
            uncommon_value, rare_value, mythic_value, string_value
        ]
    },
    defaultMode: 'field'
}


class FilterParser extends CstParser {
  constructor() {
    super(filter_tokens);

    this.RULE("filter", () => {
      this.AT_LEAST_ONE({ DEF: () => {
        this.SUBRULE(this.filterParameter);
      } });
    });

    this.RULE("filterParameter", () => {
      this.OR([
        { ALT: () => { this.SUBRULE(this.orderedParameter); } },
        { ALT: () => { this.SUBRULE(this.stringParameter); } },
        { ALT: () => { this.SUBRULE(this.setParameter); } }
      ]);
    });

    this.RULE('orderedParameter', () => {
      this.OR([
        { ALT: () => { this.SUBRULE(this.powerToughnessParameter); } },
        { ALT: () => { this.SUBRULE(this.dollarParameter); } },
        { ALT: () => { this.SUBRULE(this.cmcParameter); } },
        { ALT: () => { this.SUBRULE(this.positiveIntegerParameter); } },
        { ALT: () => { this.SUBRULE(this.rarityParameter); } },
      ]);
    });
    this.RULE('powerToughnessParameter', () => {
      this.OR([
        { ALT: () => { this.CONSUME(power_category); } },
        { ALT: () => { this.CONSUME(toughness_category); } }
      ]);
      this.CONSUME(operation_token);
      this.CONSUME(power_toughness_value);
    });
    this.RULE('dollarParameter', () => {
      this.OR([
        { ALT: () => { this.CONSUME(price_category); } },
        { ALT: () => { this.CONSUME(foilprice_category); } }
      ]);
      this.CONSUME(operation_token);
      this.CONSUME(dollar_value);
    });
    this.RULE('cmcParameter', () => {
      this.CONSUME(cmc_category);
      this.CONSUME(operation_token);
      this.CONSUME(cmc_value);
    });
    this.RULE('positiveIntegerParameter', () => {
      this.CONSUME(loyalty_category);
      this.CONSUME(operation_token);
      this.CONSUME(positive_integer_value);
    });
    this.RULE('rarityParameter', () => {
      this.CONSUME(rarity_category);
      this.CONSUME(operation_token);
      this.CONSUME(rarity_value);
    });

    this.RULE("stringParameter", () => {
      this.OR([
        { ALT: () => { this.SUBRULE(this.plainStringParameter); } },
        { ALT: () => { this.SUBRULE(this.manaParameter); } }
      ]);
    });
    this.RULE("plainStringParameter", () => {
      this.OR([
        { ALT: () => { this.CONSUME(type_category); } },
        { ALT: () => { this.CONSUME(set_category); } },
        { ALT: () => { this.CONSUME(oracle_category); } },
        { ALT: () => { this.CONSUME(name_category); } },
        { ALT: () => { this.CONSUME(status_category); } },
        { ALT: () => { this.CONSUME(artist_category); } },
        { ALT: () => { this.CONSUME(tag_category); } }
      ]);
      this.CONSUME(equals_operation);
      this.CONSUME(quoted_value);
    });
    this.RULE("manaParameter", () => {
      this.CONSUME(mana_category);
      this.CONSUME(operation_token);
      // TODO: Replace with mana_value
      this.CONSUME(string_value);
    });
        
    this.RULE("setParameter", () => {
      this.OR([
        { ALT: () => { this.CONSUME(color_category); } },
        { ALT: () => { this.CONSUME(identity_category); } }
      ]);
      this.CONSUME(operation_token);
      this.AT_LEAST_ONE({ DEF: () => {
        // TODO: Replace with mana_value
        this.CONSUME(string_value);
      } });
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
    return ctx.filterParameter.map(param => { return this.visit(param); });
  }

  filterParameter(ctx) {
    return this.visit(ctx[Object.keys(ctx)[0]]);
  }

  orderedParameter(ctx) {
    let inner = this.visit(ctx[Object.keys(ctx)[0]]);
    return (card) => {
      let {card_value, query_value} = inner(card);
      return card_value == query_value;
    }
  }

  powerToughnessParameter(ctx) {
    console.log('powerToughnessParameter');
    console.log(ctx);
    return (card) => true;
  }

  dollarParameter(ctx) {
    console.log('dollarParameter');
    console.log(ctx);
    // if (result[0] == '$') result = result.slice(1)
    return (card) => true;
  }

  cmcParameter(ctx) {
    console.log('cmcParameter');
    console.log(ctx);
    return (card) => true;
  }

  positiveIntegerParameter(ctx) {
    console.log('positiveIntegerParameter');
    console.log(ctx);
    return (card) => true;
  }
  
  rarityParameter(ctx) {
    console.log('rarityParameter');
    let rarity = ctx.RarityValue[0];
    console.log(rarity);
    return (card) => {
      return {
        card_value: rarityOrder.indexOf[card.details.rarity],
        query_value: rarity.tokenType.rarity_index
      };
    };
  }
  
  stringParameter(ctx) {
    let inner = this.visit(ctx[Object.keys(ctx)[0]]);
    return (card) => {
      let {card_value, query_value} = inner(card);
      return card_value == query_value;
    }
  }
  
  plainStringParameter(ctx) {
    console.log('plainStringParameter');
    console.log(ctx);
    return (card) => true;
  }
  
  manaParameter(ctx) {
    console.log('manaParameter');
    console.log(ctx);
    return (card) => true;
  }
  
  setParameter(ctx) {
    let inner = this.visit(ctx[Object.keys(ctx)[0]]);
    return (card) => {
      let {card_value, query_value} = inner(card);
      return card_value == query_value;
    }
  }
}

let filter_lexer = new Lexer(filter_lexer_modes, { positionTracking: 'onlyStart' });
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

function tokenizeInput(filterText, tokens) {
  filterText = filterText.trim().toLowerCase();
  if (!filterText) {
    return true;
  }

  const operators = '>=|<=|<|>|:|!=|=';
  //split string based on list of operators
  let operators_re = new RegExp('(?:' + operators + ')');

  if (filterText.indexOf('(') == 0) {
    if (findEndingQuotePosition(filterText, 0)) {
      let token = {
        type: 'open',
      };
      tokens.push(token);
      return tokenizeInput(filterText.slice(1), tokens);
    } else {
      return false;
    }
  }

  if (filterText.indexOf(')') == 0) {
    let token = {
      type: 'close',
    };
    tokens.push(token);
    return tokenizeInput(filterText.slice(1), tokens);
  }

  if (filterText.indexOf('or ') == 0 || (filterText.length == 2 && filterText.indexOf('or') == 0)) {
    tokens.push({
      type: 'or',
    });
    return tokenizeInput(filterText.slice(2), tokens);
  }

  if (filterText.indexOf('and ') == 0 || (filterText.length == 3 && filterText.indexOf('and') == 0)) {
    return tokenizeInput(filterText.slice(3), tokens);
  }

  let token = {
    type: 'token',
    not: false,
  };

  //find not
  if (filterText.indexOf('-') == 0) {
    token.not = true;
    filterText = filterText.slice(1);
  }

  let firstTerm = filterText.split(' ', 1);

  //find operand
  let operand = firstTerm[0].match(operators_re);
  if (operand) {
    token.operand = operand[0];
  } else {
    token.operand = 'none';
  }

  let quoteOp_re = new RegExp('(?:' + operators + ')"');
  let parens = false;

  //find category
  let category = '';
  if (token.operand == 'none') {
    category = 'name';
  } else {
    category = firstTerm[0].split(operators_re)[0];
  }

  //find arg value
  //if there are two quotes, and first char is quote
  if (filterText.indexOf('"') == 0 && filterText.split('"').length > 2) {
    //grab the quoted string, ignoring escaped quotes
    let quotes_re = new RegExp('"([^"\\\\]*(?:\\\\.[^"\\\\]*)*)"');
    //replace escaped quotes with plain quotes
    token.arg = filterText.match(quotes_re)[1];
    parens = true;
  } else if (firstTerm[0].search(quoteOp_re) > -1 && filterText.split('"').length > 2) {
    //check if there is a paren after an operator
    //TODO: make sure the closing paren isn't before the operator
    let quotes_re = new RegExp('"([^"\\\\]*(?:\\\\.[^"\\\\]*)*)"');
    token.arg = filterText.match(quotes_re)[1];
    parens = true;
  } else if (token.operand != 'none') {
    token.arg = firstTerm[0].slice(category.length + token.operand.length).split(')')[0];
  } else {
    token.arg = firstTerm[0].split(')')[0];
  }

  filterText = filterText.slice(
    (token.operand == 'none' ? token.arg.length : token.arg.length + token.operand.length + category.length) +
      (parens ? 2 : 0),
  );

  if (!categoryMap.has(category)) {
    return false;
  }

  token.category = categoryMap.get(category);
  token.arg = simplifyArg(token.arg, token.category);
  if (token.operand && token.category && token.arg) {
    //replace any escaped quotes with normal quotes
    if (parens) token.arg = token.arg.replace(/\\"/g, '"');
    tokens.push(token);
    return tokenizeInput(filterText, tokens);
  } else {
    return false;
  }
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
  let temp = tokens;
  let inBounds = (num) => {
    return num > -1 && num < temp.length;
  };
  let type = (i) => temp[i].type;
  let token = (i) => temp[i];

  for (let i = 0; i < temp.length; i++) {
    if (type(i) == 'open') {
      let closed = findClose(temp, i);
      if (!closed) return false;
      temp[closed].valid = true;
    }
    if (type(i) == 'close') {
      if (!temp[i].valid) return false;
    }
    if (type(i) == 'or') {
      if (!inBounds(i - 1) || !inBounds(i + 1)) return false;
      if (!(type(i - 1) == 'close' || type(i - 1) == 'token')) return false;
      if (!(type(i + 1) != 'open' || type(i + 1) != 'token')) return false;
    }
    if (type(i) == 'token') {
      switch (token(i).category) {
        case 'color':
        case 'identity':
          let verifyColors = (element) => {
            return element.search(/^[WUBRGC]$/) < 0;
          };
          if (token(i).arg.every(verifyColors)) {
            return false;
          }
          break;
        case 'power':
        case 'toughness':
          if (token(i).arg.search(/^[-\+]?((\d+(\.5)?)|(\.5))$/) < 0) return false;
          break;
        case 'cmc':
          if (token(i).arg.search(/^\+?((\d+(\.5)?)|(\.5))$/) < 0) return false;
          break;
        case 'loyalty':
          if (token(i).arg.search(/^\d+$/) < 0) return false;
          break;
        case 'mana':
          let verifyMana = (element) => {
            element.search(/^(\d+|[wubrgscxyz]|{([wubrg2]\-[wubrg]|[wubrg]\-p)})$/) < 0;
          };
          if (token(i).arg.every(verifyMana)) {
            return false;
          }
          break;
        case 'rarity':
          if (token(i).arg.search(/^(common|uncommon|rare|mythic)$/) < 0) return false;
          break;
        case 'artist':
          return true;
      }
    }
  }
  return true;
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

const parseTokens = (tokens) => {
  let peek = () => tokens[0];
  let consume = peek;

  let result = [];
  if (peek().type == 'or') {
    return parseTokens(tokens.slice(1));
  }
  if (peek().type == 'open') {
    let end = findClose(tokens);
    if (end < tokens.length - 1 && tokens[end + 1].type == 'or') result.type = 'or';
    result.push(parseTokens(tokens.slice(1, end)));
    if (tokens.length > end + 1) result.push(parseTokens(tokens.slice(end + 1)));
    return result;
  } else if (peek().type == 'token') {
    if (tokens.length == 1) {
      return consume();
    } else {
      if (tokens[1].type == 'or') result.type = 'or';
      result.push(consume());
      result.push(parseTokens(tokens.slice(1)));
      return result;
    }
  }
};

/* inCube should be true when we are using a cube's card object and false otherwise (e.g. in Top Cards). */
function filterCard(card, filters, inCube) {
  if (filters.length == 1) {
    if (filters[0].type == 'token') {
      return filterApply(card, filters[0], inCube);
    } else {
      return filterCard(card, filters[0], inCube);
    }
  } else {
    if (filters.type == 'or') {
      return (
        (filters[0].type == 'token' ? filterApply(card, filters[0], inCube) : filterCard(card, filters[0], inCube)) ||
        (filters[1].type == 'token' ? filterApply(card, filters[1], inCube) : filterCard(card, filters[1], inCube))
      );
    } else {
      return (
        (filters[0].type == 'token' ? filterApply(card, filters[0], inCube) : filterCard(card, filters[0], inCube)) &&
        (filters[1].type == 'token' ? filterApply(card, filters[1], inCube) : filterCard(card, filters[1], inCube))
      );
    }
  }
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

export default { tokenizeInput, verifyTokens, parseTokens, filterCard,
                 filter_lexer, filter_parser, filter_interpreter };
