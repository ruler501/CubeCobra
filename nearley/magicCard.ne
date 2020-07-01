@builtin "whitespace.ne"
# Base on https://github.com/Soothsilver/mtg-grammar/blob/master/mtg.g4

card -> "\n":* ability ("\n":+ ability):*
ability -> abilityWordAbility
  | activatedAbility
  | additionalCostToCastSpell
  | keywords
  | modalAbility
  | staticOrSpell
  | triggeredAbility
  | continuousEffect

reminderText -> "(" [^)]:+ ")"

modalAbility -> "choose"i _ modalQuantifier _ DASHDASH modalOption ("\n" modalOption):*
modalOption -> ("*" | "•") _ effect
modalQuantifier -> "one or both"i | "one"

keywords: keyword (("," | ";") _ keyword):* {% ([k1, ks]) -> [k1].concat(ks.map(([, , k]) => k)) %}
# Keep this in the same order as 702 to make verification easy.
keyword -> "deathtouch"i
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
enchantKeyword -> "enchant"i _ anyEntity
equipKeyword -> "equip"i _ cost

abilityWordAbility -> abilityWord _ DASHDASH _ ability
abilityWord ->  "adamant"i | "addendum"i | "battalion"i | "bloodrush"i | "channel"i | "chroma"i | "cohort"i | "constellation"i |"converge"i | "council\'s dilemma"i | "delirium"i | "domain"i | "eminence"i | "enrage"i | "fateful hour"i | "ferocious"i | "formidable"i | "grandeur"i | "hellbent"i | "heroic"i | "imprint"i | "inspired"i | "join forces"i | "kinship"i | "landfall"i | "lieutenant"i | "metalcraft"i | "morbid"i | "parley"i | "radiance"i | "raid"i | "rally"i | "revolt"i | "spell mastery"i | "strive"i | "sweep"i | "temptingoffer"i | "threshold"i | "undergrowth"i | "will of the council"i

activatedAbility -> costs ":" _ effect (_ activationInstructions):?
activationInstructions -> "activate this ability only "i activationInstruction "."
  | "any player may activate this ability."i
activationInstruction -> "once each turn"i
  | "any time you could cast a sorcery"i
activatedAbilities -> (itsPossessive _):? "activated abilities"i
activatedAbilitiesVP -> "can't be activated"i

triggeredAbilty -> triggerCondition "," _ interveningIfClause:? effect
triggerCondition -> ("when"i | "whenever"i) _ triggerConditonInner
  | "at the beginning of"i _ qualifiedPartOfTrun
  | "at end of combat"i
triggerConditionInner -> singleSentence
  | "you cast "i object
  | player _ gains _ "life"i
  | object " is dealth damage"i
interveningIfClause -> "if "i condition ","

additionalCostToCastSpell -> "as an additonal cost to cast this spell," _ imperative "."

staticOrSpell -> sentenceDot
effect -> sentenceDot
  | modal

sentenceDot -> s "." (_ additionalSentences):?
additionalSentences -> additionalSentence (_ additionalSentence):*
additionalSentence -> sentence "." | triggeredAbilty

sentence -> singleSentence
  | "Then" _ sentence
  | sentence _ "and" _ sentence
  | singleSentence ("," (("then"i | "and"i):? _):? sentence):+
  | "otherwise,"i _ sentence

singleSentence -> imperative
  | singleSentence _ "and"i _ singleSentence
  | singleSentence ", where X is"i _ numberDefinition
  | object _ objectVerbPhrase
  | IT_S _ isWhat
  | player _ playerVerbPhrase
  | "if"i _ sentence "," _ replacementEffect
  | "if"i _ condition "," _ sentence
  | "if"i _ object _ "would"i (objectVerbPhrase | objetInfinitive) "," _ sentenceInstead
  | "if"i _ player _ "would"i _ playerVerbPhrase "," _ sentenceInstead
  | asLongAsClause ","  sentence
  | duration "," _ sentence
  | "for each"i _ object "," _ sentence
  | activatedAbilities _ activatedAbilitiesVP
  | itsPossessive _ numericalCharacteristic _ "is equal to"i _ numberDefinition
  | "as"i sentence "," _ sentence
sentenceInstead -> sentence _ "instead"i
  | "instead"i _ sentence

forEachClause -> "for each" _ pureObject
 | "for each color of mana spent to cast"i _ object

condition -> sentence
  | YOU_VE _ action _ duration
  | IT_S _ "your turn"i
  | object _ "has"i countableCount _ (counterKind _):? "counters on it"i
  | numberDefinition _ "is" _ numericalComparison
  | "that mana is spent on" _ object

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
  | itsPossessive ("controller"i | "owner"i | "owners"i | "controllers"i)
  | player _ "who" _ CAN_T
purPlayer -> "opponent"i
  | "player"i
  | "players"i
  | "opponents"i
object -> CARD_NAME
  | "it"i
  | "them"i
  | "they"i
  | "one"i
  | "the rest"i
  | "the other"i
  | "this emblem"i
  | referencingObjectPrefix _ pureObject
  | referencingObjectPrefix _ object
  | object _ THAT_S _ isWhat
  | object ("," _ object):* _ ("and"i | "or"i | "and/or"i) _ object
  | cumulativeReferencingPrefix pureObject
  | pureObject _ suffix
  | pureObject
  | "each of"i _ object
  | "the top"i _ englishNumber _ "cards of"i _ zone
  | "the top card of"i _ zone
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
  | "named"i _ name
  | YOU_VE _ "cast before it this turn"i
pureObject -> prefix:+ _ pureObject
  | "copy"i (_ "of" _ object)?
  | "copies"i
  | cumulativeReferencingPrefix _ pureObject
  | pureObject ("," _ purObject):* _ ("and"i | "or"i | "and/or"i) _ pureObject
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
  | ("another"i _):? (countableCount _):? "target"i
prefix -> "enchanted"i
  | "non"i ("-" | _) anyType
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
  | "destroy"i _ object
  | "discard"i _ object
  | "return"i _ object (_ fromZone):? _ "to"i _ zone
  | "exile"i _ object (_ "face down"):? (_ untilClause):?
  # 271

CARD_NAME -> "~"
CAN_T -> "can't"i | "can’t"i
DON_T -> "don't"i | "don’t"i
DOESN_T -> "doesn't"i | "doesn’t"i
DASHDASH -> "--" | "—"
IT_S -> "it's"i | "it’s"i
THAT_S -> "that's"i | "that’s"i
YOU_VE -> "you've" | "you’ve"i
