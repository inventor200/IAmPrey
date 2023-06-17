#charset "us-ascii"
#include <tads.h>
#include "advlite.h"
#include "iamprey.h"

gameMain: GameMainDef {
    initialPlayerChar = prey

    lickedHandle = nil

    showIntro() {
        if (huntCore.difficultySettingObj != restoreModeSetting) {
            prologueCore.play();
        }
        else {
            "\b<b>Prologue has been skipped.</b>\b
            Use <<formatTheCommand('restore', shortCmd)>> to
            load your saved game.\b
            <b>NOTE:</b> If your saved game was from another
            version of <i>I&nbsp;Am&nbsp;Prey</i>, then TADS will not be able to
            restore it!\b
            To read the survival guide, use
            <<formatTheCommand('guide', shortCmd)>>.\b
            If you need you, you can also <<formatCommand('restart', shortCmd)>>.
            \b\b\b";
        }

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
    version = __GAME_VERSION
    authorEmail = 'josephcsoftware@gmail.com'
    desc = 'A horror-lite science fiction game of evasion.'
    htmlDesc = 'A horror-lite science fiction game of evasion.'
    releaseDate = '2023-04-02'
    licenseType = 'freeware'
    copyingRules = '<a href="https://www.gnu.org/licenses/gpl-3.0.en.html"
        >GPLv3.0</a>'
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
        <b>Author:</b> Joey Cramsey";
        authorEmailURL.printBase();
        authorBandcampURL.printBase();
        "\n<b><<one of
        >>Vibe Checker<<or
        >>Master of Whimsey<<or
        >>Comic Relief<<or
        >>Interior Designer<<or
        >>King Arthur played by<<or
        >><q>God's Special Little Guy</q><<or
        >>Maid Services<<or
        >>Catering<<shuffled>>:</b> Akira Lowe\n
        <b>Special thanks</b> to my partners, friends, and the excellent community
        over at the ";
        forumsURL.printBase();
        "!\n
        <b>Adv3Lite library:</b> Eric Eve\n
        <b>TADS 3:</b> Michael J Roberts\b
        \t<i>Testing:</i>\n
        Mathbrush";
        mathbrushURL.printBase();
        "\nNightshademaker";
        nightshademakerURL.printBase();
        "\nPiergiorgio d'Errico\n
        Pinkunz";
        pinkunzURL.printBase();
        "\nRovarsson\b
        \t<i>Accessibility Consulting/Testing:</i>\n
        Rain";

        authorEmailURL.printFooter();
        authorBandcampURL.printFooter();
        forumsURL.printFooter();
        mathbrushURL.printFooter();
        nightshademakerURL.printFooter();
        pinkunzURL.printFooter();
    }
}