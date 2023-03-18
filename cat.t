#define catBaseVocab ('cat;;kat kitty meowmeow')

#if __IS_MAP_TEST
#define catRealName 'Piergiorgio'
#define catNickname catRealName
#define catNicknameVocab ('pg pigi peegee pier giorg giorge giorgio piergiorgio')
#else
#define catRealName 'Arthur'
#define catNickname 'King Arthur'
#define catNicknameVocab ('king arthur')
#endif

VerbRule(SayMeow)
    'meow'
    : VerbProduction
    action = SayMeow
    verbPhrase = 'meow/meowing'
;

DefineIAction(SayMeow)
;

VerbRule(Sing)
    'sing'
    : VerbProduction
    action = Sing
    verbPhrase = 'sing/singing'
;

DefineIAction(Sing)
;

VerbRule(Purr)
    'purr'
    : VerbProduction
    action = Purr
    verbPhrase = 'purr/purring'
;

DefineIAction(Purr)
;

#define meowPrompt "<i><<one of>>Meow<<or>>Mraow<<or>>Maow<<at random>>.</i> "

cat: Actor { '<<catBaseVocab>> <<catNicknameVocab>> me self myself fur coat paws'
    "You are a beautiful, regal, and <i>graceful</i> cat!
    And a <i>grand</i> ruler, too!\b
    Your black coat is speckled  with streaks of silvery tips.
    White highlights your chest and paws, like a tuxedo. "
    person = (gCatMode ? 2 : 3)
    isHim = true

    location = dreamWorldCat

    actualName = catRealName
    nickname = catNickname
    globalParamName = 'the cat'

    bulk = 1
    bulkCapacity = 1
    maxSingleBulk = 1

    seeReflection(mirror) {
        mirror.confirmSmashed();
        if (mirror.isSmashed) {
            return 'It\'s difficult to see yourself in the broken mirror,
                but the reflection patterns show black fluff,
                with streaks of silver. ';
        }
        desc();
        return '';
    }

    actorAction() {
        if (gActionIs(Yell) || gActionIs(SayMeow) || gActionIs(Sing)) {
            meowPrompt;
            exit;
        }
        if (gActionIs(Purr)) {
            "You vocalize a soft, purring sound. ";
            exit;
        }
    }
}

+catNameTag: Fixture { 'nametag;name;tag collar pendant plate badge card'
    "<<if gCatMode>>A tiny bit of shiny metal, dangling from your collar.
    It used to make an infuriating jingling sound, but ever since the lone
    citizen became your only neighbor, he had wrapped some yarn around it,
    allowing you to move more silently. You're not sure why he never just
    <i>removed the fucking collar entirely</i>, but it's only a minor infraction.
    His services to you outweigh this...<i>mostly</i>.
    <<else>>It a little round name tag for the cat. Someone seems to have
    wrapped some yarn around it, though it's not clear <i>why</i>. Maybe it's
    to make this cat more silent? Wouldn't this warrant removing the collar
    <i>entirely</i>, though...?<<end>>"

    readDesc = "<<if gCatMode>>You struggle to read the strange scrawlings
    of your hairless subjects, but you know these shapes mean something to
    them. You've lived long enough to know that the weird etchings in your
    tag are pronounced <q><<gCatName>></q>, which also seems to be the sound
    these creatures make when they desire audience with you.
    <<else>>The etched name on the small metal tag is written in cursive,
    which is a little difficult to read, still. However, it seems to
    indicate the cat's name is <q><<gCatName>></q>.<<end>>"
}
