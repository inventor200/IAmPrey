#charset "us-ascii"
#include <tads.h>
#include "advlite.h"

#define gFormatForScreenReader gameMain.formatForScreenReader

#define gDirectCmdStr(command) \
    (gFormatForScreenReader ? \
        ('<b>' + (command).toUpper() + '</b>') : \
        aHrefAlt((command).toLower(), (command).toUpper(), \
        '<b>' + (command).toUpper() + '</b>') \
    )

#include "betterChoices.t"

// Begin compile modes
#define __IS_MAP_TEST true

#ifdef __DEBUG
////////////////////////////////////////////////
/////        PROLOGUE CONTROLLER:          ////
//////////////////////////////////////////////
/*(-)*/  #define __SHOW_PROLOGUE nil
/*--*/  #define __FAST_DIFFICULTY 4
/*-*/  #define __TEST_ROOM displayShelf
///////////////////////////////////////*||*\

// End compile modes

#else
// DO NOT ALTER:
#define __SHOW_PROLOGUE true
#if __IS_MAP_TEST
#define __FAST_DIFFICULTY 1
#else
#define __FAST_DIFFICULTY 4
#endif
// ^- This is the non-debug behavior!!!
#endif

#define gActorIsPlayer (gActor == gPlayerChar)
#define gActorIsPrey (gActor == prey)
#define gActorIsCat (gActor == cat)
#define gEndingOptionsWin [finishOptionCredits, finishOptionAmusing]
#define gEndingOptionsLoss [finishOptionCredits, finishOptionUndo]
#define actorCapacity 10
#define actorBulk 25
#include "forEveryone.t"
#include "cutsceneCore.t"
#include "disamDirection.t"
#include "distributedComponents.t"
#include "moddedSearch.t"
#include "awareVehicles.t"
#define gCatMode huntCore.inCatMode
#define gPreyMode (!huntCore.inCatMode)
#define gSkashekName skashek.globalParamName
#define gCatName (huntCore.printApologyNoteForPG())
#define gCatNickname (huntCore.printApologyNoteForPG(true))
#include "moddedActors.t"
#include "cat.t"
#include "preyPlayer.t"
#include "skashek.t"
#include "soundBleed.t"
#include "sneakyDoors.t"
#include "huntCore.t"
#include "parkour.t"
#include "trinkets.t"
#include "moduleUnion.t"
#include "prologue.t"
#include "epilogue.t"
#include "preciseHelp.t"
#include "wardrobe.t"
#include "mapMode.t"
#include "map/map.h"

gameMain: GameMainDef {
    initialPlayerChar = prey

    formatForScreenReader = nil
    lickedHandle = nil

    showIntro() {
        showPrologue;

        skashek.startTheDay();
        gPlayerChar.startTheDay();
    }
    showGoodbye() {
        "Thank you for playing! Hope you come back soon! ";
    }
}

versionInfo: GameID {
    IFID = '8c61fd61-7595-4277-a7ba-af9d18a6fc0c'
    name = 'I Am Prey'
    byline = 'by Joey Cramsey'
    htmlByline = 'by <a href="mailto:josephcsoftware@gmail.com">Joey Cramsey</a>'
    version = '0.9'
    authorEmail = 'josephcsoftware@gmail.com'
    desc = 'A horror-lite science fiction game of evasion.'
    htmlDesc = 'A horror-lite science fiction game of evasion.'
    releaseDate = '2023-04-02'
    licenseType = 'freeware'
    copyingRules = '<a href="https://creativecommons.org/licenses/by-sa/4.0/"
        >Creative Commons Attribution-ShareAlike 4.0 International</a>'
    presentationProfile = 'Plain Text'
    showAbout() {
        "<i>I Am Prey</i> is a game about situational awareness, evasion, and
        escape.\b
        Parkour mechanics are available for the complex navigation of obstacles,
        while spreading soundwaves reward a stealthy playstyle,
        especially because the Predator is <i>always listening!</i>\b
        Ideally, the player will <i>never</i> want to be seen,
        but last-minute tricks can be used to ditch the predator during a chase!\b
        <<helpMessage.showHowToWinAndProgress()>>\b
        <i>This game is designed for casual replayability!</i>";
    }
    showCredit() {
        "\t<i>I stand on the shoulders of giants...</i>\n
        <b>Author:</b> Joey Cramsey (<a href='mailto:josephcsoftware@gmail.com'>Email</a>)
        (<a href='https://joeycramsey.bandcamp.com/'>Link to Bandcamp</a>)\n
        <b><<one of
        >>Vibe Checker<<or
        >>Master of Whimsey<<or
        >>Comic Relief<<or
        >>Interior Designer<<or
        >>King Arthur played by<<or
        >><q>God's Special Little Guy</q><<or
        >>Maid Services<<or
        >>Catering<<shuffled>>:</b> Akira Lowe\n
        <b>Special thanks</b> to my partners, friends, and the excellent community
        over at <a href='https://intfiction.org/'>Intfiction Forum</a>!\n
        <b>Adv3Lite library:</b> Eric Eve\n
        <b>TADS 3:</b> Michael J Roberts\b
        \t<i>Testing:</i>\n
        Mathbrush (<a href='https://ifdb.org/showuser?id=nufzrftl37o9rw5t'>Link to IFDB</a>)\n
        Nightshademaker (<a href='https://www.twitch.tv/nightshademakers'>Link to Twitch</a>)\n
        Piergiorgio d'errico\n
        Rovarsson";
    }
}

modify Score {
    execAction(cmd) {
        helpMessage.showHowToWinAndProgress();
    }
}

modify FullScore {
    execAction(cmd) {
        helpMessage.showHowToWinAndProgress();
    }
}

modify finishOptionAmusing {
    doOption() {
        "<b>Here are some silly things you could try:</b>\n
        Check Akira Lowe's credit in the CREDITS text. It changes!\n
        As soon as you start a new game (outside of Cat Mode), try to CRY.\n
        Try to HUG or KISS <<gSkashekName.toUpper()>>.\n
        Try to TAKE SHARD from a broken mirror, and be seen by <<gSkashekName>>.\n
        When <<gSkashekName>> is chasing you, try to TAKE OFF CLOTHES.\n
        You can MEOW in Cat Mode!\n
        Try to LICK DOOR HANDLE.\n
        Attempting to ATTACK <<gSkashekName.toUpper()>> ends in catastrophe!\n
        Outside of Nightmare Mode and Cat Mode, you can try waiting for
        <<gSkashekName>> to walk into the starting room, and then CRY
        in front of him.";
        return true;
    }
}

modify finishOptionFullScore {
    doOption() {
        "Ack!";
        return true;
    }
}

modify statusLine {
    showStatusHtml() {
        "<<statusHTML(0)>><<aHref('look around', nil, nil, AHREF_Plain)>>";
        showStatusLeft();
        "<./a></a><<statusHTML(1)>>";
        showStatusRight();
        "<./a></a><<statusHTML(2)>>";
        if (gPlayerChar.location!= nil) {
            gPlayerChar.location.showStatuslineExits();
        }
    }

    showStatusRight() {
        local turnVerb = 'survived';
        if (gCatMode) {
            if (huntCore.wasBathTimeAnnounced) {
                turnVerb = 'stinky!';
            }
            else {
                turnVerb = 'explored';
            }
        }
        local turnStr = 'turn';
        if (gTurns != 1) turnStr += 's';
        "<b><<gTurns>> <<turnStr>> <<turnVerb>></b>";
    }
}