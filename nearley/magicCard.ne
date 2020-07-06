@builtin "whitespace.ne"
# Based on https://github.com/Soothsilver/mtg-grammar/blob/master/mtg.g4
card -> "\n":* ability:? ("\n":+ ability):* "\n":? {% ([, a, as]) => a ? [a, ...as.map(([, a2]) => a2).filter((a) => a)] : [] %}
ability -> (abilityWordAbility
  | activatedAbility
  | additionalCostToCastSpell
  | keywords
  | modalAbility
  | staticOrSpell
  | triggeredAbility
  | reminderText # TODO: Make sure this doesn't show up in the AST
) ".":? (_ reminderText):? {% ([[a]]) => a %}

reminderText -> "(" [^)]:+ ")"

modalAbility -> "choose"i _ modalQuantifier _ DASHDASH (_ modalOption):+ {% ([, , quantifier, , , options]) => ({ quantifier, options: options.map(([, o]) => o) }) %}
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
  | mutateKeyword
  | megamorphKeyword) {% ([[keyword]]) => keyword %}
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
buybackKeyword -> "buyback"i _ cost {% ([, , buyback]) => ({ buyback }) %}
rampageKeyword -> "rampage"i _ number {% ([, , rampage]) => ({ rampage }) %}
echoKeyword -> "echo"i _ cost {% ([, , echo]) => ({ echo }) %}
fadingKeyword -> "fading"i _ number {% ([, , fading]) => ({ fading }) %}
kickerKeyword -> "kicker"i _ costs {% ([, , kicker]) => ({ kicker }) %}
flashbackKeyword -> "flashback"i _ cost {% ([, , flashback]) => ({ flashback }) %}
madnessKeyword -> "madness"i _ cost {% ([, , madness]) => ({ madness }) %}
morphKeyword -> "morph"i _ cost {% ([, , morph]) => ({ morph }) %}
amplifyKeyword -> "amplify"i _ number {% ([, , amplify]) => ({ amplify }) %}
entwineKeyword -> "entwine"i _ cost {% ([, , entwine]) => ({ entwine }) %}
modularKeyword -> "modular"i _ number {% ([, , module]) => ({ modular }) %}
bushidoKeyword -> "bushido"i _ number {% ([, , bushido]) => ({ bushido }) %}
ninjutsuKeyword -> "ninjutsu"i _ cost {% ([, , ninjutsu]) => ({ ninjutsu }) %}
dredgeKeyword -> "dredge"i _ number {% ([, , dredge]) => ({ dredge }) %}
transmuteKeyword -> "transmute"i _ cost {% ([, , transmute]) => ({ transmute }) %}
bloodthirstKeyword -> "bloodthirsty"i _ number {% ([, , bloodthirsty]) => ({ bloodthirsty }) %}
replicateKeyword -> "replicate"i _ cost {% ([, , replicate]) => ({ replicate }) %}
graftKeyword -> "graft"i _ number {% ([, , graft]) => ({ graft }) %}
recoverKeyword -> "recover"i _ cost {% ([, , recover]) => ({ recover }) %}
rippleKeyword -> "ripple"i _ number {% ([, , ripple]) => ({ ripple }) %}
suspendKeyword -> "suspend"i _ number _ DASHDASH _ cost {% ([, , suspend, , , , cost]) => ({ suspend, cost }) %}
vanishingKeyword -> "vanishing"i _ number {% ([, , vanishing]) => ({ vanishing }) %}
absordKeyword -> "absorb"i _ number {% ([, , absorb]) => ({ absorb }) %}
fortifyKeyword -> "fortify"i _ cost {% ([, , fortify]) => ({ fortify }) %}
frenzy -> "frenzy"i _ number {% ([, , frenzy]) => ({ frenzy }) %}
poisonousKeyword -> "poisonous"i _ number {% ([, , poisonous]) => ({ poisonous }) %}
evokeKeyword -> "evoke"i _ cost {% ([, , evoke]) => ({ evoke }) %}
devourKeyword -> "devour"i _ number {% ([, , devour]) => ({ devour }) %}
unearthKeyword -> "unearth"i _ cost {% ([, , unearth]) => ({ unearth }) %}
annihilatorKeyword -> "annihilator"i _ number {% ([, , annihilator]) => ({ annihilator }) %}
levelUpKeyword -> "level up"i _ cost {% ([, , levelUp]) => ({ levelUp }) %}
miracleKeyword -> "miracle"i _ cost {% ([, , miracle]) => ({ miracle }) %}
megamorphKeyword -> "megamorph"i _ cost {% ([, , megamorph]) => ({ megamorph }) %}
affinityKeyword -> "affinity for"i _ object {% ([, , affinityFor]) => ({ affinityFor }) %}
partnerKeyword -> "partner"i {% () => "partner" %}
  | "partner with"i _ [^\n]:+ {% ([, , partnerWith]) => ({ partnerWith: partnerWith.join('') }) %}
offeringKeyword -> object _ "offering" {% ([offering]) => ({ offering }) %}
frenzyKeyword -> "frenzy"i _ number {% ([, , frenzy]) => ({ frenzy }) %}
soulshiftKeyword -> "soulshift"i _ number {% ([, , soulshift]) => ({ soulshift }) %}
spliceKeyword -> "splice onto"i _ object _ cost {% ([, , spliceOnto, , cost]) => ({ spliceOnto, cost }) %}
forecastKeyword -> "forecast"i _ DASHDASH _ activatedAbility {% ([, , , , forecast]) => ({ forecast }) %}
championKeyword -> "champion"i _ object {% ([, , champion]) => ({ champion }) %}
protectionKeyword -> "protection from"i _ anyEntity {% ([, , protectionFrom]) => ({ protectionFrom }) %}
prowlKeyword -> "prowl"i _ cost {% ([, , prowl]) => ({ prowl }) %}
reinforceKeyword -> "reinforce"i _ number _ DASHDASH _ cost {% ([, , reinforce, , , , cost]) => ({ reinforce, cost }) %}
transfigureKeyword -> "transfigure"i _ cost {% ([, , transfigure]) => ({ transfigure }) %}
bandingKeyword -> "banding"i {% () => ({ bandsWith: "any" }) %}
  | "bands with"i _ object {% () => ({ bandsWith: object }) %}
landwalkKeyword -> anyType "walk" {% ([landwalk]) => ({ landwalk }) %}
  | "nonbasic landwalk"i {% () => ({ landwalk: { not: { type: "basic" } } }) %}
  | "snow landwalk"i {% () => ({ landwalk: { type: "snow" } }) %}
auraSwapKeyword -> "aura swap"i _ cost {% ([, , auraSwap]) => ({ auraSwap }) %}

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
  | "will of the council"i) {% ([[aw]]) => aw.toLowerCase() %}

activatedAbility -> costs ":" _ effect (_ activationInstructions):? {% ([costs, , , activatedAbility, i]) => {
  const result = { costs, activatedAbility };
  if (i) result.instructions = i;
  return result;
} %}
activationInstructions -> "activate this ability only "i activationInstruction "." {% ([, i]) => ({ only: i }) %}
  | "any player may activate this ability."i {% () => "anyPlayer" %}
activationInstruction -> "once each turn"i {% () => "onceATurn" %}
  | "any time you could cast a sorcery"i {% () => "sorceryOnly" %}
  | "if" _ player _ "control" "s":? _ object {% ([, , who, , , , , controls]) => ({ who, controls }) %}
  | "only if" _ condition {% ([, , condition]) => ({ condition }) %}
# TODO: Make into AST
activatedAbilities -> (itsPossessive _):? "activated abilities"i {% ([reference]) => reference ? { whose: reference, activatedAbilities: "any" } : { activatedAbilities: "any" } %}
  | "activated abilities of"i _ object {% ([, , activatedAbilities]) => ({ whose: activatedAbilities, activatedAbilities: true }) %}
activatedAbilitiesVP -> CAN_T _ "be activated"i (_ "unless they're mana abilities."):? {% ([, , , , manaOnly]) => manaOnly ? { cant: "activatedAbilities", unless: "manaAbility" } : { cant: "activatedAbilities" } %}

triggeredAbility -> triggerCondition "," _ interveningIfClause:? effect {% ([trigger, , , ifClause, effect]) => {
  const result = { trigger, effect };
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
  | player _ gains _ "life"i {% ([actor]) => ({ actor, does: "gainsLife" }) %}
  | object _ "is dealt damage"i {% ([what]) => ({ what, does: "dealtDamage" }) %}
  | object _ objectVerbPhrase {% ([what, , does]) => ({ what, does }) %}
interveningIfClause -> "if "i condition "," {% ([, c]) => c %}
triggerTiming -> "each turn"i {% () => "eachTurn" %}
  | "during each opponent" SAXON _ "turn" {% () => "eachOpponentTurn" %}

additionalCostToCastSpell -> "as an additional cost to cast this spell,"i _ imperative "." {% ([, , additionalCost]) => ({ additionalCost }) %}

staticOrSpell -> sentenceDot {% ([sd]) => sd %}
effect -> (sentenceDot
  | modalAbility) {% ([[e]]) => e %}

sentenceDot -> sentence (".":? _ additionalSentence):* ".":? {% ([s, ss]) => [s, ...ss.map(([, , s2]) => s2)] %}
additionalSentence -> sentence {% ([s]) => s %}
  | triggeredAbility {% ([t]) => t %}

sentence -> singleSentence {% ([ss]) => ss %}
  | "then"i _ sentence {% ([, , s]) => s %}
  | singleSentence (("," | "then" | "and") _ (("then"i | "and"i):? _):? sentence):+ {% ([s, ss]) => ({ and: [s, ...ss.map(([, , , s2]) => s2)] }) %}
  | "otherwise,"i _ sentence {% ([, , otherwise]) => ({ otherwise }) %}
singleSentence -> imperative {% ([i]) => i %}
  | singleSentence ", where X is"i _ numberDefinition {% ([singleSentence, , , X]) => ({ singleSentence, X }) %}
  | object _ objectVerbPhrase {% ([what, , does]) => ({ what, does }) %}
  | IT_S _ isWhat {% ([, , is]) => ({ is }) %}
  | player _ playerVerbPhrase {% ([actor, , does]) => ({ actor, does }) %}
  | "if"i _ sentence "," _ replacementEffect # TODO: ASTize
  | "if"i _ condition "," _ sentence {% ([, , condition, , , effect]) => ({ condition, effect }) %}
  | "if"i _ object _ "would"i _ (objectVerbPhrase | objectInfinitive) "," _ sentenceInstead # TODO: ASTize
  | "if"i _ player _ "would"i _ playerVerbPhrase "," _ sentenceInstead # TODO: ASTize
  | asLongAsClause "," _ sentence {% ([asLongAs, , , effect]) => ({ asLongAs, effect }) %}
  | duration "," _ sentence {% ([duration, , , effect]) => ({ duration, effect }) %}
  | "for each"i _ object "," _ sentence {% ([, , forEach, , , effect]) => ({ forEach, effect }) %}
  | activatedAbilities _ activatedAbilitiesVP {% ([abilities, , effect]) => ({ ...abilities, ...effect }) %}
  | itsPossessive _ numericalCharacteristic _ "is equal to"i _ numberDefinition # TODO: ASTize
  | "as"i sentence "," _ sentence # TODO: ASTize
  | "instead"i _ singleSentence {% ([, , instead]) => ({ instead }) %}
sentenceInstead -> sentence _ "instead"i {% ([instead]) => ({ instead }) %}
  | "instead"i _ sentence {% ([, ,instead]) => ({ instead }) %}

forEachClause -> "for each" _ pureObject {% ([, , forEach]) => ({ forEach }) %}
 | "for each color of mana spent to cast"i _ object {% ([, , forEachColorSpent]) => ({ forEachColorSpent }) %}

condition -> sentence {% ([s]) => s %}
  | (YOU_VE | "you") _ action _ duration {% ([, , done, , during]) => ({ done, during }) %}
  | IT_S _ "your turn"i {% () => "yourTurn" %}
  | IT_S _ "not" _ playersPossessive _ "turn" {% ([, , notTurnOf]) => ({ notTurnOf }) %}
  | object _ "has"i _ countableCount _ (counterKind _):? "counter" "s":? "on it"i {% ([object, , , count, , hasCounter]) => ({ object, count, hasCounter }) %}
  | numberDefinition _ "is"i _ numericalComparison {% ([number, , , , is]) => ({ number, is }) %}
  | "that mana is spent on"i _ object {% ([, , manaSpentOn]) => ({ manaSpentOn }) %}
  | ("is" _):? "paired" _ withClause {% ([, , , pairedWith]) => ({ pairedWith }) %}
  | ("is" _):? "untapped" {% () => "untapped" %}

action -> "scried" {% () => "scried" %}
  | "surveilled" {% () => "surveilled" %}

entity -> (object 
  | player) {% ([[e]]) => e %}
anyEntity -> object {% ([e]) => e %}
  | pureObject {% ([e]) => e %}
  | player {% ([e]) => e %}
  | purePlayer {% ([e]) => e %}
  | color {% ([color]) => ({ color }) %}
  | "everything" {% () => "everything" %}
player -> "you"i {% () => "you" %}
  | "they"i {% () => "they" %}
  | commonReferencingPrefix _ purePlayer {% ([reference, , player]) => ({ reference, player }) %}
  | "your opponent" "s":? {% ([, plural]) => plural ? "opponent" : "opponents" %}
  | "defending player" {% () => "defendingPlayer" %}
  | itsPossessive _ "controller"i "s":? {% () => "objectsController" %}
  | itsPossessive _ "owner"i "s":? {% () => "objectsOwner" %}
  | "player" {% () => "player" %}
  | "each of" _ player {% ([, , each]) => ({ each }) %}
purePlayer -> "opponent"i {% () => "opponent" %}
  | "player"i {% () => "player" %}
  | "players"i {% () => "players" %}
  | "opponents"i {% () => "opponents" %}
object -> (referencingObjectPrefix _):? objectInner {% ([reference, object]) => reference ? { reference: reference[0], object } : object %}
objectInner -> "it"i {% () => "it" %}
  | "them"i {% () => "them" %}
  | "they"i {% () => "they" %}
  | "rest"i {% () => "rest" %}
  | "other"i {% () => "other" %}
  | "this emblem"i {% () => "emblem" %}
  | object _ THAT_S _ isWhat {% ([object, , , , condition]) => ({ object, condition }) %}
  | object ("," _ object):* ",":? _ ("and"i {% () => "and" %} | "or"i {% () => "xor" %} | "and/or"i {% () => "or" %}) _ object {% ([o, os, , , connector, , o2]) => ({ [connector]: [o, ...os.map(([, , o3]) => o3), o2] }) %}
  | pureObject {% ([po]) => po %}
  | "each of"i _ object {% ([, , eachOf]) => ({ eachOf }) %}
  | "the top"i _ englishNumber _ "cards of"i _ zone {% ([, , topCards, , , , from]) => ({ topCards, from }) %}
  | "the top of" _ zone {% ([, , topOf]) => ({ topOf }) %}
  | "the top card of"i _ zone {% ([, , from]) => ({ topCards: 1, from }) %}
  | (counterKind _):? "counter"i "s":? _ "on" _ object {% ([kind, , , , , , countersOn]) => kind ? { counterType: kind[0], countersOn } : { countersOn } %}
suffix -> player _ ((DON_T | DOESN_T) _):? ("control"i | "own"i) "s":? {% ([who, negate, , possessive]) => ({ who, [possessive]: !negate }) %}
  | "in"i _ zone (_ "and in"i _ zone):? {% ([, , zone, zone2]) => ({ zone: zone2 ? { and: [zone, zone2[3]] } : zone }) %}
  | "from"i _ zone {% ([, , from]) => ({ from }) %}
  | ("that" _):? "you cast"i {% () => "youCast" %}
  | "that" _ didAction (_ duration):? {% ([, , didAction, when]) => when ? { didAction, when: when[1] } : { didAction } %}
  | "that targets only"i _ object {% ([, , onlyTargets]) => ({ onlyTargets }) %}
  | "that targets"i _ anyEntity {% ([, , targets]) => ({ targets }) %}
  | "tapped this way"i {% () => "tappedThisWay" %}
  | ("destroyed"i | "exiled"i) _ (fromZone _):? "this way"i # TODO: ASTize
  | "of the"i _ anyType _ "type of"i _ playersPossessive _ "choice"i # TODO ASTize
  | object _ "could target"i {% ([couldTarget]) => ({ couldTarget }) %}
  | "able to block"i _ object {% ([, , canBlock]) => ({ canBlock }) %}
  | "that convoked"i _ object {% ([, , convoked]) => ({ convoked }) %}
  | "from among them"i {% () => "amongThem" %}
  | "named"i _ CARD_NAME {% ([, , named]) => ({ named }) %}
  | YOU_VE _ "cast before it this turn"i {% () => "youveCastBeforeThisTurn" %}
  | "not named"i _ CARD_NAME {% ([, , named]) => ({ not: { named } }) %}
  | "attached to" _ object {% ([, , attachedTo]) => ({ attachedTo }) %}
pureObject -> (prefix _):? pureObjectInner (_ suffix):? {% ([prefix, object, suffix]) => {
  if (!prefix && !suffix) return object;
  const result = { object };
  if (prefix) result.prefix = prefix[0]
  if (suffix) result.suffix = suffix[1];
  return result;
} %}
pureObjectInner -> "copy"i (_ "of" _ object):? {% ([, copyOf]) => copyOf ? { copyOf } : "copy" %}
  | "copies"i {% () => "copies" %}
  | "card"i "s":? {% () => "card" %}
  | anyType "s":? {% ([type]) => ({ type }) %}
  | cumulativeReferencingPrefix _ pureObject {% ([reference, , object]) => ({ reference, object }) %}
  | pureObject ("," _ pureObject):* _ ("and"i {% () => "and" %} | "or"i {% () => "xor" %} | "and/or"i {% () => "or" %}) _ pureObject {% ([o1, os, , connector, , o2]) => ({ [connector]: [o1, ...os.map(([, , o3]) => o3), o2] }) %}
  | pureObject _ "without"i _ keyword {% ([object, , , , without]) => ({ object, without }) %}
  | pureObject _ withClause {% ([object, , condition]) => ({ object, condition }) %}
  | CARD_NAME {% ([c]) => c %}
referencingObjectPrefix -> "the sacrificed"i {% () => "sacrificed" %}
  | "the exiled"i {% () => "exiled" %}
  | "any of"i {% () => "any" %}
  | "the"i {% () => "the" %}
  | "the rest of"i {% () => "rest" %}
  | commonReferencingPrefix {% ([p]) => p %}
  | countableCount {% ([count]) => ({ count }) %}
cumulativeReferencingPrefix -> "other"i {% () => "other" %}
  | "equipped"i {% () => "equipped" %}
commonReferencingPrefix -> countableCount (_ commonReferencingPrefixInner):? {% ([count, additional]) => additional ? { count, reference: additional[1] } : { count } %}
  | ("another"i _):? (countableCount _):? "target"i "s":?  {% ([another, count]) => {
    const targetCount = count ? count[0] : 1;
    return another ? { another: true, targetCount } : { targetCount }
  } %}
  | commonReferencingPrefixInner {% ([i]) => i %}
commonReferencingPrefixInner -> "each"i {% () => "each" %}
  | "this"i {% () => "this" %}
  | "enchanted"i {% () => "enchanted" %}
  | "equipped"i {% () => "equipped" %}
  | "that"i {% () => "that" %}
  | "that player" SAXON {% () => "thatPlayer" %}
  | "these"i {% () => "these" %}
  | "those"i {% () => "thsoe" %}
  | "another"i {% () => "another" %}
  | "the chosen"i {% () => "chosen" %}
  | "at least"i _ englishNumber {% ([, , atLeast]) => ({ atLeast }) %}
prefix -> "enchanted"i {% () => "enchanted" %}
  | "attached"i {% () => "attached" %}
  | "equipped"i {% () => "equipped" %}
  | "non"i ("-" | _):? anyType {% ([, , type]) => ({ not: { type } }) %}
  | "exiled"i {% () => "exiled" %}
  | "the revealed"i {% () => "revealed" %}
  | anyType {% ([type]) => ({ type }) %}
  | "token"i {% () => "token" %}
  | "nontoken"i {% () => ({ not: "token" }) %}
  | color {% ([color]) => ({ color }) %}
  | "face-down" {% () => "faceDown" %}
  | "tapped"i {% () => "tapped" %}
  | "untapped"i {% () => ({ not: "tapped" }) %}
  | pt {% ([size]) => ({ size }) %}
  | "attacking"i {% () => "attacking" %}
  | "blocking"i {% () => "blocking" %}
  | "attacking" _ "or" _ "blocking" {% () => ({ or: ["attacking", "blocking"] }) %}

didAction -> "dealt damage" {% () => "dealtDamage" %}

imperative -> "sacrifice"i _ object {% ([, , sacrifice]) => ({ sacrifice }) %}
  | "fateseal"i _ number {% ([, , fateseal]) => ({ fateseal }) %}
  | "destroy"i "s":? _ object {% ([, , , destroy]) => ({ destroy }) %}
  | "detain"i _ object {% ([, , detain]) => ({ detain }) %}
  | "discard"i "s":? _ object {% ([, , , discard]) => ({ discard }) %}
  | "return"i "s":? _ object _ "to"i _ zone (_ "tapped"):? {% ([, , , returns, , , , to, tapped]) => tapped ? { returns, to, tapped: true } : { returns, to } %}
  | "exile"i "s":? _ object (_ "face down"):? (_ untilClause):? {% ([, , , exile, faceDown, until]) => {
    const result = { exile };
    if (faceDown) result.faceDown = true;
    if (until) result.until = until[1];
    return result;
  } %}
  | "create"i "s":? _ tokenDescription {% ([, , , create]) => ({ create }) %}
  | "copy"i _ object {% ([, , copy]) => ({ copy }) %}
  | "lose"i "s":? _ number _ "life"i {% ([, , , lifeLoss]) => ({ lifeLoss }) %}
  | "mills"i _ englishNumber _ "card"i "s":? {% ([, , mills]) => ({ mills }) %}
  | gains _ number _ "life"i {% ([, , lifeGain]) => ({ lifeGain }) %}
  | gains _ "control of" _ object (_ untilClause):? {% ([, , , , gainsControlOf, until]) => until ? { gainsControlOf, until } : { gainsControlOf } %}
  | "remove"i _ countableCount _ (counterKind _):? "counter" "s":? _ "from"i _ object {% ([, , count, , counterKind, , , , , , removeCountersFrom]) => counterKind ? { count, removeCountersFrom, counterKind: counterKind[0] } : { count, removeCountersFrom } %}
  | ("cast"i | "play"i) "s"i:? _ object (_ "without paying"i _ IT_S _ "mana cost"i):? (_ duration):? {% ([[cp], , , cast, withoutPaying, duration]) => {
    const result = { [cp.toLowerCase()]: cast };
    if (withoutPaying) result.withoutPaying = true;
    if (duration) result.duration = duration[1];
    return result;
  } %}
  | "surveil"i _ number {% ([, , surveil]) => ({ surveil }) %}
  | "search"i _ zone (_ "for"i _ object):? {% ([, , search, criteria]) => criteria ? { search, criteria: criteria[3] } : search %}
  | "choose"i _ object {% ([, , choose]) => ({ choose }) %}
  | "draw"i "s":? _ ("a"i _ "card"i {% () => 1 %} | "an additional card"i {% () => 1 %} | englishNumber _ "card"i "s" {% ([n]) => n %}) {% ([, , , draw]) => ({ draw }) %}
  | "draw"i "s":? _ "cards equal to" _ numberDefinition
  | "shuffle"i "s":? _ zone {% ([, , , shuffle]) => ({ shuffle }) %}
  | "shuffle"i "s":? _ (object | zone) _ "into" _ zone {% ([, , , shuffle, , , , into]) => ({ shuffle, into }) %}
  | "counter"i _ object {% ([, , counter]) => ({ counter }) %}
  | "tap"i " " object {% ([, , tap]) => ({ tap }) %}
  | "take"i " " "an extra turn after this one" {% () => "takeExtraTurn" %}
  | "untap"i " " object {% ([, , untap]) => ({ untap }) %}
  | "scry"i _ number {% ([, , scry]) => ({ scry }) %}
  | "pay"i _ manacost (_ "rather than pay the mana cost for" _ object):? {% ([, , pay, rather]) => rather ? { pay, ratherThanCostOf: rather[3] } : { pay } %}
  | "pay"i _ numericalNumber _ "life" {% ([, , life]) => ({ pay: { life } }) %}
  | "add one mana of any color"i {% () => ({ addOneOf: ["W", "U", "B", "R", "G"], amount: 1 }) %}
  | "add"i _ englishNumber _ "mana of any one color" {% ([, , amount]) => ({ addOneOf: ["W", "U", "B", "R", "G"], amount }) %}
  | "add"i _ englishNumber _ "mana in any combination of" _ manaSymbol _ "and/or" _ manaSymbol {% ([, , amount, , , , c1, , , , c2]) => ({ addCombinationOf: [c1, c2], amount }) %}
  | "add"i _ manaSymbols (",":? _ "or" _ manaSymbols):* {% ([, , m1, ms]) => ({ addOneOf: [m1, ...ms.map(([, , , , m2]) => m2)] }) %}
  | "prevent"i _ damagePreventionAmount _ damageNoun _ "that would be dealt" (_ "to" _ anyEntity):? (_ duration):? {% ([, , amount, , prevent, , , to, duration]) => {
    const result = { amount, prevent };
    if (to) result.to = to[3];
    if (duration) result.duration = duration[1];
    return result;
  } %}
  | "put"i _ englishNumber _ counterKind _ "counter"i "s":? _ "on" _ object {% ([, , amount, , type, , , , , , , putCountersOn]) => ({ amount, type, putCountersOn }) %}
  | "choose"i _ object (_ "from" _ "it"i):? {% ([, , choose]) => ({ choose }) %}
  | "look at the top" _ englishNumber _ "cards of" _ zone {% ([, , lookAtTop, , , , from]) => ({ lookAtTop, from }) %}
  | "look at"i _ object {% ([, , lookAt]) => ({ lookAt }) %}
  | "reveal"i "s":? _ (object | zone) {% ([, , , [reveal]]) => ({ reveal }) %}
  | "put"i _ object _ intoZone (_ "tapped"):? (_ "and" _ object _ intoZone):? {% ([, , put, , into, tapped, additional]) => {
    let result = { put, into };
    if (tapped) result.tapped = true;
    if (additional) result = { and: [result, { put: additonal[3], into: additional[5] }] };
    return result;
  } %}
  | gains _ "control of" _ object {% ([, , , , gainControlOf]) => ({ gainControlOf }) %}
  | "may" _ sentence (". if you do," _ sentence):? {% ([, , may, ifDo]) => ifDo ? { may, ifDo: ifDo[2] } : { may } %}
  | "have" _ object _ objectInfinitive # TODO: ASTize
  | imperative _ "for each"i _ pureObject {% ([does, , , , forEach]) => ({ does, forEach }) %}
  | imperative _ "and" _ sentence {% ([i1, , , , i2]) => ({ and: [i1, i2] }) %}
  | imperative _ "unless" _ imperative {% ([does, , , , unless]) => ({ does, unless }) %}
  | "choose new targets for" _ object {% ([, , newTargets]) => ({ choose: { newTargets } }) %}
  | "switch the power and toughness of" _ object _ untilClause {% ([, , switchPowerToughness, , until]) => ({ switchPowerToughness, until }) %}
  | "do the same for" _ object {% ([, , doSameFor]) => ({ doSameFor }) %}
  | "spend mana as though it were mana of any type to cast" _ object {% ([, , spendManaAsAnyTypeFor]) => ({ spendManaAsAnyTypeFor }) %}
  | "transform" _ object {% ([, , transform]) => ({ transform }) %}
  | "flip a coin" {% () => "flipCoin" %}
  | "win the flip" {% () => "winFlip" %}
  | "lose the flip" {% () => "loseFlip" %}
  | "regenerate"i _ object {% ([, , regenerate]) => ({ regenerate }) %}
  | "bolster"i _ englishNumber {% ([, , bolster]) => ({ bolster }) %}
  | "populate"i {% () => "populate" %}
  | imperative _ untilClause {% ([does, , until]) => ({ does, until }) %}
  | "support"i _ number {% ([, , support]) => ({ support }) %}
  | "attach"i _ object _ "to" _ object {% ([, , attach, , , , to]) => ({ attach, to }) %}

playerVerbPhrase -> gains _ number _ "life" {% ([, , lifeGain]) => ({ lifeGain }) %}
  | gains _ "life" _ "equal" _ "to" _ itsPossessive _ numericalCharacteristic # TODO: ASTize
  | playerVerbPhrase _ "for"i _ "each"i _ pureObject # TODO: ASTize
  | playerVerbPhrase _ "for the first time each turn" # TODO: ASTize
  | controls _ ("no" _):? object {% ([, , negation, controls]) => negation ? { not: { controls } } : { controls } %}
  | owns _ object {% ([, , owns]) => ({ owns }) %}
  | (DON_T | DOESN_T) "lose this mana as steps and phases end." {% () => "doesntEmpty" %}
  | "puts" _ object _ intoZone # TODO: ASTize
  | "surveil"i | "surveil"i "s" # TODO: ASTize
  | "discards" _ object # TODO: ASTize
  | "sacrifices" _ object {% ([, , sacrifice]) => ({ sacrifice }) %}
  | "reveal"i "s" _ playersPossessive _ "hand" # TODO: ASTize
  | "life total becomes" _ englishNumber {% ([, , lifeTotalBecomes]) => ({ lifeTotalBecomes }) %}
  | "attacked" _ duration {% ([, , duration]) => ({ does: "attack", duration }) %}
  | imperative {% ([i]) => i %}
  | playerVerbPhrase ("," | ".") _ "then"i _ playerVerbPhrase # TODO: ASTize
  | CAN_T _ imperative {% ([, , cant]) => ({ cant }) %}
  | DOESN_T | DON_T | "does" | "do" # TODO: ASTize
  | ("loses" | "lose") _ "the game" # TODO: ASTize
  | playerVerbPhrase _ "if"i _ sentence # TODO: ASTize
  | playerVerbPhrase _ "this way" # TODO: ASTize
  | gets _ "an emblem" _ withClause # TODO: ASTize
  | "each" _ playerVerbPhrase {% ([, , eachDo]) => eachDo %}
objectVerbPhrase -> objectVerbPhrase (",":? (_ "and"):? _ objectVerbPhrase):+ {% ([p1, ps]) => ({ and: [p1, ...ps.map(([, , , p2]) => p2)] }) %}
  | objectVerbPhrase _ "or" _ objectVerbPhrase # TODO: ASTize
  | objectVerbPhrase "," (_ "then"):? _ objectVerbPhrase # TODO: ASTize
  | ("was" | "is") _ object {% ([, , is]) => ({ is }) %}
  | ("has" | "have") _ acquiredAbility (_ asLongAsClause):? {% ([, , haveAbility, asLongAs]) => asLongAs ? { haveAbility, asLongAs: asLongAs[1] } : { haveAbility } %}
  | gains _ acquiredAbility _ "and" _ gets _ ptModification # TODO: ASTize
  | gets _ ptModification (_ forEachClause):? (_ "and" _ gains _ acquiredAbility):? (_ untilClause):? (_ asLongAsClause):? {% ([, , powerToughnessMod, forEach, gains, until, asLongAs]) => {
    const result = { powerToughnessMod };
    if (forEach) result.forEach = forEach[1];
    if (gains) result.gains = gains[5];
    if (until) result.until = until[1];
    if (asLongAs) result.asLongAs = asLongAs[1];
    return result;
  } %}
  | "enters" _ "the battlefield"i _ "with" _ ("a"i | "an"i _ "additional") _ counterKind _ "counter"i _ "on" _ "it"i (_ forEachClause):? # TODO: ASTize
  | "enters" _ "the battlefield"i _ "with" _ englishNumber _ counterKind _ "counter"i "s" _ "on" _ "it"i # TODO: ASTize
  | "enters the battlefield with a number of"i (_ "additional"):? _ counterKind _ "counters on it equal to"i _ numberDefinition {% ([, additional, , counterKind, , , , amount]) => ({ entersWith: additional ? { counterKind, amount, additional: true } : { counterKind, amount } }) %}
  | ("enter" | "enters") _ "the battlefield"i (_ "tapped"):? (_ "under" _ playersPossessive _ "control"):? {% ([, , , tapped, control]) => {
    const result = { enter: "theBattlefield" }
    if (tapped) result.tapped = true;
    if (control) result.control = control[3];
    return result;
  } %}
  | ("leave" | "leaves") _ "the battlefield"i {% () => ({ leaves: "theBattlefield" }) %}
  | ("die" | "dies") {% () => "dies" %}
  | "is" _ "put"i _ intoZone _ fromZone # TODO: ASTize
  | CAN_T _ cantClause {% ([, , cant]) => ({ cant }) %}
  | "deals" _ dealsWhat {% ([, , deals]) => ({ deals }) %}
  | ("is" | "are") _ isWhat {% ([, , is]) => ({ is }) %}
  | ("attacks" | "attack") (_ ("this"i | "each"i) _ "combat if able"):? (_ "and" _ ISN_T _ "blocked"):? # TODO: ASTize
  | gains _ acquiredAbility {% ([, , gains]) => ({ gains }) %}
  | DOESN_T _ "untap during" _ qualifiedPartOfTurn # TODO: ASTize
  | "blocks or becomes blocked by" _ object # TODO: ASTize
  | "is countered this way" # TODO: ASTize
  | "fights" _ object # TODO: ASTize
  | "targets" _ object # TODO: ASTize
  | "loses" _ keyword {% ([, , loses]) => ({ loses }) %}
  | ("cost" | "costs") _ manacost _ "less" _ "to" _ "cast"i # TODO: ASTize
  | "can attack as though it didn\"t have defender" # TODO: ASTize
  | "can block an additional" _ object _ "each combat" {% ([, , blockAdditional]) => ({ blockAdditional }) %}
  | "do so" # TODO: ASTize
  | "does so" # TODO: ASTize
  | ("remain" | "remains") _ "exiled" # TODO: ASTize
  | "becomes" _ becomesWhat {% ([, , becomes]) => ({ becomes }) %}
  | ("lose" | "loses") _ "all abilities" (_ untilClause):? # TODO: ASTize
  | ("is"|"are") _ "created" # TODO: ASTize
  | "causes" _ player _ "to discard" _ object # TODO: ASTize
  | objectVerbPhrase _ forEachClause # TODO: ASTize
  | objectVerbPhrase _ duration {% ([does, , duration]) => ({ does, duration }) %}
  | objectVerbPhrase _ "if"i _ sentence # TODO: ASTize
  | "was kicked" # TODO: ASTize
  | CAN_T _ "be countered" # TODO: ASTize
  | ("the" _):? "damage" _ CAN_T _ "be prevented" {% () => ({ cantPrevent: "damage" }) %}
  | CAN_T _ "attack" _ duration {% ([, , , , cantAttack]) => ({ cantAttack }) %}
  | CAN_T _ "be blocked" (_ "by" _ object):? (_ duration):? {% ([, , , by, duration]) => {
    const result = { cant: { blockedBy: by ? by[3] : "any" } };
    if (duration) result.duration = duration[1];
    return result;
  } %}
  | "as" _ object (_ "in addition to its other types"):? {% ([, , as, inAddition]) => inAddition ? { as, inAddition: true } : { as } %}
objectInfinitive -> "be put"i _ intoZone _ duration # TODO: ASTize
  | "be created under your control"i # TODO: ASTize
  | "fight" _ object # TODO: ASTize
  | "deal" _ dealsWhat # TODO: ASTize

isWhat -> color {% ([color]) => ({ color }) %}
  | object (_ "in addition to its other types"i):? {% ([object, addition]) => addition ? { object, inAddition: true } : { object } %}
  | inZone {% ([inZone]) => ({ inZone }) %}
  | "still" _ object {% ([, , still]) => ({ still }) %}
  | "turned face up" {% () => "turnedFaceUp" %}
  | "attacking"i {% () => "attacking" %}
  | "blocking"i {% () => "blocking" %}
  | "attacking" _ "or" _ "blocking" {% () => ({ or: ["attacking", "blocking"] }) %}
  | condition {% ([condition]) => ({ condition }) %}
becomesWhat -> "tapped" # TODO: ASTize
  | "untapped" # TODO: ASTize
  | "a copy of" _ object ("," _ exceptClauseInCopyEffect):? # TODO: ASTize
  | "a" "n":? (_ pt):? _ anyType (_ "with base power and toughness" _ pt) {% ([, , , size, , type, size2]) => {
    const result = { type };
    if (size) result.size = size[1];
    else if (size2) result.size = size2[3];
    return result;
  } %}
  | "the basic land type" "s":? _ "of your choice" _ untilClause {% ([, , , , , until]) => ({ choose: "basicLandType", until }) %}
  | "blocked" (_ "by" _ object) {% ([, by]) => by ? { blockedBy: by[3] } : { blockedBy: "any" } %}
exceptClauseInCopyEffect -> "except"i _ copyException ("," _ ("and" _ ):? copyException):* # TODO: ASTize
copyException -> "its name is" _ CARD_NAME # TODO: ASTize
  | IT_S _ isWhat # TODO: ASTize
  | singleSentence # TODO: ASTize

itsPossessive -> object SAXON {% ([o]) => o %}
  | "its"i {% () => ({ reference: "its" }) %}
  | "their"i {% () => ({ reference: "their" }) %}

acquiredAbility -> keyword {% ([k]) => k %}
  | "\"" ability "\"" {% ([, a]) => a %}
  | "“" ability "”" {% ([, a]) => a %}
  | acquiredAbility _ "and" _ acquiredAbility {% ([a1, , , , a2]) => ({ and: [a1, a2] }) %}
  | "this ability" {% () => "thisAbility" %}

gets -> "get" "s":?
controls -> "control" "s":?
owns -> "own" "s":?
gains -> "gain"i "s":?

duration -> "this turn" {% () => "thisTurn" %}
  | "last turn" {% () => "lastTurn" %}
  | ("for"i _):? asLongAsClause {% ([, asLongAs]) => ({ asLongAs }) %}
  | untilClause {% ([until]) => ({ until }) %}
untilClause -> "until"i _ untilClauseInner {% ([, , u]) => u %}
untilClauseInner -> sentence {% ([s]) => s %}
  | "end of turn"i {% () => "endOfTurn" %}
  | "your next turn"i {% () => "yourNextTurn" %}

numericalCharacteristic -> "toughness" # TODO: ASTize
  | "power" # TODO: ASTize
  | "converted mana cost" # TODO: ASTize

damagePreventionAmount -> "all"i {% () => "all" %}
  | "the next" _ englishNumber {% ([, , next]) => next %}
damageNoun -> ("non":? "combat" _):? "damage" {% ([combat]) => ({ damage: combat ? (combat[0] ? { not: "combat" } : "combat") : "any" }) %}

tokenDescription -> englishNumber _ pt _ color _ permanentType _ "token" "s":? (_ withClause):? (_ "named" _ [^.]:+):? {% ([amount, , size, , color, , tokenType, , , withClause, name]) => {
  const result = { amount, size, color, tokenType };
  if (withClause) result.with = withClause[1];
  if (name) result.name = name[3].join('');
  return result;
} %}

color -> "white" # TODO: ASTize
  | "blue" # TODO: ASTize
  | "black" # TODO: ASTize
  | "red" # TODO: ASTize
  | "green" # TODO: ASTize
  | "colorless" # TODO: ASTize
  | "monocolored" # TODO: ASTize
  | "multicolored" # TODO: ASTize
  | color _ "and" _ color # TODO: ASTize

pt -> number "/" number {% ([power, , toughness]) => ({ power, toughness }) %}
ptModification -> PLUSMINUS number "/" PLUSMINUS number {% ([pmP, power, , pmT, toughness]) => ({ powerMod: '+' === pmP.toString() ? power : -power, toughnessMod: '+' === pmT.toString() ? toughness : -toughness }) %}
numberDefinition -> itsPossessive _ numericalCharacteristic {% ([whose, , characteristic]) => ({ whose, characteristic }) %}
  | "the"i _ ("total"i _):? "number of" _ object {% ([, , , , , count]) => ({ count }) %}
integerValue -> [0-9]:+ {% ([digits]) => parseInt(digits.join(''), 10) %}

withClause -> "with"i _ withClauseInner {% ([, , withInner]) => ({ with: withInner }) %}
withClauseInner -> numericalCharacteristic _ numericalComparison # TODO ASTize
  | "the highest" _ numericalCharacteristic _ "among"i _ object # TODO ASTize
  | "converted mana costs" _ numericalNumber _ "and" _ numericalNumber # TODO ASTize
  | counterKind _ "counter" "s":? _ "on"i _ ("it"i | "them"i) # TODO ASTize
  | "that name"i {% () => "thatName" %}
  | "the same name as" _ object {% ([, , sameNameAs]) => ({ sameNameAs }) %}
  | acquiredAbility {% ([ability]) => ({ ability }) %}
  | object {% ([object]) => ({ object }) %}
counterKind -> (ptModification
  | "charge"
  | "hit"
  | "wish"
  | "flying"
  | "lifelink"
  | "deathtouch"
  | "indestructible"
  | "trample"
  | "bounty"
  | "quest"
  | "wish"
  | "divinity"
  | "shield"
  | "brick"
  | "fetch") {% ([[counter]]) => counter %}

dealsWhat -> damageNoun _ "to" _ damageRecipient {% ([damage, , , , to]) => ({ ...damage, to }) %}
 | numericalNumber _ "damage to" _ damageRecipient {% ([amount, , , , damageTo]) => ({ amount, damageTo }) %}
 | "damage equal to" _ numberDefinition _ "to" _ damageRecipient {% ([, , amount, , , , damageTo]) => ({ amount, damageTo }) %}
 | "damage to" _ damageRecipient _ "equal to" _ numberDefinition {% ([, , damageTo, , , , amount]) => ({ amount, damageTo }) %}
 | numericalNumber _ "damage" _ divideAmongDamageTargets {% ([amount, , , , divideAmong]) => ({ amount, divideAmong }) %}

damageRecipient -> object {% ([o]) => o %}
  | player {% ([p]) => p %}
  | "any target"i {% () => "anyTarget" %}
  | ("target" _):? damageRecipient _ ("and" | "or") _ damageRecipient {% ([target, r1, , [connector], , r2]) => target ? { [connector]: [{ target: r1}, {target: r2}] } : { [connector]: [r1, r2] } %}
  | "itself"i # TODO: ASTize
# TODO: Fix this to be more generic
divideAmongDamageTargets -> "divided as you choose among" _ divideTargets {% ([, , divideTargets]) => divideTargets %}
divideTargets -> "one, two, or three targets"i {% () => ({ targetCount: [1, 2, 3] }) %}
  | "any number of targets"i {% () => ({ targetCount: "any" }) %}

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
numericalComparison -> number _ "or greater"i # TODO: ASTize
  | number _ "or less"i # TODO: ASTize
  | "less than or equal to" _ numberDefinition # TODO: ASTize
  | "greater than" _ numberDefinition # TODO: ASTize
  | number # TODO: ASTize
countableCount -> "exactly"i _ englishNumber # TODO: ASTize
  | englishNumber _ "or more"i {% ([atLeast]) => ({ atLeast }) %}
  | "fewer than" _ englishNumber {% ([, , lessThan]) => ({ lessThan }) %}
  | "any number of" {% () => "anyNumber" %}
  | "one of" {% () => 1 %}
  | "up to" _ englishNumber {% ([, , upTo]) => ({ upTo }) %}
  | englishNumber {% ([n]) => n %}
  | "all"i {% () => "all" %}
  | "both"i {% () => "both" %}

cantClause -> cantClauseInner (_ "unless" _ condition):? {% ([cant, unless]) => unless ? { cant, unless: unless[3] } : cant %}
cantClauseInner -> "attack" # TODO: ASTize
  | "block" # TODO: ASTize
  | "attack or block" # TODO: ASTize
  | "attack or block alone" # TODO: ASTize
  | "be blocked" # TODO: ASTize
  | "be countered" # TODO: ASTize
  | "be blocked by more than" _ englishNumber _ "creature"i "s":? # TODO: ASTize

zone -> (playersPossessive | "a"i) _ ownedZone {% ([[owner], , zone]) => ({ owner, zone }) %}
  | "exile"i {% () => "exile" %}
  | "the battlefield"i {% () => "theBattlefield" %}
  | "it"i {% () => "it" %}
ownedZone -> "graveyard" {% () => "graveyard" %}
  | "library" {% () => "library" %}
  | "libraries" {% () => "library" %}
  | "hand" {% () => "hand" %}
  | ownedZone "s" {% ([z]) => z %}
  | ownedZone _ ("and"i {% () => "and" %} | "or"i {% () => "xor" %} | "and/or"i {% () => "or" %}) _ ownedZone {% ([z1, , connector, , z2]) => ({ [connector]: [z1, z2] }) %}
  | ownedZone ("," _ ("and" _):? ownedZone):+ {% ([z, zs]) => ({ and: [z, ...zs.map(([, , , z2]) => z2)] }) %}
intoZone -> "onto the battlefield"i {% () => ({ into: "theBattlefield" }) %}
  | "into" _ zone {% ([, , into]) => ({ into }) %}
  | "on top of" _ zone {% ([, , onTopOf]) => ({ onTopOf }) %}
  | "on the bottom of" _ zone (_ ("in" _  ("any" | "a random") _ "order")):? # TODO ASTize
inZone -> "on the battlefield" # TODO: ASTize
  | "in" _ zone # TODO: ASTize
fromZone -> "from" _ zone # TODO: ASTize

permanentType -> "artifact" {% () => "artifact" %}
  | "creature"i {% () => "creature" %}
  | "enchantment"i {% () => "enchantment" %}
  | "land"i {% () => "land" %}
  | "planeswalker"i {% () => "planeswalker" %}
  | "basic"i {% () => "basic" %}
  | "permanent"i {% () => "permanent" %}
  | creatureType {% ([t]) => t %}
  | landType {% ([t]) => t %}
  | artifactType {% ([t]) => t %}
  | enchantmentType {% ([t]) => t %}
  | planeswalkerType {% ([t]) => t %}
  | permanentType _ permanentType {% ([t1, , t2]) => ({ and: [t1, t2] }) %}
  | permanentType _ "or"i _ permanentType {% ([t1, , , , t2]) => ({ or: [t1, t2] }) %}
anyType -> permanentType {% ([t]) => t %}
  | spellType {% ([t]) => t %}
  | "legendary"i {% () => "legendary" %}
  | "[" anyType "]" {% ([, t]) => t %}
spellType -> "instant"i {% () => "instant" %}
  | "sorcery"i {% () => "sorcery" %}
  | "adventure"i {% () => "adventure" %}
  | "arcane"i {% () => "arcane" %}
  | "trap"i {% () => "trap" %}
  | "spell"i {% () => "spell" %}
  | spellType _ ("and" | "or") _ spellType {% ([t1, , connector, , t2]) => ({ [connector]: [t1, t2] }) %}
creatureType -> ("Advisor"i
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
  | "Zubera"i) {% ([[t]]) => t.toLowerCase() %}
planeswalkerType -> ("Ajani"i
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
  | "Yanling"i) {% ([[t]]) => t.toLowerCase() %}
landType -> (basicLandType
  | "Desert"i
  | "Gate"i
  | "lair"i
  | "locus"i
  | "mine"i
  | "power-plant"i
  | "tower"i
  | "urza's"i) {% ([[t]]) => t.toLowerCase() %}
basicLandType -> ("plains"i
  | "island"i
  | "swamp"i
  | "mountain"i
  | "forest"i) {% ([[t]]) => t.toLowerCase() %}
enchantmentType -> ("aura"i
  | "cartouche"i
  | "curse"i
  | "saga"i
  | "shrine"i) {% ([[t]]) => t.toLowerCase() %}
artifactType -> ("clue"i
  | "contraption"i
  | "equipment"i
  | "food"i
  | "fortification"i
  | "gold"i
  | "treasure"i
  | "vehicle"i) {% ([[t]]) => t.toLowerCase() %}

asLongAsClause -> "as long as"i _ condition {% ([, , c]) => c %}

# TODO Generify
replacementEffect -> sentence _ "instead of putting it" _ intoZone # TODO: ASTize

costs -> cost (",":? __ ("and" | "or" | "and/or"):?  _ cost):* {% ([c, cs]) => [c, ...cs.map(([, , c2]) => c2)] %}
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

qualifiedPartOfTurn -> turnQualification _ partOfTurn {% ([qualification, , partOfTurn]) => ({ qualification, partOfTurn }) %}
  | "combat on your turn"i {% () => ({ qualification: "yourTurn", partOfTurn: "combat" }) %}
  | "combat"i {% () => ({ partOfTurn: "combat" }) %}
turnQualification -> (playersPossessive | "the"i) (_ "next"):? # TODO: ASTize
  | "this"i # TODO: ASTize
  | "each"i # TODO: ASTize
  | "this turn"i SAXON # TODO: ASTize
  | "that turn"i SAXON # TODO: ASTize
partOfTurn -> "turn" {% () => turn %}
  | "untap step"i {% () => "untap" %}
  | "upkeep"i {% () => "upkeep" %}
  | "draw step"i {% () => "drawStep" %}
  | "precombat main phase"i {% () => "precombatMain" %}
  | "main phase"i {% () => "main" %}
  | "postcombat main phase"i {% () => "postcombatMain" %}
  | "end step"i {% () => "end" %}

playersPossessive -> "your" {% () => "your" %}
  | "their" {% () => "their" %}
  | player (SAXON | AP) {% ([player]) => player %}

AP -> "'" | "’"
CARD_NAME -> ("~" 
  | "Prossh") {% () => "CARD_NAME" %}
CAN_T -> "can't"i | "can’t"i
DON_T -> "don't"i | "don’t"i
DOESN_T -> "doesn't"i | "doesn’t"i
DASHDASH -> "--" | "—"
ISN_T -> "isn't"i | "isn’t"i
IT_S -> "it's"i | "it’s"i
PLUSMINUS -> "+" | "-" | "−"
SAXON -> AP "s"
THAT_S -> "that's"i | "that’s"i
YOU_VE -> "you've" | "you’ve"i
