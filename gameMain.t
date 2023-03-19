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
/*-*/  #define __TEST_ROOM reservoirCorridor
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
}

versionInfo: GameID {
    IFID = '8c61fd61-7595-4277-a7ba-af9d18a6fc0c'
    name = 'I Am Prey'
    byline = 'by Joey Cramsey'
    htmlByline = 'by <a href="mailto:josephcsoftware@gmail.com">Joey Cramsey</a>'
    version = '1'
    authorEmail = 'josephcsoftware@gmail.com'
    desc = 'A horror-lite science fiction game of evasion.'
    htmlDesc = 'A horror-lite science fiction game of evasion.'
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
        <b>Special thanks</b> to my partners, friends, and the excellent community
        over at <a href='https://intfiction.org/'>Intfiction Forum</a>!\n
        <b>Adv3Lite library:</b> Eric Eve\n
        <b>TADS 3:</b> Michael J Roberts\b
        \t<i>Testing:</i>\n
        Nightshademaker (<a href='https://www.twitch.tv/nightshademakers'>Link to Twitch</a>)";
    }
}

modify statusLine {
    showStatusHtml() {
        "<<statusHTML(0)>><<aHref('look around', nil, nil, AHREF_Plain)>>";
        showStatusLeft();
            
        /* 
         *   end the left portion and start the right portion, then
         *   generate the <A HREF> to link the score to a FULL SCORE
         *   command 
         */
        //"<./a></a><<statusHTML(1)>><<aHref('full score', nil, nil, AHREF_Plain)>>";
        "<./a></a><<statusHTML(1)>>";
        showStatusRight();

        "<./a></a><<statusHTML(2)>>";

        /* add the status-line exit list, if desired */
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