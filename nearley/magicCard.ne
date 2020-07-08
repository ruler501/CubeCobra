# @builtin "whitespace.ne"
# Based on https://github.com/Soothsilver/mtg-grammar/blob/master/mtg.g4
start -> card
_ -> " ":*
__ -> " ":+
card -> "\n":* ability:? ("\n":+ ability):* "\n":? {% ([, a, as]) => a ? [a, ...as.map(([, a2]) => a2).filter((a) => a)] : [...as.map(([, a2]) => a2).filter((a) => a)] %}
ability -> (abilityWordAbility
  | activatedAbility
  | additionalCostToCastSpell
  | keywords
  | modalAbility
  | staticOrSpell
  | triggeredAbility
  | reminderText {% () => [null] %}
) ".":? (__ reminderText):? {% ([[a]]) => a %}

connected[rule] -> $rule ("," __ $rule):* ",":? __ (("then" | "and"i) {% () => "and" %} | "or"i {% () => "xor" %} | "and/or"i {% () => "or" %}) __ $rule {% ([o, os, , , connector, , o2]) => ({ [connector]: [o, ...os.map(([, , o3]) => o3), o2] }) %}

reminderText -> "(" [^)]:+ ")"

modalAbility -> "choose"i __ modalQuantifier __ DASHDASH (__ modalOption):+ {% ([, , quantifier, , , options]) => ({ quantifier, options: options.map(([, o]) => o) }) %}
modalOption -> ("*" | "•") __ effect {% ([, , e]) => e %}
modalQuantifier -> "one or both"i {% () => [1, 2] %}
  | "one" {% () => [1] %}

keywords -> keyword (("," | ";") __ keyword):* {% ([k1, ks]) => [k1].concat(ks.map(([, , k]) => k)) %}
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
  #  | companionKeyword # TODO: Implement
  | mutateKeyword
  | megamorphKeyword) {% ([[keyword]]) => keyword %}
cyclingKeyword -> "cycling"i __ cost {% ([, , cost]) => ({ cycling: cost }) %}
enchantKeyword -> "enchant"i __ anyEntity {% ([, , entity]) => ({ enchant: entity }) %}
equipKeyword -> "equip"i __ cost {% ([, , cost]) => ({ equip: cost }) %}
cumulativeUpkeepKeyword -> "cumulative upkeep"i __ cost {% ([, , cumulativeUpkeep]) => ({ cumulativeUpkeep }) %}
escapeKeyword -> "escape"i __ cost {% ([, , escape]) => ({ escape }) %}
spectacleKeyword -> "spectacle"i __ cost {% ([, , spectacle]) => ({ spectacle }) %}
afterlifeKeyword -> "afterlife"i __ number {% ([, , afterlife]) => ({ afterlife }) %}
afflictKeyword -> "afflict"i __ number {% ([, , afflict]) => ({ afflict }) %}
eternalizeKeyword -> "eternalize"i __ cost {% ([, , eternalize]) => ({ eternalize }) %}
embalmKeyword -> "embalm"i __ cost {% ([, , embalm]) => ({ embalm }) %}
partnerKeyword -> "partner"i {% () => "partner" %}
  | "partner with"i [^\n(]:+ {% ([, partnerWith]) => ({ partnerWith: partnerWith.join('') }) %}
fabricateKeyword -> "fabricate"i __ number {% ([, , fabricate]) => ({ fabricate }) %}
crewKeyword -> "crew"i __ number {% ([, , crew]) => ({ crew }) %}
escalateKeyword -> "escalate"i __ cost {% ([, , escalate]) => ({ escalate }) %}
emergeKeyword -> "emerge"i __ cost {% ([, , emerge]) => ({ emerge }) %}
surgeKeyword -> "surge"i __ cost {% ([, , surge]) => ({ surge }) %}
awakenKeyword -> "awaken"i __ cost {% ([, , awaken]) => ({ awaken }) %}
renownKeyword -> "renown"i __ number {% ([, , renown]) => ({ renown }) %}
dashKeyword -> "dash"i __ cost {% ([, , dash]) => ({ dash }) %}
outlastKeyword -> "outlast"i __ cost {% ([, , outlast]) => ({ outlast }) %}
tributeKeyword -> "tribute"i __ number {% ([, , tribute]) => ({ tribute }) %}
mutateKeyword -> "mutate"i __ cost {% ([, , mutate]) => ({ mutate }) %}
bestowKeyword -> "bestow"i __ cost {% ([, , bestow]) => ({ bestow }) %}
scavengeKeyword -> "scavenge"i __ cost {% ([, , scavenge]) => ({ scavenge }) %}
overloadKeyword -> "overload"i __ cost {% ([, , overload]) => ({ overload }) %}
buybackKeyword -> "buyback"i __ cost {% ([, , buyback]) => ({ buyback }) %}
rampageKeyword -> "rampage"i __ number {% ([, , rampage]) => ({ rampage }) %}
echoKeyword -> "echo"i __ cost {% ([, , echo]) => ({ echo }) %}
fadingKeyword -> "fading"i __ number {% ([, , fading]) => ({ fading }) %}
kickerKeyword -> "kicker"i __ costs {% ([, , kicker]) => ({ kicker }) %}
flashbackKeyword -> "flashback"i __ cost {% ([, , flashback]) => ({ flashback }) %}
madnessKeyword -> "madness"i __ cost {% ([, , madness]) => ({ madness }) %}
morphKeyword -> "morph"i __ cost {% ([, , morph]) => ({ morph }) %}
amplifyKeyword -> "amplify"i __ number {% ([, , amplify]) => ({ amplify }) %}
entwineKeyword -> "entwine"i __ cost {% ([, , entwine]) => ({ entwine }) %}
modularKeyword -> "modular"i __ number {% ([, , module]) => ({ modular }) %}
bushidoKeyword -> "bushido"i __ number {% ([, , bushido]) => ({ bushido }) %}
ninjutsuKeyword -> "ninjutsu"i __ cost {% ([, , ninjutsu]) => ({ ninjutsu }) %}
dredgeKeyword -> "dredge"i __ number {% ([, , dredge]) => ({ dredge }) %}
transmuteKeyword -> "transmute"i __ cost {% ([, , transmute]) => ({ transmute }) %}
bloodthirstKeyword -> "bloodthirsty"i __ number {% ([, , bloodthirsty]) => ({ bloodthirsty }) %}
replicateKeyword -> "replicate"i __ cost {% ([, , replicate]) => ({ replicate }) %}
graftKeyword -> "graft"i __ number {% ([, , graft]) => ({ graft }) %}
recoverKeyword -> "recover"i __ cost {% ([, , recover]) => ({ recover }) %}
rippleKeyword -> "ripple"i __ number {% ([, , ripple]) => ({ ripple }) %}
suspendKeyword -> "suspend"i __ number __ DASHDASH __ cost {% ([, , suspend, , , , cost]) => ({ suspend, cost }) %}
vanishingKeyword -> "vanishing"i __ number {% ([, , vanishing]) => ({ vanishing }) %}
absordKeyword -> "absorb"i __ number {% ([, , absorb]) => ({ absorb }) %}
fortifyKeyword -> "fortify"i __ cost {% ([, , fortify]) => ({ fortify }) %}
frenzy -> "frenzy"i __ number {% ([, , frenzy]) => ({ frenzy }) %}
poisonousKeyword -> "poisonous"i __ number {% ([, , poisonous]) => ({ poisonous }) %}
evokeKeyword -> "evoke"i __ cost {% ([, , evoke]) => ({ evoke }) %}
devourKeyword -> "devour"i __ number {% ([, , devour]) => ({ devour }) %}
unearthKeyword -> "unearth"i __ cost {% ([, , unearth]) => ({ unearth }) %}
annihilatorKeyword -> "annihilator"i __ number {% ([, , annihilator]) => ({ annihilator }) %}
levelUpKeyword -> "level up"i __ cost {% ([, , levelUp]) => ({ levelUp }) %}
miracleKeyword -> "miracle"i __ cost {% ([, , miracle]) => ({ miracle }) %}
megamorphKeyword -> "megamorph"i __ cost {% ([, , megamorph]) => ({ megamorph }) %}
affinityKeyword -> "affinity for"i __ object {% ([, , affinityFor]) => ({ affinityFor }) %}
partnerKeyword -> "partner"i {% () => "partner" %}
  | "partner with"i __ [^\n]:+ {% ([, , partnerWith]) => ({ partnerWith: partnerWith.join('') }) %}
offeringKeyword -> object __ "offering" {% ([offering]) => ({ offering }) %}
frenzyKeyword -> "frenzy"i __ number {% ([, , frenzy]) => ({ frenzy }) %}
soulshiftKeyword -> "soulshift"i __ number {% ([, , soulshift]) => ({ soulshift }) %}
spliceKeyword -> "splice onto"i __ object __ cost {% ([, , spliceOnto, , cost]) => ({ spliceOnto, cost }) %}
forecastKeyword -> "forecast"i __ DASHDASH __ activatedAbility {% ([, , , , forecast]) => ({ forecast }) %}
championKeyword -> "champion"i __ object {% ([, , champion]) => ({ champion }) %}
protectionKeyword -> "protection from"i __ anyEntity {% ([, , protectionFrom]) => ({ protectionFrom }) %}
prowlKeyword -> "prowl"i __ cost {% ([, , prowl]) => ({ prowl }) %}
reinforceKeyword -> "reinforce"i __ number __ DASHDASH __ cost {% ([, , reinforce, , , , cost]) => ({ reinforce, cost }) %}
transfigureKeyword -> "transfigure"i __ cost {% ([, , transfigure]) => ({ transfigure }) %}
bandingKeyword -> "banding"i {% () => ({ bandsWith: "any" }) %}
  | "bands with"i __ object {% () => ({ bandsWith: object }) %}
landwalkKeyword -> anyType "walk" {% ([landwalk]) => ({ landwalk }) %}
  | "nonbasic landwalk"i {% () => ({ landwalk: { not: { type: "basic" } } }) %}
  | "snow landwalk"i {% () => ({ landwalk: { type: "snow" } }) %}
auraSwapKeyword -> "aura swap"i __ cost {% ([, , auraSwap]) => ({ auraSwap }) %}

abilityWordAbility -> abilityWord __ DASHDASH __ ability {% ([aw, , , , a]) => ({ [aw]: a }) %}
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

activatedAbility -> costs ":" __ effect (__ activationInstructions):? {% ([costs, , , activatedAbility, i]) => {
  const result = { costs, activatedAbility };
  if (i) result.instructions = i;
  return result;
} %}
activationInstructions -> "activate this ability only "i activationInstruction "." {% ([, i]) => ({ only: i }) %}
  | "any player may activate this ability."i {% () => "anyPlayer" %}
activationInstruction -> "once each turn"i {% () => "onceATurn" %}
  | "any time you could cast a sorcery"i {% () => "sorceryOnly" %}
  | "if" __ player __ "control" "s":? __ object {% ([, , who, , , , , controls]) => ({ who, controls }) %}
  | "only if" __ condition {% ([, , condition]) => ({ condition }) %}
# TODO: Make into AST
activatedAbilities -> (itsPossessive __):? "activated abilities"i {% ([reference]) => reference ? { whose: reference, activatedAbilities: "any" } : { activatedAbilities: "any" } %}
  | "activated abilities of"i __ object {% ([, , activatedAbilities]) => ({ whose: activatedAbilities, activatedAbilities: true }) %}
activatedAbilitiesVP -> CAN__T __ "be activated"i (__ "unless they're mana abilities."):? {% ([, , , , manaOnly]) => manaOnly ? { cant: "activatedAbilities", unless: "manaAbility" } : { cant: "activatedAbilities" } %}

triggeredAbility -> triggerCondition "," __ interveningIfClause:? effect {% ([trigger, , , ifClause, effect]) => {
  const result = { trigger, effect };
  if (ifClause) result.ifClause = ifClause
  return result;
} %}
triggerCondition -> ("when"i | "whenever"i) __ triggerConditionInner (__ triggerTiming):? {% ([, , inner, timing]) => {
  const result = { when: inner };
  if (timing) result.timing = timing[1];
  return result;
} %}
  | "at the beginning of"i __ qualifiedPartOfTurn {% ([, , turnPhase]) => ({ turnPhase }) %}
  | "at end of combat"i {% () => ({ turnPhase: "endCombat" }) %}
triggerConditionInner -> singleSentence {% ([s]) => s %}
  | "you cast "i object {% ([, cast]) => ({ cast }) %}
  | player __ gains __ "life"i {% ([actor]) => ({ actor, does: "gainsLife" }) %}
  | object __ "is dealt damage"i {% ([what]) => ({ what, does: "dealtDamage" }) %}
  | object __ objectVerbPhrase {% ([what, , does]) => ({ what, does }) %}
interveningIfClause -> "if "i condition "," {% ([, c]) => c %}
triggerTiming -> "each turn"i {% () => "eachTurn" %}
  | "during each opponent" SAXON __ "turn" {% () => "eachOpponentTurn" %}

additionalCostToCastSpell -> "as an additional cost to cast this spell,"i __ imperative "." {% ([, , additionalCost]) => ({ additionalCost }) %}

staticOrSpell -> sentenceDot {% ([sd]) => sd %}
effect -> (sentenceDot
  | modalAbility) {% ([[e]]) => e %}

sentenceDot -> sentence (".":? __ additionalSentence):* ".":? {% ([s, ss]) => ss.length > 0 ? [s, ...ss.map(([, , s2]) => s2)] : s %}
additionalSentence -> sentence {% ([s]) => s %}
  | triggeredAbility {% ([t]) => t %}

sentence -> singleSentence {% ([ss]) => ss %}
  | singleSentence "," __ sentence {% ([s1, , , s2]) => ({ and: [s1, s2] }) %}
  | "then"i __ sentence {% ([, , s]) => s %}
  | connected[sentence] {% ([c]) => c %}
  | "otherwise,"i __ sentence {% ([, , otherwise]) => ({ otherwise }) %}
  | sentence __ "rather than" __ sentence {% ([does, , , , ratherThan]) => ({ does, ratherThan }) %}
  | sentence __ "at" __ qualifiedPartOfTurn {% ([does, , , , at]) => ({ does, at }) %}
singleSentence -> imperative {% ([i]) => i %}
  | singleSentence ", where X is"i __ numberDefinition {% ([singleSentence, , , X]) => ({ singleSentence, X }) %}
  | object __ objectVerbPhrase {% ([what, , does]) => ({ what, does }) %}
  | IT__S __ isWhat {% ([, , is]) => ({ is }) %}
  | player __ playerVerbPhrase {% ([actor, , does]) => ({ actor, does }) %}
  | "if"i __ sentence "," __ replacementEffect {% ([, , condition, , , replacementEffect]) => ({ condition, replacementEffect }) %}
  | "if"i __ condition "," __ sentence {% ([, , condition, , , effect]) => ({ condition, effect }) %}
  | "if"i __ object __ "would"i __ (objectVerbPhrase | objectInfinitive) "," __ sentenceInstead {% ([, , what, , , , [does], , , instead]) => ({ what, does, instead }) %}
  | "if"i __ player __ "would"i __ playerVerbPhrase "," __ sentenceInstead {% ([, , who, , , , would, , , instead]) => ({ who, would, instead }) %}
  | asLongAsClause "," __ sentence {% ([asLongAs, , , effect]) => ({ asLongAs, effect }) %}
  | duration "," __ sentence {% ([duration, , , effect]) => ({ duration, effect }) %}
  | "for each"i __ object "," __ sentence {% ([, , forEach, , , effect]) => ({ forEach, effect }) %}
  | activatedAbilities __ activatedAbilitiesVP (__ duration):? {% ([abilities, , effect, duration]) => duration ? { ...abilities, ...effect, duration: duration[1] } : { ...abilities, ...effect } %}
  | itsPossessive __ numericalCharacteristic __ ("is" | "are each") __ "equal to"i __ numberDefinition {% ([what, , characteristic, , , , , , setTo]) => ({ what, characteristic, setTo }) %}
  | "as"i __ sentence "," __ sentence {% ([, , as, , , does]) => ({ as, does }) %}
  | "instead"i __ singleSentence {% ([, , instead]) => ({ instead }) %}
sentenceInstead -> sentence __ "instead"i {% ([instead]) => ({ instead }) %}
  | "instead"i __ sentence {% ([, ,instead]) => ({ instead }) %}

forEachClause -> "for each" __ pureObject {% ([, , forEach]) => ({ forEach }) %}
 | "for each color of mana spent to cast"i __ object {% ([, , forEachColorSpent]) => ({ forEachColorSpent }) %}

condition -> sentence {% ([s]) => s %}
  | (YOU__VE | "you") __ action __ duration {% ([, , done, , during]) => ({ done, during }) %}
  | IT__S __ "your turn"i {% () => "yourTurn" %}
  | IT__S __ "not" __ playersPossessive __ "turn" {% ([, , notTurnOf]) => ({ notTurnOf }) %}
  | object __ "has"i __ countableCount __ (counterKind __):? "counter" "s":? "on it"i {% ([object, , , count, , hasCounter]) => ({ object, count, hasCounter }) %}
  | numberDefinition __ "is"i __ numericalComparison {% ([number, , , , is]) => ({ number, is }) %}
  | "that mana is spent on"i __ object {% ([, , manaSpentOn]) => ({ manaSpentOn }) %}
  | ("is" __):? "paired" __ withClause {% ([, , , pairedWith]) => ({ pairedWith }) %}
  | ("is" __):? "untapped" {% () => "untapped" %}

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
  | commonReferencingPrefix __ purePlayer {% ([reference, , player]) => ({ reference, player }) %}
  | "your opponent" "s":? {% ([, plural]) => plural ? "opponent" : "opponents" %}
  | "defending player" {% () => "defendingPlayer" %}
  | itsPossessive __ "controller"i "s":? {% () => "objectsController" %}
  | itsPossessive __ "owner"i "s":? {% () => "objectsOwner" %}
  | "player" {% () => "player" %}
  | "each of" __ player {% ([, , each]) => ({ each }) %}
purePlayer -> "opponent"i {% () => "opponent" %}
  | "player"i {% () => "player" %}
  | "players"i {% () => "players" %}
  | "opponents"i {% () => "opponents" %}
object -> (referencingObjectPrefix __):? objectInner {% ([reference, object]) => reference ? { objectFull: true, reference: reference[0], object } : object %}
objectInner -> "it"i {% () => "it" %}
  | "them"i {% () => "them" %}
  | "they"i {% () => "they" %}
  | "rest"i {% () => "rest" %}
  | "this emblem"i {% () => "emblem" %}
  | object __ THAT__S __ isWhat {% ([object, , , , condition]) => ({ object, condition }) %}
  | connected[object] {% ([c]) => c %}
  | pureObject {% ([po]) => po %}
  | "each of"i __ object {% ([, , eachOf]) => ({ eachOf }) %}
  | "the top"i __ englishNumber __ "cards of"i __ zone {% ([, , topCards, , , , from]) => ({ topCards, from }) %}
  | "the top of" __ zone {% ([, , topOf]) => ({ topOf }) %}
  | "the top card of"i __ zone {% ([, , from]) => ({ topCards: 1, from }) %}
  | (counterKind __):? "counter"i "s":? __ "on" __ object {% ([kind, , , , , , countersOn]) => kind ? { counterType: kind[0], countersOn } : { countersOn } %}
suffix -> player __ ((DON__T | DOESN__T) __):? ("control"i | "own"i) "s":? {% ([who, negate, , does]) => negate ? { who, does: { not: does } } : { who, does } %}
  | "in"i __ zone (__ "and in"i __ zone):? {% ([, , zone, zone2]) => zone2 ? { and: [{ in: zone}, {in: zone2[3]}] } : { in: zone } %}
  | "from"i __ (zone | object) {% ([, , [from]]) => ({ from }) %}
  | ("that" __):? "you cast"i {% () => "youCast" %}
  | "that" __ didAction (__ duration):? {% ([, , didAction, when]) => when ? { didAction, when: when[1] } : { didAction } %}
  | "that targets only"i __ object {% ([, , onlyTargets]) => ({ onlyTargets }) %}
  | "that targets"i __ anyEntity {% ([, , targets]) => ({ targets }) %}
  | "tapped this way"i {% () => "tappedThisWay" %}
  | ("destroyed"i {% () => "destroy" %} | "exiled"i {% () => "exile" %}) __ (fromZone __):? "this way"i {% ([does, , from]) => from ? { from: from[0], reference: "thisWay", does } : { reference: "thisWay", does } %}
  | "of the"i __ anyType __ "type of"i __ playersPossessive __ "choice"i {% ([, , type, , , , who]) => ({ type, who, does: "choose" }) %}
  | "on the battlefield" {% () => ({ in: "theBattlefield" }) %}
  | object __ "could target"i {% ([couldTarget]) => ({ couldTarget }) %}
  | "able to block"i __ object {% ([, , canBlock]) => ({ canBlock }) %}
  | "that convoked"i __ object {% ([, , convoked]) => ({ convoked }) %}
  | "from among them"i {% () => "amongThem" %}
  | "named"i __ CARD_NAME {% ([, , named]) => ({ named }) %}
  | YOU__VE __ "cast before it this turn"i {% () => "youveCastBeforeThisTurn" %}
  | "not named"i __ CARD_NAME {% ([, , named]) => ({ not: { named } }) %}
  | "attached to" __ object {% ([, , attachedTo]) => ({ attachedTo }) %}
pureObject -> (cumulativeReferencingPrefix __):? (prefix __):* pureObjectInner (__ suffix):? {% ([reference, prefixes, object, suffix]) => {
  if (prefixes.length === 0 && !suffix && !reference) return object;
  const result = { object };
  if (reference) result.reference = reference[0];
  if (prefixes.length > 0) result.prefixes = prefixes.map(([p]) => p);
  if (suffix) result.suffix = suffix[1];
  return result;
} %}
pureObjectInner -> "copy"i (__ "of" __ object):? {% ([, copyOf]) => copyOf ? { copyOf } : "copy" %}
  | "copies"i {% () => "copies" %}
  | "card"i "s":? {% () => "card" %}
  | anyType "s":? {% ([type]) => ({ type }) %}
  | cumulativeReferencingPrefix __ pureObject {% ([reference, , object]) => ({ reference, object }) %}
  | pureObject __ "without"i __ keyword {% ([object, , , , without]) => ({ object, without }) %}
  | pureObject __ withClause {% ([object, , condition]) => ({ object, condition }) %}
  | CARD_NAME {% ([c]) => c %}
  | "ability" {% () => "ability" %}
  | "abilities" {% () => "abilities" %}
  | "commander" {% () => "commander" %}
  | "token" {% () => "token" %}
referencingObjectPrefix -> "the sacrificed"i {% () => "sacrificed" %}
  | "the exiled"i {% () => "exiled" %}
  | "any of"i {% () => "any" %}
  | "the"i {% () => "the" %}
  | "the rest of"i {% () => "rest" %}
  | commonReferencingPrefix {% ([p]) => p %}
  | countableCount {% ([count]) => ({ count }) %}
cumulativeReferencingPrefix -> "other"i {% () => "other" %}
  | "equipped"i {% () => "equipped" %}
commonReferencingPrefix -> countableCount (__ commonReferencingPrefixInner):? {% ([count, additional]) => additional ? { count, reference: additional[1] } : { count } %}
  | ("another"i __):? (countableCount __):? "target"i "s":?  {% ([another, count]) => {
    const targetCount = count ? count[0] : 1;
    return another ? { reference: "other", targetCount } : { targetCount }
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
  | "another"i {% () => "other" %}
  | "the chosen"i {% () => "chosen" %}
  | "at least"i __ englishNumber {% ([, , atLeast]) => ({ atLeast }) %}
  | "each other"i {% () => ({ each: { reference: "other" } }) %}
  | "your" {% () => "your" %}
prefix -> "enchanted"i {% () => "enchanted" %}
  | "attached"i {% () => "attached" %}
  | "equipped"i {% () => "equipped" %}
  | "historic"i {% () => "historic" %}
  | "non"i ("-" | __):? (anyType {% ([type]) => ({ type }) %} | color {% ([color]) => ({ color }) %}) {% ([, , not]) => ({ not }) %}
  | "exiled"i {% () => "exiled" %}
  | "the revealed"i {% () => "revealed" %}
  | "permanent" SAXON {% () => "permanent's" %}
  | anyType {% ([type]) => ({ type }) %}
  | "activated" {% () => ({ abilityType: "activated" }) %}
  | "triggered" {% () => ({ abilityType: "triggered" }) %}
  | "token"i {% () => "token" %}
  | "nontoken"i {% () => ({ not: "token" }) %}
  | "nonsnow"i {% () => ({ not: { type: "snow" } }) %}
  | color {% ([color]) => ({ color }) %}
  | "face-down" {% () => "faceDown" %}
  | "tapped"i {% () => "tapped" %}
  | "untapped"i {% () => ({ not: "tapped" }) %}
  | pt {% ([size]) => ({ size }) %}
  | "attacking"i {% () => "attacking" %}
  | "blocking"i {% () => "blocking" %}
  | connected[prefix] {% ([c]) => c %}

didAction -> "dealt damage" {% () => "dealtDamage" %}

imperative -> "sacrifice"i __ object {% ([, , sacrifice]) => ({ sacrifice }) %}
  | "fateseal"i __ number {% ([, , fateseal]) => ({ fateseal }) %}
  | "destroy"i "s":? __ object {% ([, , , destroy]) => ({ destroy }) %}
  | "detain"i __ object {% ([, , detain]) => ({ detain }) %}
  | "discard"i "s":? __ object {% ([, , , discard]) => ({ discard }) %}
  | "return"i "s":? __ object __ "to"i __ zone (__ "tapped"):? {% ([, , , returns, , , , to, tapped]) => tapped ? { returns, to, tapped: true } : { returns, to } %}
  | "exile"i "s":? __ object (__ "face down"):? (__ untilClause):? {% ([, , , exile, faceDown, until]) => {
    const result = { exile };
    if (faceDown) result.faceDown = true;
    if (until) result.until = until[1];
    return result;
  } %}
  | "create"i "s":? __ tokenDescription {% ([, , , create]) => ({ create }) %}
  | "copy"i __ object {% ([, , copy]) => ({ copy }) %}
  | "lose"i "s":? __ number __ "life"i {% ([, , , lifeLoss]) => ({ lifeLoss }) %}
  | "mill"i "s"i:? __ englishNumber __ "card"i "s":? {% ([, , , mills]) => ({ mills }) %}
  | gains __ number __ "life"i {% ([, , lifeGain]) => ({ lifeGain }) %}
  | gains __ "control of" __ object (__ untilClause):? {% ([, , , , gainsControlOf, until]) => until ? { gainsControlOf, until } : { gainsControlOf } %}
  | "remove"i __ countableCount __ (counterKind __):? "counter" "s":? __ "from"i __ object {% ([, , count, , counterKind, , , , , , removeCountersFrom]) => counterKind ? { count, removeCountersFrom, counterKind: counterKind[0] } : { count, removeCountersFrom } %}
  | ("cast"i | "play"i) "s"i:? __ object (__ "without paying"i __ IT__S __ "mana cost"i):? (__ duration):? (__ "only during" __ partOfTurn):? {% ([[cp], , , cast, withoutPaying, duration, onlyDuring]) => {
    const result = { [cp.toLowerCase()]: cast };
    if (withoutPaying) result.withoutPaying = true;
    if (duration) result.duration = duration[1];
    if (onlyDuring) result.onlyDuring = onlyDuring[3];
    return result;
  } %}
  | "surveil"i __ number {% ([, , surveil]) => ({ surveil }) %}
  | "search"i __ zone (__ "for"i __ object):? {% ([, , search, criteria]) => criteria ? { search, criteria: criteria[3] } : search %}
  | "choose"i __ object {% ([, , choose]) => ({ choose }) %}
  | "draw"i "s":? __ ("a"i __ "card"i {% () => 1 %} | "an additional card"i {% () => 1 %} | englishNumber __ "card"i "s" {% ([n]) => n %}) {% ([, , , draw]) => ({ draw }) %}
  | "draw"i "s":? __ "cards equal to" __ numberDefinition
  | "shuffle"i "s":? __ zone {% ([, , , shuffle]) => ({ shuffle }) %}
  | "shuffle"i "s":? __ (object | zone) __ "into" __ zone {% ([, , , shuffle, , , , into]) => ({ shuffle, into }) %}
  | "counter"i __ object {% ([, , counter]) => ({ counter }) %}
  | "tap"i __ object {% ([, , tap]) => ({ tap }) %}
  | "take"i __ "an extra turn after this one" {% () => "takeExtraTurn" %}
  | "untap"i __ object {% ([, , untap]) => ({ untap }) %}
  | "scry"i __ number {% ([, , scry]) => ({ scry }) %}
  | "pay"i "s":? __ manacost (__ "rather than pay the mana cost for" __ object):? {% ([, , , pay, rather]) => rather ? { pay, ratherThanCostOf: rather[3] } : { pay } %}
  | "pay"i "s":? __ numericalNumber __ "life" {% ([, , , life]) => ({ pay: { life } }) %}
  | "add one mana of any color"i {% () => ({ addOneOf: ["W", "U", "B", "R", "G"], amount: 1 }) %}
  | "add"i __ englishNumber __ "mana of any one color" {% ([, , amount]) => ({ addOneOf: ["W", "U", "B", "R", "G"], amount }) %}
  | "add"i __ englishNumber __ "mana in any combination of" __ (manaSymbol __ "and/or" __ manaSymbol {% ([c1, , , , c2]) => [c1, c2] %} | "colors" {% () => ["w", "u", "b", "r", "g"] %}) {% ([, , amount, , , , addCombinationOf]) => ({ addCombinationOf, amount }) %}
  | "add"i __ manaSymbols (",":? __ "or" __ manaSymbols):* {% ([, , m1, ms]) => ({ addOneOf: [m1, ...ms.map(([, , , , m2]) => m2)] }) %}
  | "prevent"i __ damagePreventionAmount __ damageNoun __ (object __ "would deal" {% ([from]) => ({ from }) %} | "that would be dealt" (__ "to" __ anyEntity):? {% ([, to]) => to ? { to: to[3] } : { to: "any" } %}) (__ duration):?{% ([, , amount, , prevent, , to, duration]) => {
    const result = to ? { amount, prevent, ...to } : { amount, prevent };
    if (duration) result.duration = duration[1];
    return result;
  } %}
  | "put"i __ englishNumber __ counterKind __ "counter"i "s":? __ "on" __ object {% ([, , amount, , type, , , , , , , putCountersOn]) => ({ amount, type, putCountersOn }) %}
  | "choose"i __ object {% ([, , choose]) => ({ choose }) %}
  | "look at the top" __ englishNumber __ "cards of" __ zone {% ([, , lookAtTop, , , , from]) => ({ lookAtTop, from }) %}
  | "look at"i __ object {% ([, , lookAt]) => ({ lookAt }) %}
  | "reveal"i "s":? __ (object | zone) {% ([, , , [reveal]]) => ({ reveal }) %}
  | "put"i __ object __ intoZone (__ "tapped"):? (__ "and" __ object __ intoZone):? (__ "under" __ playersPossessive __ "control"):? {% ([, , put, , into, tapped, additional, control]) => {
    let result = { put, into };
    if (tapped) result.tapped = true;
    if (control) result.control = control[3];
    if (additional) result = { and: [result, { put: additonal[3], into: additional[5] }] };
    return result;
  } %}
  | gains __ "control of" __ object {% ([, , , , gainControlOf]) => ({ gainControlOf }) %}
  | "may" __ sentence (". if you do," __ sentence):? {% ([, , may, ifDo]) => ifDo ? { may, ifDo: ifDo[2] } : { may } %}
  | "have" __ object __ objectInfinitive {% ([, , have, , property]) => ({ have, property }) %}
  | "have your life total become" __ numberDefinition {% ([, , lifeTotalBecomes]) => ({ lifeTotalBecomes }) %}
  | imperative __ "for each"i __ pureObject {% ([does, , , , forEach]) => ({ does, forEach }) %}
  | imperative __ "unless" __ sentence {% ([does, , , , unless]) => ({ does, unless }) %}
  | "choose new targets for" __ object {% ([, , newTargets]) => ({ choose: { newTargets } }) %}
  | "switch the power and toughness of" __ object __ untilClause {% ([, , switchPowerToughness, , until]) => ({ switchPowerToughness, until }) %}
  | "do the same for" __ object {% ([, , doSameFor]) => ({ doSameFor }) %}
  | "spend mana as though it were mana of any type to cast" __ object {% ([, , spendManaAsAnyTypeFor]) => ({ spendManaAsAnyTypeFor }) %}
  | "transform" __ object {% ([, , transform]) => ({ transform }) %}
  | "flip a coin" {% () => "flipCoin" %}
  | "win the flip" {% () => "winFlip" %}
  | "lose the flip" {% () => "loseFlip" %}
  | "regenerate"i __ object {% ([, , regenerate]) => ({ regenerate }) %}
  | "bolster"i __ englishNumber {% ([, , bolster]) => ({ bolster }) %}
  | "populate"i {% () => "populate" %}
  | imperative __ untilClause {% ([does, , until]) => ({ does, until }) %}
  | "support"i __ number {% ([, , support]) => ({ support }) %}
  | "attach"i __ object __ "to" __ object {% ([, , attach, , , , to]) => ({ attach, to }) %}
  | "end the turn"i {% () => "endTurn" %}

playerVerbPhrase -> gains __ number __ "life" {% ([, , lifeGain]) => ({ lifeGain }) %}
  | gains __ "life equal to" __ itsPossessive __ numericalCharacteristic {% ([, , , , whose, , value]) => ({ lifeGain: { whose, value } }) %}
  | playerVerbPhrase __ "for each"i __ pureObject {% ([does, , , , forEach]) => ({ does, forEach }) %}
  | playerVerbPhrase __ "for the first time each turn" {% ([does]) => ({ does, reference: "firstTime", duration: { reference: "each", what: "turn" } }) %}
  | controls __ ("no" __):? object {% ([, , negation, controls]) => negation ? { not: { controls } } : { controls } %}
  | owns __ object {% ([, , owns]) => ({ owns }) %}
  | (DON__T | DOESN__T) "lose this mana as steps and phases end." {% () => "doesntEmpty" %}
  | "puts" __ object __ intoZone {% ([, , what, , enters]) => ({ what, enters }) %}
  | "surveil"i "s":? {% () => "surveil" %}
  | "life total becomes" __ englishNumber {% ([, , lifeTotalBecomes]) => ({ lifeTotalBecomes }) %}
  | "attacked" __ duration {% ([, , duration]) => ({ does: "attack", duration }) %}
  | imperative {% ([i]) => i %}
  | playerVerbPhrase ("," | ".") __ "then"i __ playerVerbPhrase {% ([p1, , , , , p2]) => ({ and: [p1, p2] }) %}
  | CAN__T __ imperative {% ([, , cant]) => ({ cant }) %}
  | (DOESN__T | DON__T) {% () => { not: "do" } %}
  | ("does" | "do") {% () => "do" %}
  | "lose" "s":? __ "the game" {% () => "lose" %}
  | playerVerbPhrase __ "if"i __ sentence {% ([does, , , , condition]) => ({ does, condition }) %}
  | playerVerbPhrase __ "this way" {% ([does]) => ({ does, reference: "thisWay" }) %}
  | gets __ "an emblem" __ withClause {% ([, , , , emblem]) => ({ emblem }) %}
  | "each" __ playerVerbPhrase {% ([, , each]) => ({ each }) %}
  | "cycle" __ object {% ([, , cycle]) => ({ cycle }) %}
objectVerbPhrase -> connected[objectVerbPhrase] {% ([c]) => c %}
  | ("was" | "is") __ object {% ([, , is]) => ({ is }) %}
  | ("has" | "have") __ acquiredAbility (__ asLongAsClause):? {% ([, , haveAbility, asLongAs]) => asLongAs ? { haveAbility, asLongAs: asLongAs[1] } : { haveAbility } %}
  | gains __ acquiredAbility (__ "and" __ gets __ ptModification):? {% ([, , gains, gets]) => gets ? { gains, ...gets[5] } : { gains } %}
  | gets __ ptModification (__ forEachClause):? (__ "and" __ gains __ acquiredAbility):? (__ untilClause):? (__ asLongAsClause):? {% ([, , powerToughnessMod, forEach, gains, until, asLongAs]) => {
    const result = { powerToughnessMod };
    if (forEach) result.forEach = forEach[1];
    if (gains) result.gains = gains[5];
    if (until) result.until = until[1];
    if (asLongAs) result.asLongAs = asLongAs[1];
    return result;
  } %}
  | "enters the battlefield with" __ (englishNumber {% ([n]) => n %} | "an additional" {% () => ({ additional: 1 }) %}) __ counterKind __ "counter" "s":? __ "on it"i (__ forEachClause):? {% ([, , amount, , counterKind, , , , , , forEach]) => ({ entersWith: forEach ? { amount, counterKind, forEach: forEach[1] } : { amount, counterKind } }) %}
  | "enters the battlefield with a number of"i (__ "additional"):? __ counterKind __ "counters on it equal to"i __ numberDefinition {% ([, additional, , counterKind, , , , amount]) => ({ entersWith: additional ? { counterKind, amount, additional: true } : { counterKind, amount } }) %}
  | ("enter" | "enters") __ "the battlefield"i (__ "tapped"):? (__ "under" __ playersPossessive __ "control"):? {% ([, , , tapped, control]) => {
    const result = { enter: "theBattlefield" }
    if (tapped) result.tapped = true;
    if (control) result.control = control[3];
    return result;
  } %}
  | "leave" "s":? __ "the battlefield"i {% () => ({ leaves: "theBattlefield" }) %}
  | "die" "s":? {% () => "die" %}
  | "is put"i __ intoZone __ fromZone {% ([, , enters, , from]) => ({ enters, from }) %}
  | CAN__T __ cantClause {% ([, , cant]) => ({ cant }) %}
  | "deals" __ dealsWhat {% ([, , deals]) => ({ deals }) %}
  | ("is" | "are") __ isWhat {% ([, , is]) => ({ is }) %}
  | "attack"i "s":? (__ ("this"i | "each"i) __ "combat if able"):? (__ "and" __ ISN__T __ "blocked"):? {% ([, reference, isntBlocked]) => {
      const result = reference ? { mustAttack: reference[1][0] } : "attacks";
      return isntBlocked ? { and: [result, { not: "blocked" }] } : result;
    } %}
  | "block"i "s":? (__ "this" __ "combat if able"):?
  | gains __ acquiredAbility {% ([, , gains]) => ({ gains }) %}
  | DOESN__T __ "untap during" __ qualifiedPartOfTurn {% ([, , , , untap]) => ({ not: { untap } }) %}
  | "blocks" (__ "or becomes blocked by"):? __ object {% ([, becomesBlocked, , blocks]) => becomesBlocked ? { or: [{ blocks }, { blockedBy: blocks}] } : { blocks } %}
  | "is countered this way" {% () => ({ reference: "thisWay", does: "countered" }) %}
  | "fights" __ object {% ([, , fights]) => ({ fights }) %}
  | "targets" __ object {% ([, , targets]) => ({ targets }) %}
  | "loses" __ keyword {% ([, , loses]) => ({ loses }) %}
  | "cost" "s":? __ manacost __ "less" __ "to" __ "cast"i {% ([, , , mana]) => ({ costReduction: { mana } }) %}
  | "can attack as though it didn\"t have defender" {% () => ({ ignores: "defender" }) %}
  | "can block an additional" __ object __ "each combat" {% ([, , blockAdditional]) => ({ blockAdditional }) %}
  | ("do" | "does") __ "so" {% () => "do" %}
  | "remain" "s":? __ "exiled" {% () => ({ remain: "exile" }) %}
  | "becomes" __ becomesWhat {% ([, , becomes]) => ({ becomes }) %}
  | "lose" "s":? __ "all abilities" (__ untilClause):? {% ([, , , , until]) => until ? { loses: "allAbilities", until } : { loses: "allAbilities" } %}
  | ("is" | "are") __ "created" {% () => "created" %}
  | "causes" __ player __ "to discard" __ object {% ([, , who, , , , discard]) => ({ causes: { who, discard } }) %}
  | objectVerbPhrase __ forEachClause {% ([does, , forEach]) => ({ does, forEach }) %}
  | objectVerbPhrase __ duration {% ([does, , duration]) => ({ does, duration }) %}
  | objectVerbPhrase __ "if"i __ sentence {% ([does, , , , condition]) => ({ does, condition }) %}
  | "was kicked" {% () => "kicked" %}
  | "was milled this way" {% () => ({ reference: "thisWay", does: "milled" }) %}
  | CAN__T __ "be countered" {% () => ({ cant: "countered" }) %}
  | ("the" __):? "damage" __ CAN__T __ "be prevented" {% () => ({ cantPrevent: "damage" }) %}
  | CAN__T __ "attack" __ duration {% ([, , , , cantAttack]) => ({ cantAttack }) %}
  | CAN__T __ "be blocked" (__ "by" __ object):? (__ duration):? {% ([, , , by, duration]) => {
    const result = { cant: { blockedBy: by ? by[3] : "any" } };
    if (duration) result.duration = duration[1];
    return result;
  } %}
  | "cost" __ cost __ "more to" __ ("cast" | "activate") {% ([, , costIncrease, , , , [action]]) => ({ costIncrease, action }) %}
  | "as" __ object (__ "in addition to its other types"):? {% ([, , as, inAddition]) => inAddition ? { as, inAddition: true } : { as } %}
objectInfinitive -> "be put"i __ intoZone __ duration {% ([, , enter, , duration]) => ({ enter, duration }) %}
  | "be created under your control"i {% () => ({ reference: { who: "you", does: "control" }, does: "create" }) %}
  | "fight" __ object {% ([, , fight]) => ({ fight }) %}
  | "deal" __ dealsWhat {% ([, , deal]) => ({ deal }) %}

isWhat -> color {% ([color]) => ({ color }) %}
  | object (__ "in addition to its other types"i):? {% ([object, addition]) => addition ? { object, inAddition: true } : { object } %}
  | inZone {% ([inZone]) => ({ inZone }) %}
  | "still" __ object {% ([, , still]) => ({ still }) %}
  | "turned face up" {% () => "turnedFaceUp" %}
  | "attacking"i {% () => "attacking" %}
  | "blocking"i {% () => "blocking" %}
  | "attacking" __ "or" __ "blocking" {% () => ({ or: ["attacking", "blocking"] }) %}
  | condition {% ([condition]) => ({ condition }) %}
  | "enchanted" {% () => "enchanted" %}
becomesWhat -> "tapped" {% () => "tap" %}
  | "untapped" {% () => ({ not: "tap" }) %}
  | "a copy of" __ object ("," __ exceptClauseInCopyEffect):? {% ([, , copyOf, except]) => except ? { copyOf, except: except[2] } : { copyOf } %}
  | "a" "n":? (__ pt):? __ anyType (__ "with base power and toughness" __ pt):? (__ "with" __ acquiredAbility):? (__ "in addition to its other types"):? {% ([, , size, , type, size2, withClause, inAddition]) => {
    const result = { type };
    if (size) result.size = size[1];
    else if (size2) result.size = size2[3];
    if (withClause) result.with = withClause[3];
    if (inAddition) result.inAddition = true;
    return result;
  } %}
  | "the basic land type" "s":? __ "of your choice" __ untilClause {% ([, , , , , until]) => ({ choose: "basicLandType", until }) %}
  | "blocked" (__ "by" __ object) {% ([, by]) => by ? { blockedBy: by[3] } : { blockedBy: "any" } %}
  | "colorless" {% () => ({ color: [] }) %}
exceptClauseInCopyEffect -> "except"i __ copyException ("," __ ("and" __ ):? copyException):* {% ([, , e1, es]) => es.length > 0 ? { and: [e1, ...es.map(([, , , e2]) => e2)] } : e1 %}
copyException -> "its name is" __ CARD_NAME {% ([, , name]) => ({ name }) %}
  | IT__S __ isWhat {% ([, , is]) => ({ is }) %}
  | singleSentence {% ([s]) => s %}

itsPossessive -> object SAXON {% ([o]) => o %}
  | "its"i {% () => ({ reference: "its" }) %}
  | "their"i {% () => ({ reference: "their" }) %}
  | "your"i {% () => ({ reference: "your" }) %}

acquiredAbility -> keyword {% ([k]) => k %}
  | "\"" ability "\"" {% ([, a]) => a %}
  | "“" ability "”" {% ([, a]) => a %}
  | acquiredAbility __ "and" __ acquiredAbility {% ([a1, , , , a2]) => ({ and: [a1, a2] }) %}
  | "this ability" {% () => "thisAbility" %}

gets -> "get" "s":?
controls -> "control" "s":?
owns -> "own" "s":?
gains -> "gain"i "s":?

duration -> "this turn" {% () => ({ reference: "this", what: "turn" }) %}
  | "last turn" {% () => ({ reference: "last", what: "turn" }) %}
  | ("for"i __):? asLongAsClause {% ([, asLongAs]) => ({ asLongAs }) %}
  | untilClause {% ([until]) => ({ until }) %}
untilClause -> "until"i __ untilClauseInner {% ([, , u]) => u %}
untilClauseInner -> sentence {% ([s]) => s %}
  | "end of turn"i {% () => "endOfTurn" %}
  | "your next turn"i {% () => "yourNextTurn" %}

numericalCharacteristic -> "toughness" {% () => "toughness" %}
  | "power" {% () => "power" %}
  | "converted mana cost" {% () => "cmc" %}
  | "life total" {% () => "lifeTotal" %}
  | "power and toughness" {% () => ({ and: ["power", "toughness"] }) %}

damagePreventionAmount -> "all"i {% () => "all" %}
  | "the next" __ englishNumber {% ([, , next]) => next %}
damageNoun -> ("non":? "combat" __):? "damage" {% ([combat]) => ({ damage: combat ? (combat[0] ? { not: "combat" } : "combat") : "any" }) %}

tokenDescription -> englishNumber (__ pt):? (__ color):? __ permanentType __ "token" "s":? (__ withClause):? (__ "named" __ [^.]:+):? {% ([amount, size, color, , tokenType, , , withClause, name]) => {
  const result = { amount, tokenType };
  if (size) result.size = size[1];
  if (color) result.color = color[1];
  if (withClause) result.with = withClause[1];
  if (name) result.name = name[3].join('');
  return result;
} %}
  | englishNumber __ "token" "s":? __ "that" SAXON __ "a copy of" __ object {% ([amount , , , , , , , , , copy]) => ({ amount, copy }) %}

color -> "white"i {% () => "w" %}
  | "blue"i {% () => "u" %}
  | "black"i {% () => "b" %}
  | "red"i {% () => "r" %}
  | "green"i {% () => "g" %}
  | "colorless"i {% () => "colorless" %}
  | "monocolored"i {% () => "mono" %}
  | "multicolored"i {% () => "multi" %}
  | connected[color] {% ([c]) => c %}

pt -> number "/" number {% ([power, , toughness]) => ({ power, toughness }) %}
ptModification -> PLUSMINUS number "/" PLUSMINUS number {% ([pmP, power, , pmT, toughness]) => ({ powerMod: '+' === pmP.toString() ? power : -power, toughnessMod: '+' === pmT.toString() ? toughness : -toughness }) %}
numberDefinition -> itsPossessive __ numericalCharacteristic {% ([whose, , characteristic]) => ({ whose, characteristic }) %}
  | "the"i __ ("total"i __):? "number of" __ object {% ([, , , , , count]) => ({ count }) %}
integerValue -> [0-9]:+ {% ([digits]) => parseInt(digits.join(''), 10) %}

withClause -> "with"i __ withClauseInner {% ([, , withInner]) => ({ with: withInner }) %}
withClauseInner -> numericalCharacteristic __ numericalComparison {% ([value, , comparison]) => ({ value, comparison }) %}
  | "the highest" __ numericalCharacteristic __ "among"i __ object {% ([, , hightest, , , , among]) => ({ highest, amont }) %}
  | "converted mana costs" __ numericalNumber __ "and" __ numericalNumber {% ([, , cmc, and]) => and ? { and: [{ cmc }, { cmc: and[3] }] } : { cmc } %}
  | counterKind __ "counter" "s":? __ "on"i __ ("it"i | "them"i) {% ([counterKind]) => ({ counterKind }) %}
  | "that name"i {% () => ({ reference: "that", what: "name" }) %}
  | "the same name as" __ object {% ([, , sameNameAs]) => ({ sameNameAs }) %}
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
  | "fetch"
  | "charge"
  | "storage") {% ([[counter]]) => counter %}

dealsWhat -> damageNoun __ "to" __ damageRecipient {% ([damage, , , , to]) => ({ ...damage, to }) %}
 | numericalNumber __ "damage to" __ damageRecipient {% ([amount, , , , damageTo]) => ({ amount, damageTo }) %}
 | "damage equal to" __ numberDefinition __ "to" __ damageRecipient {% ([, , amount, , , , damageTo]) => ({ amount, damageTo }) %}
 | "damage to" __ damageRecipient __ "equal to" __ numberDefinition {% ([, , damageTo, , , , amount]) => ({ amount, damageTo }) %}
 | numericalNumber __ "damage" __ divideAmongDamageTargets {% ([amount, , , , divideAmong]) => ({ amount, divideAmong }) %}

damageRecipient -> object {% ([o]) => o %}
  | player {% ([p]) => p %}
  | "any target"i {% () => "anyTarget" %}
  | ("target" __):? connected[damageRecipient] {% ([target, rs]) => target ? { target: rs } : rs %}
  | "itself"i {% () => "self" %}
divideAmongDamageTargets -> "divided as you choose among" __ divideTargets {% ([, , divideTargets]) => divideTargets %}
divideTargets -> "one, two, or three targets"i {% () => ({ targetCount: [1, 2, 3] }) %}
  | "any number of targets"i {% () => ({ targetCount: "any" }) %}
  | "one or two targets"i {% () => ({ targetCount: [1, 2] }) %}

englishNumber -> "a"i {% () => 1 %}
  | "an"i {% () => 1 %}
  | "a single"i {% () => 1 %}
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
numericalComparison -> number __ "or greater"i {% ([gte]) => ({ gte }) %}
  | number __ "or less"i {% ([lte]) => ({ lte }) %}
  | "less than or equal to" __ numberDefinition {% ([, , lte]) => ({ lte }) %}
  | "greater than" __ numberDefinition {% ([, , gt]) => ({ gt }) %}
  | number {% ([n]) => n %}
countableCount -> "exactly"i __ englishNumber {% ([, , eq]) => ({ eq }) %}
  | englishNumber __ "or more"i {% ([atLeast]) => ({ atLeast }) %}
  | "fewer than" __ englishNumber {% ([, , lessThan]) => ({ lessThan }) %}
  | "any number of" {% () => "anyNumber" %}
  | "one of" {% () => 1 %}
  | "up to" __ englishNumber {% ([, , upTo]) => ({ upTo }) %}
  | englishNumber {% ([n]) => n %}
  | "all"i {% () => "all" %}
  | "both"i {% () => "both" %}

cantClause -> cantClauseInner (__ "unless" __ condition):? {% ([cant, unless]) => unless ? { cant, unless: unless[3] } : cant %}
cantClauseInner -> "attack" {% () => "attack" %}
  | "block" {% () => "block" %}
  | "attack or block" {% () => ({ or: ["attack", "block"] }) %}
  | "attack or block alone" {% () => ({ or: [{ does: "attack", suffix: "alone" }, { does: "block", suffix: "alone" }] }) %}
  | "attack alone" {% () => ({ does: "attack", suffix: "alone" }) %}
  | "block alone" {% () => ({ does: "block", suffix: "alone" }) %}
  | "be blocked" {% () => "blocked" %}
  | "be countered" {% () => "countered" %}
  | "be blocked by more than" __ englishNumber __ "creature"i "s":? {% ([, , gt]) => ({ blockedBy: { gt } }) %}

zone -> (playersPossessive | "a"i (__ "single"):?) __ ownedZone {% ([[owner], , zone]) => ({ owner, zone }) %}
  | "exile"i {% () => "exile" %}
  | "the battlefield"i {% () => "theBattlefield" %}
  | "it"i {% () => "it" %}
ownedZone -> "graveyard" {% () => "graveyard" %}
  | "library" {% () => "library" %}
  | "libraries" {% () => "library" %}
  | "hand" {% () => "hand" %}
  | ownedZone "s" {% ([z]) => z %}
  | connected[ownedZone] {% ([c]) => c %}
intoZone -> "onto the battlefield"i {% () => "theBattlefield" %}
  | "into" __ zone {% ([, , into]) => into %}
  | "on top of" __ zone {% ([, , onTopOf]) => ({ onTopOf }) %}
  | "on the bottom of" __ zone (__ "in" __  ("any" {% () => "any" %} | "a random" {% () => "random" %}) __ "order"):? {% ([, , bottom, order]) => order ? { bottom, order: order[3] } : { bottom } %}
inZone -> "on the battlefield" {% () => ({ in: "theBattlefield" }) %}
  | "in" __ zone {% ([, , inZone]) => ({ in: inZone }) %}
fromZone -> "from" __ zone {% ([, , z]) => z %}

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
  | permanentType __ permanentType {% ([t1, , t2]) => ({ and: [t1, t2] }) %}
  | connected[permanentType] {% ([c]) => c %}
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
  | connected[spellType] {% ([c]) => c %}
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

asLongAsClause -> "as long as"i __ condition {% ([, , c]) => c %}

replacementEffect -> sentence __ "instead of putting it" __ intoZone {% ([instead, , , , enters]) => ({ enters, instead }) %}

costs -> connected[cost] {% ([c]) => c %}
  | cost ("," __ cost):* {% ([c, cs]) => ({ and: [c, ...cs.map(([, , c2]) => c2)] }) %}
cost -> "{T}" {% () => "tap" %}
  | sentence {% ([s]) => s %}
  | manacost {% ([mana]) => ({ mana }) %}
  | loyaltyCost {% ([loyalty]) => ({ loyalty }) %}
loyaltyCost -> PLUSMINUS integerValue {% ([pm, int]) => pm === "+" ? int : -int %}
manacost -> manaSymbol:+ {% ([mg]) => mg %}
  | object SAXON __ "mana cost" {% ([costOf]) => ({ costOf }) %}
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

qualifiedPartOfTurn -> turnQualification __ partOfTurn {% ([qualification, , partOfTurn]) => ({ qualification, partOfTurn }) %}
  | "combat on your turn"i {% () => ({ qualification: "yourTurn", partOfTurn: "combat" }) %}
  | "combat"i {% () => ({ partOfTurn: "combat" }) %}
  | "end of combat"i {% () => ({ partOfTurn: "endCombat" }) %}
turnQualification -> (playersPossessive | "the"i) (__ "next"):? {% ([[whose]]) => ({ next: { whose } }) %}
  | "this"i {% () => "this" %}
  | "each"i {% () => "each" %}
  | "this turn"i SAXON {% () => ({ reference: "this", what: "turn" }) %}
  | "that turn"i SAXON {% () => ({ refernce: "that", what: "turn" }) %}
  | "the next turn"i SAXON {% () => ({ reference: "next", what: "turn" }) %}
  | "the beginning of" __ turnQualification {% ([, , beginningOf]) => ({ beginningOf }) %}
partOfTurn -> "turn" {% () => "turn" %}
  | "untap step"i {% () => "untap" %}
  | "upkeep"i {% () => "upkeep" %}
  | "draw step"i {% () => "drawStep" %}
  | "precombat main phase"i {% () => "precombatMain" %}
  | "main phase"i {% () => "main" %}
  | "combat"i {% () => "combat" %}
  | "declare attackers"i {% () => "declareAttackers" %}
  | "declare blockers"i {% () => "declareBlockers" %}
  | "combat damage step"i {% () => "combatDamage" %}
  | "postcombat main phase"i {% () => "postcombatMain" %}
  | "end step"i {% () => "end" %}

playersPossessive -> "your" {% () => "your" %}
  | "their" {% () => "their" %}
  | player (SAXON | AP) {% ([player]) => player %}

AP -> "'" | "’"
CARD_NAME -> ("~" 
  | "Prossh") {% () => "CARD_NAME" %}
CAN__T -> "can't"i | "can’t"i
DON__T -> "don't"i | "don’t"i
DOESN__T -> "doesn't"i | "doesn’t"i
DASHDASH -> "--" | "—"
ISN__T -> "isn't"i | "isn’t"i
IT__S -> "it's"i | "it’s"i
PLUSMINUS -> "+" | "-" | "−"
SAXON -> AP "s"
THAT__S -> "that's"i | "that’s"i
YOU__VE -> "you've" | "you’ve"i
