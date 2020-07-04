@builtin "whitespace.ne"
# Base on https://github.com/Soothsilver/mtg-grammar/blob/master/mtg.g4

card -> "\n":* ability ("\n":+ ability):* {% ([, a, as]) => [a, ...as.map(([, a2]) => a2)] %}
ability -> (abilityWordAbility
  | activatedAbility
  | additionalCostToCastSpell
  | keywords
  | modalAbility
  | staticOrSpell
  | triggeredAbility
  | continuousEffect
) ".":? (_ reminderText):? {% ([[a]]) => a %}

reminderText -> "(" [^)]:+ ")"

modalAbility -> "choose"i _ modalQuantifier _ DASHDASH modalOption ("\n" modalOption):* {% ([, , quantifier, , , option, options]) => ({ quantifier, options: [option, ...options.map(([, o]) => o)] }) %}
modalOption -> ("*" | "•") _ effect {% ([, , e]) => e %}
modalQuantifier -> "one or both"i {% () => [1, 2] %}
  | "one" {% () => [1] %}

keywords -> keyword (("," | ";") _ keyword):* {% ([k1, ks]) => [k1].concat(ks.map(([, , k]) => k)) %}
# Keep this in the same order as 702 to make verification easy.
keyword -> ("deathtouch"i
  | "defender"i
  | "double strike"i
  | enchantKeyword
  | equipKeyword
  | "first strike"i
  | "flash"i
  | "flying"i
  | "haste"i
  | "hexproof"i
  | "indestructible"i
  | "intimidate"i
  | landwalkKeyword
  | "lifelink"i
  | protectionKeyword
  | "reach"i
  | "shroud"i
  | "trample"i
  | "vigilance"i
  | bandingKeyword
  | rampageKeyword
  | cumulativeUpkeepKeyword
  | "flanking"i
  | "phasing"i
  | buybackKeyword
  | "shadow"i
  | cyclingKeyword
  | echoKeyword
  | "horsemanship"
  | fadingKeyword
  | kickerKeyword
  | flashbackKeyword
  | madnessKeyword
  | "fear"i
  | morphKeyword
  | amplifyKeyword
  | "provoke"i
  | "storm"i
  | affinityKeyword
  | entwineKeyword
  | modularKeyword
  | "sunburst"i
  | bushidoKeyword
  | soulshiftKeyword
  | spliceKeyword
  | offeringKeyword
  | ninjutsuKeyword
  | "epic"i
  | "convoke"i
  | dredgeKeyword
  | transmuteKeyword
  | bloodthirstKeyword
  | "haunt"i
  | replicateKeyword
  | forecastKeyword
  | graftKeyword
  | recoverKeyword
  | rippleKeyword
  | "split second"i
  | suspendKeyword
  | vanishingKeyword
  | absordKeyword
  | auraSwapKeyword
  | "delve"i
  | fortifyKeyword
  | frenzyKeyword
  | "gravestorm"i
  | poisonousKeyword
  | transfigureKeyword
  | championKeyword
  | "changeling"i
  | evokeKeyword
  | "hideaway"i
  | prowlKeyword
  | reinforceKeyword
  | "conspire"i
  | "persist"i
  | "wither"i
  | "retrace"i
  | devourKeyword
  | "exalted"i
  | unearthKeyword
  | "cascade"i
  | annihilatorKeyword
  | levelUpKeyword
  | "rebound"i
  | "totem armor"i
  | "infect"i
  | "battle cry"i
  | "living weapon"i
  | "undying"i
  | miracleKeyword
  | "soulbond"i
  | overloadKeyword
  | scavengeKeyword
  | "unleash"i
  | "cipher"i
  | "evolve"i
  | "extort"i
  | "fuse"i
  | bestowKeyword
  | tributeKeyword
  | "dethrone"i
  | "hidden agenda"i
  | outlastKeyword
  | "prowess"i
  | dashKeyword
  | "exploit"i
  | "menace"i
  | renownKeyword
  | awakenKeyword
  | "devoid"i
  | "ingest"i
  | "myriad"i
  | surgeKeyword
  | "skulk"i
  | emergeKeyword
  | escalateKeyword
  | "melee"i
  | crewKeyword
  | fabricateKeyword
  | partnerKeyword
  | "undaunted"i
  | "improvise"i
  | "aftermath"i
  | embalmKeyword
  | eternalizeKeyword
  | afflictKeyword
  | "ascend"i
  | "assist"i
  | "jump-start"i
  | "mentor"i
  | afterlifeKeyword
  | "riot"i
  | spectacleKeyword
  | escapeKeyword
  | companionKeyword
  | mutateKeyword) {% ([[keyword]]) => ({ keyword }) %}
cyclingKeyword -> "cycling"i _ cost {% ([, , cost]) => ({ cycling: cost }) %}
enchantKeyword -> "enchant"i _ anyEntity {% ([, , entity]) => ({ enchant: entity }) %}
equipKeyword -> "equip"i _ cost {% ([, , cost]) => ({ equip: cost }) %}
cumulativeUpkeepKeyword -> "cumulative upkeep"i _ cost {% ([, , cumulativeUpkeep]) => ({ cumulativeUpkeep }) %}
escapeKeyword -> "escape"i _ cost {% ([, , escape]) => ({ escape }) %}
spectacleKeyword -> "spectacle"i _ cost {% ([, , spectacle]) => ({ spectacle }) %}
afterlifeKeyword -> "afterlife"i _ number {% ([, , afterlife]) => ({ afterlife }) %}
afflictKeyword -> "afflict"i _ number {% ([, , afflict]) => ({ afflict }) %}
eternalizeKeyword -> "eternalize"i _ cost {% ([, , eternalize]) => ({ eternalize }) %}
embalmKeyword -> "embalm"i _ cost {% ([, , embalm]) => ({ embalm }) %}
partnerKeyword -> "partner"i {% () => "partner" %}
  | "partner with"i [^\n]:+ {% ([, partnerWith]) => ({ partnerWith: partnerWith.join('') }) %}
fabricateKeyword -> "fabricate"i _ number {% ([, , fabricate]) => ({ fabricate }) %}
crewKeyword -> "crew"i _ number {% ([, , crew]) => ({ crew }) %}
escalateKeyword -> "escalate"i _ cost {% ([, , escalate]) => ({ escalate }) %}
emergeKeyword -> "emerge"i _ cost {% ([, , emerge]) => ({ emerge }) %}
surgeKeyword -> "surge"i _ cost {% ([, , surge]) => ({ surge }) %}
awakenKeyword -> "awaken"i _ cost {% ([, , awaken]) => ({ awaken }) %}
renownKeyword -> "renown"i _ number {% ([, , renown]) => ({ renown }) %}
dashKeyword -> "dash"i _ cost {% ([, , dash]) => ({ dash }) %}
outlastKeyword -> "outlast"i _ cost {% ([, , outlast]) => ({ outlast }) %}
tributeKeyword -> "tribute"i _ number {% ([, , tribute]) => ({ tribute }) %}
mutateKeyword -> "mutate"i _ cost {% ([, , mutate]) => ({ mutate }) %}
bestowKeyword -> "bestow"i _ cost {% ([, , bestow]) => ({ bestow }) %}
scavengeKeyword -> "scavenge"i _ cost {% ([, , scavenge]) => ({ scavenge }) %}
overloadKeyword -> "overload"i _ cost {% ([, , overload]) => ({ overload }) %}

abilityWordAbility -> abilityWord _ DASHDASH _ ability {% ([aw, , , , a]) => ({ [aw]: a }) %}
abilityWord ->  ("adamant"i
  | "addendum"i
  | "battalion"i
  | "bloodrush"i
  | "channel"i
  | "chroma"i
  | "cohort"i
  | "constellation"i
  | "converge"i
  | "council's dilemma"i
  | "delirium"i
  | "domain"i
  | "eminence"i
  | "enrage"i
  | "fateful hour"i
  | "ferocious"i
  | "formidable"i
  | "grandeur"i
  | "hellbent"i
  | "heroic"i
  | "imprint"i
  | "inspired"i
  | "join forces"i
  | "kinship"i
  | "landfall"i
  | "lieutenant"i
  | "metalcraft"i
  | "morbid"i
  | "parley"i
  | "radiance"i
  | "raid"i
  | "rally"i
  | "revolt"i
  | "spell mastery"i
  | "strive"i
  | "sweep"i
  | "temptingoffer"i
  | "threshold"i
  | "undergrowth"i
  | "will of the council"i) {% ([[aw]]) => aw %}

activatedAbility -> costs ":" _ effect (_ activationInstructions):? {% ([costs, , , effect, i]) => {
  const result = { costs, effect };
  if (i) result.instructions = i;
  return result;
} %}
activationInstructions -> "activate this ability only "i activationInstruction "." {% ([, i]) => ({ only: i }) %}
  | "any player may activate this ability."i {% () => "anyPlayer" %}
activationInstruction -> "once each turn"i {% () => "onceATurn" %}
  | "any time you could cast a sorcery"i {% () => "sorceryOnly" %}
# TODO: Make into AST
activatedAbilities -> (itsPossessive _):? "activated abilities"i
activatedAbilitiesVP -> "can't be activated"i

triggeredAbility -> triggerCondition "," _ interveningIfClause:? effect {% ([condition, , , ifClause, effect]) => {
  const result = { condition, effect };
  if (ifClause) result.ifClause = ifClause
  return result;
} %}
triggerCondition -> ("when"i | "whenever"i) _ triggerConditionInner (_ triggerTiming):? {% ([, , inner, timing]) => {
  const result = { when: inner };
  if (timing) result.timing = timing[1];
  return result;
} %}
  | "at the beginning of"i _ qualifiedPartOfTurn {% ([, , turnPhase]) => ({ turnPhase }) %}
  | "at end of combat"i {% () => ({ turnPhase: "endCombat" }) %}
triggerConditionInner -> singleSentence {% ([s]) => s %}
  | "you cast "i object {% ([, cast]) => ({ cast }) %}
  | player _ gains _ "life"i {% ([actor]) => ({ actor, action: "gainsLife" }) %}
  | object " is dealth damage"i {% ([actor]) => ({ actor, action: "dealtDamage" }) %}
interveningIfClause -> "if "i condition "," {% ([, c]) => c %}
triggerTiming -> "each turn"i {% () => "eachTurn" %}
  | "during each opponent" SAXON _ "turn" {% () => "eachOpponentTurn" %}

additionalCostToCastSpell -> "as an additional cost to cast this spell," _ imperative "." {% ([, , additionalCost]) => ({ additionalCost }) %}

staticOrSpell -> sentenceDot {% ([sd]) => sd %}
effect -> (sentenceDot
  | modalAbility) {% ([[e]]) => e %}

sentenceDot -> sentence "." (_ additionalSentence):* {% ([s, , ss]) => [s, ...ss.map(([, s2]) => s2)] %}
additionalSentence -> sentence "." {% ([s]) => s %}
  | triggeredAbility {% ([t]) => t %}

sentence -> singleSentence {% ([ss]) => ss %}
  | "Then" _ sentence {% ([, , s]) => s %}
  | singleSentence (",":? (("then"i | "and"i):? _):? sentence):+ # TODO: ASTize
  | "otherwise,"i _ sentence {% ([, , otherwise]) => ({ otherwise }) %}
singleSentence -> imperative {% ([i]) => i %}
  | singleSentence _ "and"i _ singleSentence # TODO: ASTize and check if is ambiguous
  | singleSentence ", where X is"i _ numberDefinition {% ([singleSentence, , , X]) => ({ singleSentence, X }) %}
  | object _ objectVerbPhrase {% ([what, , does]) => { what, does } %}
  | IT_S _ isWhat {% ([, , is]) => ({ is }) %}
  | player _ playerVerbPhrase {% ([actor, , does]) => { actor, does } %}
  | "if"i _ sentence "," _ replacementEffect # TODO: ASTize
  | "if"i _ condition "," _ sentence {% ([, , condition, , , effect]) => ({ condition, effect }) %}
  | "if"i _ object _ "would"i (objectVerbPhrase | objectInfinitive) "," _ sentenceInstead # TODO: ASTize
  | "if"i _ player _ "would"i _ playerVerbPhrase "," _ sentenceInstead # TODO: ASTize
  | asLongAsClause "," _ sentence {% ([asLongAs, , , effect]) => ({ asLongAs, effect }) %}
  | duration "," _ sentence {% ([duration, , , effect]) => ({ duration, effect }) %}
  | "for each"i _ object "," _ sentence {% ([, , forEach, , , effect]) => ({ forEach, effect }) %}
  | activatedAbilities _ activatedAbilitiesVP # TODO: ASTize
  | itsPossessive _ numericalCharacteristic _ "is equal to"i _ numberDefinition # TODO: ASTize
  | "as"i sentence "," _ sentence # TODO: ASTize
sentenceInstead -> sentence _ "instead"i {% ([instead]) => ({ instead }) %}
  | "instead"i _ sentence {% ([, ,instead]) => ({ instead }) %}

forEachClause -> "for each" _ pureObject {% ([, , forEach]) => ({ forEach }) %}
 | "for each color of mana spent to cast"i _ object {% ([, , forEachColorSpent]) => ({ forEachColorSpent }) %}

condition -> sentence
  | YOU_VE _ action _ duration
  | IT_S _ "your turn"i
  | IT_S _ "not" _ playersPossessive _ "turn" {% ([, , notTurnOf]) => ({ notTurnOf }) %}
  | object _ "has"i countableCount _ (counterKind _):? "counters on it"i
  | numberDefinition _ "is"i _ numericalComparison
  | "that mana is spent on"i _ object
  | "is paired with another creature"i

action -> "scried"
  | "surveiled"

entity -> object
  | player
anyEntity -> object
  | pureObject
  | player
  | purePlayer
player -> "you"i
  | "they"i
  | commonReferencingPrefix _ purePlayer
  | "your" _ ("opponent" | "opponents")
  | "defending player"
  | itsPossessive _ ("controller"i | "owner"i | "owners"i | "controllers"i)
  | player _ "who" _ CAN_T
purePlayer -> "opponent"i
  | "player"i
  | "players"i
  | "opponents"i
object -> CARD_NAME {% () => "CARD_NAME" %}
  | "it"i {% () => "it" %}
  | "them"i {% () => "them" %}
  | "they"i {% () => "they" %}
  | "the rest"i {% () => "rest" %}
  | "the other"i {% () => "other" %}
  | "this emblem"i {% () => "emblem" %}
  | referencingObjectPrefix _ object {% ([reference, , object]) => ({ reference, object }) %}
  | object _ THAT_S _ isWhat {% ([object, , , , condition]) => ({ object, condition }) %}
  | object ("," _ object):* ",":? _ ("and"i {% () => "and" %} | "or"i {% () => "xor" %} | "and/or"i {% () => "or" %}) _ object {% ([o, os, , , connector, , o2]) => ({ [connector]: [o, ...os.map(([, , o3]) => o3), o2] }) %}
  | cumulativeReferencingPrefix pureObject {% ([cumulativeReference, object]) => ({ cumulativeReference, object }) %}
  | pureObject {% ([po]) => po %}
  | "each of"i _ object {% ([, , eachOf]) => ({ eachOf }) %}
  | "the top"i _ englishNumber _ "cards of"i _ zone {% ([, , topCards, , , , from]) => ({ topCards, from }) %}
  | "the top card of"i _ zone {% ([, , from]) => ({ topCards: 1, from }) %}
suffix -> player _ ((DON_T | DOESN_T) _):? ("control"i | "own"i) "s":?
  | "in"i _ zone (_ "and in"i _ zone):?
  | "from"i _ zone
  | "you cast"i
  | "that targets only"i _ object
  | "tapped this way"i
  | ("destroyed"i | "exiled"i) _ (fromZone _):? "this way"i
  | "of the"i _ anyType _ "type of"i _ playersPossessive _ "choice"i
  | object _ "could target"i
  | "able to block"i _ object
  | "that convoked"i _ object
  | "from among them"i
  | "named"i _ CARD_NAME
  | YOU_VE _ "cast before it this turn"i
  | "not named"i _ CARD_NAME {% ([, , notNamed]) => { notNamed } %}
pureObject -> prefix:+ _ pureObject
  | "copy"i (_ "of" _ object):?
  | "copies"i
  | "card"i
  | anyType "s":?
  | cumulativeReferencingPrefix _ pureObject
  | pureObject ("," _ pureObject):* _ ("and"i | "or"i | "and/or"i) _ pureObject
  | pureObject _ "without"i _ keyword
  | pureObject _ withClause
  | pureObject _ suffix
referencingObjectPrefix -> "the sacrificed"i
  | "the exiled"i
  | "any of"i
  | "the"i
  | commonReferencingPrefix
  | countableCount
cumulativeReferencingPrefix -> "other"i
  | "equipped"i
commonReferencingPrefix -> "each"i
  | "all"i (_ "the"):?
  | "this"i
  | "enchanted"i
  | "that"i
  | "these"i
  | "those"i
  | "another"i
  | "an"i
  | "a"i
  | "the chosen"i
  | "at least"i _ englishNumber
  | countableCount (_ commonReferencingPrefix):?
  | ("another"i _):? (countableCount _):? "target"i "s":? 
prefix -> "enchanted"i
  | "attached"i
  | "equipped"i
  | "non"i ("-" | _):? anyType
  | "exiled"i
  | anyType
  | "token"i
  | "nontoken"i
  | color
  | "tapped"i
  | "untapped"i
  | pt
  | "legendary"i
  | "attacking"i
  | "blocking"i
  | "attacking" _ "or" _ "blocking"

imperative -> "sacrifice"i _ object
  | "destroy"i _ object {% ([, , destroy]) => ({ destroy }) %}
  | "detain"i _ object {% ([, , detain]) => ({ detain }) %}
  | "discard"i _ object {% ([, , discard]) => ({ discard }) %}
  | "return"i _ object (_ fromZone):? _ "to"i _ zone
  | "exile"i _ object (_ "face down"):? (_ untilClause):? {% ([, , exile, faceDown, until]) => {
    const result = { exile };
    if (faceDown) result.faceDown = true;
    if (until) result.until = until[1];
    return result;
  } %}
  | "create"i _ tokenDescription {% ([, , create]) => ({ create }) %}
  | "copy"i _ object {% ([, , copy]) => ({ copy }) %}
  | "lose"i "s":? _ number _ "life"i {% ([, , , lifeLoss]) => ({ lifeLoss }) %}
  | "mills"i _ englishNumber _ "card"i "s":? {% ([, , mills]) => ({ mills }) %}
  | gains _ number _ "life"i {% ([, , lifeGain]) => ({ lifeGain }) %}
  | gains _ "control of" _ object {% ([, , , , gainsControlOf]) => ({ gainsControlOf }) %}
  | "remove"i _ countableCount _ (counterKind _):? "counters from"i _ object
  | ("cast"i | "play"i) "s"i:? _ object (_ "without paying"i _ IT_S _ "mana cost"i):? (_ duration):?
  | "surveil"i _ number {% ([, , surveil]) => ({ surveil }) %}
  | "search"i _ zone (_ "for"i _ object):?
  | ("you"i _):? "choose"i _ object
  | ("you"i _):? "draw"i "s"i:? _ ("a"i _ "card"i | "an additional card"i | englishNumber _ "card"i "s")
  | "shuffle"i "s":? _ zone
  | "shuffle"i "s":? _ (object | zone) _ "into" _ zone
  | "counter"i _ object
  | "tap"i " " object {% ([, , tap]) => ({ tap }) %}
  | "take"i " " "an extra turn after this one"
  | "untap"i " " object
  | "scry"i _ number
  | ("you"i _):? "pay"i _ manacost
  | "pay"i _ numericalNumber _ "life"
  | "add"i _ "one mana of any color"
  | "add"i _ englishNumber _ "mana of any one color"
  | "add"i _ englishNumber _ "mana in any combination of" _ manaSymbol _ "and/or" _ manaSymbol {% ([, , amount, , , , c1, , , , c2]) => ({ addCombinationOf: [c1, c2], amount }) %}
  | "add"i _ manaSymbols (_ "or" _ manaSymbols):?
  | "prevent"i _ damagePreventionAmount _ damageNoun _ "that would be dealt" (_ "to" _ object):? (_ duration):?
  | "put"i _ englishNumber _ counterKind _ "counter"i "s":? _ "on" _ object
  | "you"i _ "choose"i _ object (_ "from" _ "it"i):?
  | "look"i _ "at the top" _ englishNumber _ "card"i "s" _ "of" _ zone
  | "look"i _ "at"i _ object
  | "reveal"i _ object {% ([, , reveal]) => ({ reveal }) %}
  | "put"i _ object _ intoZone (_ "tapped"):? (_ "and" _ object _ intoZone):?
  | gains _ "control" _ "of" _ object
  | ("you"i _):? "may" _ sentence ("." _ "if"i _ "you"i _ "do" "," _ sentence):?
  | "have" _ object _ objectInfinitive
  | imperative _ "for"i _ "each"i _ pureObject
  | imperative _ "and" _ imperative
  | imperative _ "unless" _ imperative
  | "choose"i _ "new targets for" _ object
  | "switch"i _ "the power and toughness of" _ object _ untilClause
  | "do the same for" _ object
  | "spend"i _ "mana as though it were mana of any type to cast" _ object
  | "choose"i _ "a"i _ "card"i _ CARD_NAME

playerVerbPhrase -> gains _ number _ "life"
 | gains _ "life" _ "equal" _ "to" _ itsPossessive _ numericalCharacteristic
 | playerVerbPhrase _ "for"i _ "each"i _ pureObject
 | playerVerbPhrase _ "for the first time each turn"
 | controls _ object
 | owns _ object
 | (DON_T | DOESN_T) "lose this mana as steps and phases end." {% () => "doesntEmpty" %}
 | "puts" _ object _ intoZone
 | "surveil"i | "surveil"i "s"
 | "discards" _ object
 | "sacrifices" _ object
 | "reveal"i "s" _ playersPossessive _ "hand"
 | "life total becomes" _ englishNumber {% ([, , lifeTotalBecomes]) => ({ lifeTotalBecomes }) %}
 | imperative
 | playerVerbPhrase ("," | ".") _ "then"i _ playerVerbPhrase
 | "cant"i _ imperative
 | DOESN_T | DON_T | "does" | "do"
 | ("loses" | "lose") _ "the game"
 | playerVerbPhrase _ "if"i _ sentence
 | playerVerbPhrase _ "this way"
 | gets _ "an emblem" _ withClause
objectVerbPhrase -> objectVerbPhrase ",":? _ "and" _ objectVerbPhrase
 | objectVerbPhrase _ "or" _ objectVerbPhrase
 | objectVerbPhrase "," (_ "then"):? _ objectVerbPhrase
 | ("has" | "have") _ acquiredAbility (_ asLongAsClause):?
 | gets _ ptModification (_ "and" _ gains _ acquiredAbility):? (_ untilClause):?
 | gains _ acquiredAbility _ "and" _ gets _ ptModification (_ untilClause):?
 | gets _ ptModification (_ forEachClause):? (_ untilClause):?
 | "enters" _ "the battlefield"i _ "with" _ ("a"i | "an"i _ "additional") _ counterKind _ "counter"i _ "on" _ "it"i (_ forEachClause):?
 | "enters" _ "the battlefield"i _ "with" _ englishNumber _ counterKind _ "counter"i "s" _ "on" _ "it"i
 | "enters" _ "the battlefield"i _ "with" _ "a number of" _ counterKind _ "counter"i "s" _ "on" _ "it"i _ "equal" _ "to" _ numberDefinition
 | ("enter" | "enters") _ "the battlefield"i (_ "tapped"):? (_ "under" _ playersPossessive _ "control"):?
 | ("leave" | "leaves") _ "the battlefield"i
 | ("die" | "dies")
 | "is" _ "put"i _ intoZone _ fromZone
 | "cant"i _ cantClauseInner (_ duration):?
 | "deals" _ dealsWhat
 | "is" _ isWhat
 | ("attacks" | "attack") (_ ("this"i | "each"i) _ "combat if able"):?
 | gains _ acquiredAbility (_ untilClause):?
 | DOESN_T _ "untap during" _ qualifiedPartOfTurn
 | "blocks or becomes blocked by" _ object
 | "is countered this way"
 | "fights" _ object
 | "targets" _ object
 | ("cost" | "costs") _ manacost _ "less" _ "to" _ "cast"i
 | "can"i _ "attack" _ "as though it didn\"t have defender"
 | "do so"
 | "does so"
 | ("remain" | "remains") _ "exiled"
 | "becomes" _ becomesWhat
 | ("lose" | "loses") _ "all abilities" (_ untilClause):?
 | ("is"|"are") _ "created"
 | "causes" _ player _ "to discard" _ object
 | objectVerbPhrase _ forEachClause
 | objectVerbPhrase _ duration
 | objectVerbPhrase _ "if"i _ sentence
objectInfinitive -> "be put"i _ intoZone _ duration
  | "be created under your control"i
  | "fight" _ object
  | "deal" _ dealsWhat

isWhat -> color
  | object
  | inZone
  | anyType (_ "in addition to its other types"i):?
becomesWhat -> "tapped"
  | "untapped"
  | "a copy of" _ object ("," _ exceptClauseInCopyEffect):?
exceptClauseInCopyEffect -> "except"i _ copyException ("," _ ("and" _ ):? copyException):*
copyException -> "its name is" _ CARD_NAME
  | IT_S _ isWhat
  | singleSentence

itsPossessive -> object SAXON
  | "its"i
  | "their"i

acquiredAbility -> keyword
  | "\"" ability "\""
  | "“" ability "”"
  | acquiredAbility _ "and" _ acquiredAbility
  | "this ability"

gets -> "get" "s":?
controls -> "control" "s":?
owns -> "own" "s":?
gains -> "gain"i "s":?

duration -> "this turn"
  | "for"i _ asLongAsClause
  | untilClause
untilClause -> "until"i _ untilClauseInner
untilClauseInner -> sentence
  | "end of turn"i

numericalCharacteristic -> "toughness"
  | "power"
  | "converted mana cost"

damagePreventionAmount -> "all"i
damageNoun -> ("non":? "combat" _):? "damage"

tokenDescription -> englishNumber _ pt _ color _ permanentType _ "token" "s":? (_ withClause):? {% ([amount, , size, , color, , tokenType]) => ({ amount, size, color, tokenType }) %}

color -> "white"
  | "blue"
  | "black"
  | "red"
  | "green"
  | "colorless"
  | "monocolored"
  | "multicolored"
  | color _ "and" _ color

pt -> number "/" number {% ([power, , toughness]) => ({ power, toughness }) %}
ptModification -> PLUSMINUS number "/" PLUSMINUS number {% ([pmP, power, , pmT, toughness]) => ({ powerMod: '+' === pmP ? power : -power, toughnessMod: '+' === pmT ? toughness : -toughness }) %}
numberDefinition -> itsPossessive _ numericalCharacteristic
  | "the"i _ ("total"i _):? "number of" _ object
integerValue -> [0-9]:+ {% ([digits]) => parseInt(digits.join(''), 10) %}

withClause -> "with"i _ withClauseInner
withClauseInner -> numericalCharacteristic _ numericalComparison
  | "the highest" _ numericalCharacteristic _ "among"i _ object
  | "converted mana costs" _ numericalNumber _ "and" _ numericalNumber
  | counterKind _ "counters on"i _ ("it"i | "them"i)
  | "that name"i
  | acquiredAbility
counterKind -> (ptModification
  | "charge"
  | "hit"
  | "wish"
  | "flying"
  | "lifelink"
  | "deathtouch"
  | "indestructible"
  | "trample"
  | "bounty") {% ([[counter]]) => ({ counter }) %}

dealsWhat -> ("non":? "combat" _):? "damage" _ "to" _ damageRecipient
 | numericalNumber _ "damage" _ "to" _ damageRecipient
 | "damage" _ "equal" _ "to" _ numberDefinition _ "to" _ damageRecipient
 | "damage" _ "to" _ damageRecipient _ "equal" _ "to" _ numberDefinition
 | numericalNumber _ "damage" _ divideAmongDamageTargets

damageRecipient -> object
  | player
  | "any target"i
  | "target" _ damageRecipient _ ("and" | "or") _ damageRecipient
  | "itself"i
# TODO: Fix this to be more generic
divideAmongDamageTargets -> "divided as you choose among one, two, or three targets"i

englishNumber -> "a"i {% () => 1 %}
  | "an"i {% () => 1 %}
  | "one"i {% () => 1 %}
  | "two"i {% () => 2 %}
  | "three"i {% () => 3 %}
  | "four"i {% () => 4 %}
  | "five"i {% () => 5 %}
  | "six"i {% () => 6 %}
  | "seven"i {% () => 7 %}
  | "eight"i {% () => 8 %}
  | "nine"i {% () => 9 %}
  | "ten"i {% () => 10 %}
  | "that many"i {% () => "that many" %}
  | "that much"i {% () => "that much" %}
  | number {% ([n]) => n %}
numericalNumber -> number {% ([n]) => n %}
  | "that much"i {% () => "thatMuch" %}
number -> (integerValue
  | "x"i
  | "y"i
  | "z"i) {% ([[n]]) => n %}
numericalComparison -> number _ "or greater"i
  | number _ "or less"i
  | "less than or equal to" _ numberDefinition
  | "greater than" _ numberDefinition
  | number
countableCount -> "exactly"i _ englishNumber
  | englishNumber _ "or more"i
  | "fewer than" _ englishNumber
  | "any number of"
  | "one of"
  | "up to" _ englishNumber
  | englishNumber

cantClauseInner -> "attack"
  | "block"
  | "attack or block"
  | "attack or block alone"
  | "be blocked"
  | "be countered"
  | "be blocked by more than" _ englishNumber _ "creature"i "s":?

zone -> (playersPossessive | "a"i) _ ownedZone
  | "exile"i
  | "the battlefield"i
  | "it"i
ownedZone -> "graveyard"
  | "library"
  | "hand"
  | ownedZone "s"
  | ownedZone _ "and":? "/":? "or":? _ ownedZone
  | ownedZone ("," _ ("and" _):? ownedZone):+
intoZone -> "onto the battlefield"i
  | "into" _ zone
  | "on top of" _ zone
  | "on the bottom of" _ zone _ ("in" _  ("any" | "a random") _ "order")
inZone -> "on the battlefield"
  | "in" _ zone
fromZone -> "from" _ zone

n -> "permanent"i
  | n "s"
  | (anyType _):? "spell"i
  | (anyType _):? "card"i
  | permanentType
  | "permanent card"i
  | "token"i
  | "ability"i
permanentType -> "artifact"
  | "creature"i
  | "enchantment"i
  | "land"i
  | "planeswalker"i
  | "basic"i
  | creatureType
  | landType
  | artifactType
  | enchantmentType
  | planeswalkerType
  | permanentType _ permanentType
  | permanentType _ "or"i _ permanentType
anyType -> permanentType
  | spellType
  | "legendary"i
  | "[" anyType "]"
spellType -> "instant"i
  | "sorcery"i
  | "adventure"i
  | "arcane"i
  | "trap"i
  | spellType _ ("and" | "or") spellType
creatureType -> "Advisor"i
  | "Aetherborn"i
  | "Ally"i
  | "Angel"i
  | "Antelope"i
  | "Ape"i
  | "Archer"i
  | "Archon"i
  | "Army"i
  | "Artificer"i
  | "Assassin"i
  | "Assembly-Worker"i
  | "Atog"i
  | "Aurochs"i
  | "Avatar"i
  | "Azra"i
  | "Badger"i
  | "Barbarian"i
  | "Basilisk"i
  | "Bat"i
  | "Bear"i
  | "Beast"i
  | "Beeble"i
  | "Berserker"i
  | "Bird"i
  | "Blinkmoth"i
  | "Boar"i
  | "Bringer"i
  | "Brushwagg"i
  | "Camarid"i
  | "Camel"i
  | "Caribou"i
  | "Carrier"i
  | "Cat"i
  | "Centaur"i
  | "Cephalid"i
  | "Chimera"i
  | "Citizen"i
  | "Cleric"i
  | "Cockatrice"i
  | "Construct"i
  | "Coward"i
  | "Crab"i
  | "Crocodile"i
  | "Cyclops"i
  | "Dauthi"i
  | "Demigod"i
  | "Demon"i
  | "Deserter"i
  | "Devil"i
  | "Dinosaur"i
  | "Djinn"i
  | "Dragon"i
  | "Drake"i
  | "Dreadnought"i
  | "Drone"i
  | "Druid"i
  | "Dryad"i
  | "Dwarf"i
  | "Efreet"i
  | "Egg"i
  | "Elder"i
  | "Eldrazi"i
  | "Elemental"i
  | "Elephant"i
  | "Elf"i
  | "Elk"i
  | "Eye"i
  | "Faerie"i
  | "Ferret"i
  | "Fish"i
  | "Flagbearer"i
  | "Fox"i
  | "Frog"i
  | "Fungus"i
  | "Gargoyle"i
  | "Germ"i
  | "Giant"i
  | "Gnome"i
  | "Goat"i
  | "Goblin"i
  | "God"i
  | "Golem"i
  | "Gorgon"i
  | "Graveborn"i
  | "Gremlin"i
  | "Griffin"i
  | "Hag"i
  | "Harpy"i
  | "Hellion"i
  | "Hippo"i
  | "Hippogriff"i
  | "Homarid"i
  | "Homunculus"i
  | "Horror"i
  | "Horse"i
  | "Hound"i
  | "Human"i
  | "Hydra"i
  | "Hyena"i
  | "Illusion"i
  | "Imp"i
  | "Incarnation"i
  | "Insect"i
  | "Jackal"i
  | "Jellyfish"i
  | "Juggernaut"i
  | "Kavu"i
  | "Kirin"i
  | "Kithkin"i
  | "Knight"i
  | "Kobold"i
  | "Kor"i
  | "Kraken"i
  | "Lamia"i
  | "Lammasu"i
  | "Leech"i
  | "Leviathan"i
  | "Lhurgoyf"i
  | "Licid"i
  | "Lizard"i
  | "Manticore"i
  | "Masticore"i
  | "Mercenary"i
  | "Merfolk"i
  | "Metathran"i
  | "Minion"i
  | "Minotaur"i
  | "Mole"i
  | "Monger"i
  | "Mongoose"i
  | "Monk"i
  | "Monkey"i
  | "Moonfolk"i
  | "Mouse"i
  | "Mutant"i
  | "Myr"i
  | "Mystic"i
  | "Naga"i
  | "Nautilus"i
  | "Nephilim"i
  | "Nightmare"i
  | "Nightstalker"i
  | "Ninja"i
  | "Noble"i
  | "Noggle"i
  | "Nomad"i
  | "Nymph"i
  | "Octopus"i
  | "Ogre"i
  | "Ooze"i
  | "Orb"i
  | "Orc"i
  | "Orgg"i
  | "Otter"i
  | "Ouphe"i
  | "Ox"i
  | "Oyster"i
  | "Pangolin"i
  | "Peasant"i
  | "Pegasus"i
  | "Pentavite"i
  | "Pest"i
  | "Phelddagrif"i
  | "Phoenix"i
  | "Pilot"i
  | "Pincher"i
  | "Pirate"i
  | "Plant"i
  | "Praetor"i
  | "Prism"i
  | "Processor"i
  | "Rabbit"i
  | "Rat"i
  | "Rebel"i
  | "Reflection"i
  | "Rhino"i
  | "Rigger"i
  | "Rogue"i
  | "Sable"i
  | "Salamander"i
  | "Samurai"i
  | "Sand"i
  | "Saproling"i
  | "Satyr"i
  | "Scarecrow"i
  | "Scion"i
  | "Scorpion"i
  | "Scout"i
  | "Sculpture"i
  | "Serf"i
  | "Serpent"i
  | "Servo"i
  | "Shade"i
  | "Shaman"i
  | "Shapeshifter"i
  | "Shark"i
  | "Sheep"i
  | "Siren"i
  | "Skeleton"i
  | "Slith"i
  | "Sliver"i
  | "Slug"i
  | "Snake"i
  | "Soldier"i
  | "Soltari"i
  | "Spawn"i
  | "Specter"i
  | "Spellshaper"i
  | "Sphinx"i
  | "Spider"i
  | "Spike"i
  | "Spirit"i
  | "Splinter"i
  | "Sponge"i
  | "Squid"i
  | "Squirrel"i
  | "Starfish"i
  | "Surrakar"i
  | "Survivor"i
  | "Tentacle"i
  | "Tetravite"i
  | "Thalakos"i
  | "Thopter"i
  | "Thrull"i
  | "Treefolk"i
  | "Trilobite"i
  | "Triskelavite"i
  | "Troll"i
  | "Turtle"i
  | "Unicorn"i
  | "Vampire"i
  | "Vedalken"i
  | "Viashino"i
  | "Volver"i
  | "Wall"i
  | "Warlock"i
  | "Warrior"i
  | "Weird"i
  | "Werewolf"i
  | "Whale"i
  | "Wizard"i
  | "Wolf"i
  | "Wolverine"i
  | "Wombat"i
  | "Worm"i
  | "Wraith"i
  | "Wurm"i
  | "Yeti"i
  | "Zombie"i
  | "Zubera"i
planeswalkerType -> "Ajani"i
  | "Aminatou"i
  | "Angrath"i
  | "Arlinn"i
  | "Ashiok"i
  | "Bolas"i
  | "Calix"i
  | "Chandra"i
  | "Dack"i
  | "Daretti"i
  | "Davriel"i
  | "Domri"i
  | "Dovin"i
  | "Elspeth"i
  | "Estrid"i
  | "Freyalise"i
  | "Garruk"i
  | "Gideon"i
  | "Huatli"i
  | "Jace"i
  | "Jaya"i
  | "Karn"i
  | "Kasmina"i
  | "Kaya"i
  | "Kiora"i
  | "Koth"i
  | "Liliana"i
  | "Lukka"i
  | "Nahiri"i
  | "Narset"i
  | "Nissa"i
  | "Nixilis"i
  | "Oko"i
  | "Ral"i
  | "Rowan"i
  | "Saheeli"i
  | "Samut"i
  | "Sarkhan"i
  | "Serra"i
  | "Sorin"i
  | "Tamiyo"i
  | "Teferi"i
  | "Teyo"i
  | "Tezzeret"i
  | "Tibalt"i
  | "Ugin"i
  | "Venser"i
  | "Vivien"i
  | "Vraska"i
  | "Will"i
  | "Windgrace"i
  | "Wrenn"i
  | "Xenagos"i
  | "Yanggu"i
  | "Yanling"i
landType -> basicLandType
  | "Desert"i
  | "Gate"i
  | "lair"i
  | "locus"i
  | "mine"i
  | "power-plant"i
  | "tower"i
  | "urza's"i
basicLandType -> "Plains"i
  | "island"i
  | "swamp"i
  | "mountain"i
  | "forest"i
enchantmentType -> "aura"i
  | "cartouche"i
  | "curse"i
  | "saga"i
  | "shrine"i
artifactType -> "clue"i
  | "contraption"i
  | "equipment"i
  | "food"i
  | "fortification"i
  | "gold"i
  | "treasure"i
  | "vehicle"i

asLongAsClause -> "as long as"i condition

# TODO Generify
replacementEffect -> sentence _ "instead of putting it" _ intoZone

costs -> cost ("," _ cost):* {% ([c, cs]) => [c, ...cs.map(([, , c2]) => c2)] %}
cost -> "{T}" {% () => "tap" %}
  | sentence {% ([s]) => s %}
  | manacost {% ([mana]) => ({ mana }) %}
  | loyaltyCost {% ([loyalty]) => ({ loyalty }) %}
loyaltyCost -> PLUSMINUS integerValue {% ([pm, int]) => pm === "+" ? int : -int %}
manacost -> manaSymbol:+ {% ([mg]) => mg %}
manaSymbols -> manaSymbol:+ {% ([s]) => s %}
manaSymbol -> "{" manaLetter ("/" manaLetter):? "}" {% ([, c, c2]) => c2 ? { hybrid: [c, c2[1]] } : c %}
manaLetter -> (integerValue
  | "x"i
  | "y"i
  | "z"i
  | "w"i
  | "u"i
  | "b"i
  | "r"i
  | "g"i
  | "c"i
  | "p"i) {% ([[s]]) => s %}

qualifiedPartOfTurn -> turnQualification _ partOfTurn
  | "combat on your turn"i
  | "combat"i
turnQualification -> (playersPossessive | "the"i) (_ "next"):?
  | "this"i
  | "each"i
  | "this turn"i SAXON
  | "that turn"i SAXON
partOfTurn -> "turn"
  | "untap step"i
  | "upkeep"i
  | "draw step"i
  | "precombat main phase"i
  | "main phase"i
  | "postcombat main phase"i
  | "end step"i

playersPossessive -> "your"
  | "their"
  | player SAXON
  | player AP

AP -> "'" | "’"
CARD_NAME -> "~"
CAN_T -> "can't"i | "can’t"i
DON_T -> "don't"i | "don’t"i
DOESN_T -> "doesn't"i | "doesn’t"i
DASHDASH -> "--" | "—"
IT_S -> "it's"i | "it’s"i
PLUSMINUS -> "+" | "-" | "−"
SAXON -> AP "s"
THAT_S -> "that's"i | "that’s"i
YOU_VE -> "you've" | "you’ve"i
