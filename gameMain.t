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
#define __IS_CAT_GAME nil

#if __DEBUG
///////////////////////////////////////////////
////        PROLOGUE CONTROLLER:          ////
/////////////////////////////////////////////
/*()*/  #define __SHOW_PROLOGUE nil   /*()*/
///////////////////////////////////////////

// End compile modes

#else
// DO NOT ALTER:
#define __SHOW_PROLOGUE true
// ^- This is the non-debug behavior!!!
#endif

#include "forEveryone.t"
#include "cutsceneCore.t"
#include "awareVehicles.t"
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
#include "map/map.h"

gameMain: GameMainDef {
    initialPlayerChar = (gCatMode ? cat: prey)

    formatForScreenReader = nil

    showIntro() {
        showPrologue;
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
        "I Am Prey is a game about situational awareness, evasion, and
        escape.\b
        Parkour mechanics are available for the complex navigation of obstacles,
        and spreading soundwaves reward a stealthy playstyle,
        especially because the predator is <i>always listening!</i>\b
        Ideally, the player will <i>never</i> want to be seen,
        but last-minute tricks can be used to ditch the predator during a chase!\b
        Find all seven pieces of the environment suit, and escape through the
        emergency airlock to win!\b
        <i>This game is designed for replayability, and can normally be finished
        in one sitting!</i>";
    }
    showCredit() {
        "<i>I stand on the shoulders of giants...</i>\n
        Author:
        <a href='mailto:josephcsoftware@gmail.com'>Joey Cramsey</a>\n
        Special thanks to my partners, friends, as well as the excellent community
        over at <a href='https://intfiction.org/'>Intfiction Forum</a>!\n
        Adv3Lite library:
        <a href='https://www.ifwiki.org/Eric_Eve'>Eric Eve</a>\n
        TADS 3:
        <a href='https://www.ifwiki.org/Michael_J._Roberts'>Michael J Roberts</a>";
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