pgCat: Actor { 'cat;;kat kitty meowmeow pg pigi peegee pier giorg giorge giorgio piergiorgio' @subtleRoom
    person = (gCatMode ? 2 : 3)
    isHim = true
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
    tag are pronounced <q>Piergiorgio</q>, which also seems to be the sound
    these creatures make when they desire audience with you.
    <<else>>The etched name on the small metal tag is written in cursive,
    which is a little difficult to read, still. However, it seems to
    indicate the cat's name is <q>Piergiorgio</q>.<<end>>"
}

//TODO: All cat conversation is "meow", unless you do a streak of 20 to Skashek, in which case
// the case makes a fully-articulated complaint, catching Skashek off-guard.

//TODO: Cat mode involves Skashek trying to give you a bath. If you jump in the reactor
// reservoir, he's waiting at the end to rescue you, worried as fuck.