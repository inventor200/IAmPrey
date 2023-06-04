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

cat: PlayerActor { '<<catBaseVocab>> <<catNicknameVocab>> me you self myself yourself fur coat'
    "{I} {am} a beautiful, regal, and <i>graceful</i> cat!
    And a <i>grand</i> ruler, too!\b
    {My} black coat is speckled  with streaks of silvery tips.
    White highlights {my} chest and paws, like a tuxedo. "
    person = (gCatMode ? gDefaultPOV : 3)
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
            return 'It\'s difficult to see {myself} in the broken mirror,
                but the reflection patterns show black fluff,
                with streaks of silver. ';
        }
        desc();
        return '';
    }

    actorAction() {
        inherited();
        if (gActionIs(Yell) || gActionIs(SayMeow) || gActionIs(Sing)) {
            meowPrompt;
            exit;
        }
        if (gActionIs(Purr)) {
            "{I} vocalize a soft, purring sound. ";
            exit;
        }
        if (gActionIs(Sleep)) {
            "There will be plenty more time for that, soon! ";
            exit;
        }

        if (gActionIs(GiveTo) || gActionIs(GiveToImplicit)) {
            "All of {my} kingly possessions are {my} own!. ";
            exit;
        }
        else if (gActionIs(ShowTo) || gActionIs(ShowToImplicit)) {
            "The only thing {i} must show is my regal stride! ";
            exit;
        }
        else if (
            gActionIs(SayAction) ||
            gActionIs(SayTo) ||
            gActionIs(AskAbout) ||
            gActionIs(AskFor) ||
            gActionIs(TellAbout) ||
            gActionIs(TellTo) ||
            gActionIs(TalkAbout) ||
            gActionIs(TalkTo) ||
            gActionIs(ImplicitConversationAction) ||
            gActionIs(QueryAbout) ||
            gActionIs(MiscConvAction) ||
            gActionIs(Hello) ||
            gActionIs(Goodbye)
        ) {
            meowPrompt;
            exit;
        }
        else if (gActionIs(Follow)) {
            "{I} follow <i>nobody!</i> The kingdom{dummy} follows <i>{me}!</i> ";
            exit;
        }
    }
}

+catNameTag: Fixture { 'nametag;name;tag collar pendant plate badge card'
    "<<if gCatMode>>A tiny bit of shiny metal, dangling from {my} collar.
    It used to make an infuriating jingling sound, but ever since the lone
    citizen became {my} only neighbor, he had wrapped some yarn around it{dummy},
    allowing {me} to move more silently. {I}{'m} not sure why he never just
    <i>removed the collar entirely</i>, but it's only a minor infraction.
    His services{dummy} to {me} outweigh this...<i>mostly</i>.
    <<else>>It\'s a little round name tag for the cat. Someone seems to have
    wrapped some yarn around it, though it's not clear <i>why</i>. Maybe it's
    to make this cat more silent? Wouldn't this warrant removing the collar
    <i>entirely</i>, though...?<<end>>"

    readDesc = "<<if gCatMode>>{I} struggle to read the strange scrawlings
    of {my} hairless subjects, but {i} know these shapes mean something to
    them. {I}'ve lived long enough to know that the weird etchings in {my}
    tag are pronounced <q><<gCatName>></q>, which also seems to be the sound
    these creatures make when they desire audience{dummy} with {me}.
    <<else>>The etched name on the small metal tag is written in cursive,
    which is a little difficult to read, still. However, it seems to
    indicate the cat's name is <q><<gCatName>></q>.<<end>>"
}

+CarryMap;
+CarryCompass;

modify bodyParts {
    vocab = 'body; (my) (your) (his) (her) (this) (left) (right);
    head hand ear fist finger thumb arm leg foot eye face nose mouth
    tooth tongue lip knee elbow tail paw; it them'

    notHereMsg =
    'Body parts are not important enough to
    specifically refer to them. '
}
