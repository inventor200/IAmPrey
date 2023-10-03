#charset "us-ascii"
#include <tads.h>
#include "advlite.h"
#include "inventorCore.h"
#include "iamprey.h"

authorEmailURL: CompULR {
    baseHeader = ' ('
    baseText = 'Email'
    baseTail = ')'
    altText = ''
    name = 'Author email address'
    url = 'josephcsoftware@gmail.com'
    clickURL = 'mailto:josephcsoftware@gmail.com'
}

authorBandcampURL: CompULR {
    baseHeader = ' ('
    baseText = 'Bandcamp'
    baseTail = ')'
    altText = ''
    name = 'URL to the author\'s bandcamp'
    url = 'https://joeycramsey.bandcamp.com/'
}

forumsURL: CompULR {
    baseText = 'Intfiction Forum'
    name = 'URL to the Intfiction Forum'
    url = 'https://intfiction.org/'
}

mathbrushURL: CompULR {
    baseHeader = ' ('
    baseText = 'Link to IFDB'
    baseTail = ')'
    altText = ''
    name = 'URL to Mathbrush\'s IFDB page'
    url = 'https://ifdb.org/showuser?id=nufzrftl37o9rw5t'
}

nightshademakerURL: CompULR {
    baseHeader = ' ('
    baseText = 'Link to Twitch'
    baseTail = ')'
    altText = ''
    name = 'URL to Nightshademakers\'s Twitch channel'
    url = 'https://www.twitch.tv/nightshademakers'
}

pinkunzURL: CompULR {
    baseHeader = ' ('
    baseText = 'Link to IFDB'
    baseTail = ')'
    altText = ''
    name = 'URL to Pinkunz\'s IFDB page'
    url = 'https://ifdb.org/showuser?id=dqr2mj29irbx1qv4'
}

mapURL: CompULR {
    baseHeader = '<.p>'
    baseText = 'Click here for the facility map!'
    baseTail = '<.p>'
    altText = ''
    name = 'URL to the facility map (on the IFArchive)'
    url = 'https://unbox.ifarchive.org/1363p9wc5y/extras/Stylized-Map.png'
}

QTADSURL: CompULR {
    baseText = 'QTADS'
    name = 'URL to the downloads page for the QTADS interpreter'
    url = 'https://github.com/realnc/qtads/releases'
}

HTMLTADSURL: CompULR {
    baseText = 'HTML TADS'
    name = 'URL to the IFWiki page for the HTML TADS interpreter'
    url = 'https://www.ifwiki.org/HTML_TADS_(Interpreter)'
}

gameMain: GameMainDef {
    initialPlayerChar = prey

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

modify gameMenuHandler {
    showContentWarnings = (!prologuePrefCore.skipIntro)
    #if __SHOW_PROLOGUE
    beforeWarnings() {
        clsWithSong(nil);

        if (!prologuePrefCore.skipIntro && prologuePrefCore.playerHasSeenIntro) {
            if (ChoiceGiver.staticAsk(
                'It seems you\'ve been here before.
                Would you like to skip to difficulty selection?'
            )) {
                prologuePrefCore.playerHasIntroPreference = true;
                prologuePrefCore.playerPrefersNoIntro = true;
            }
        }
    }

    contentWarnings = [
        'violence',
        'frequent, crude language',
        'rare mentions of suicide'
    ]

    showOtherWarnings() {
        """
        <<formatAlert('Anxiety warning:')>>

        This game features an active antagonist,
        so your turns must be spent wisely!

        <<formatTitle('Note on randomness and ' + titleCommand('UNDO'))>>

        Elements of this game are randomized, with casual replayability
        in mind. Use of <<formatCommand('UNDO')>>
        will not change the outcomes of randomized events.\b
        Rest assured that your survival is not decided by randomness.
        """;
        #if __IS_MAP_TEST
        //
        #else
        """
        <<wait for player>>
        <<formatTitle('Note for new and experienced players')>>

        This will not be a standard parser game. Players of <b>all skill levels</b>
        should consult <i>Prey's Survival Guide</i>
        (which should have come with this game), or use the
        <<formatCommand('guide')>> command
        for the in-game version of the document.\b

        There are a number of new game mechanics ahead, and
        they were not designed with the traditions of this medium in mind.\b

        For more information, experienced parser players should use the
        <<formatCommand('parser warning')>> command.
        """;
        #endif
    }
    #endif

	restartMsg = 'Are you sure you would like to start a new run? '
	
	handleConfirmedRestart() {
        local choiceMade = nil;
        if (!prologuePrefCore.playerHasIntroPreference) {
            prologuePrefCore.playerPrefersNoIntro = ChoiceGiver.staticAsk(
                'Would you like to skip to the difficulty selection, from now on? '
            );

            prologuePrefCore.playerHasIntroPreference = true;
            choiceMade = true;
        }

        if (gCatMode) {
            if (!prologuePrefCore.playerHasCatProloguePreference) {
                prologuePrefCore.playerPrefersNoCatPrologue = ChoiceGiver.staticAsk(
                    'Would you like to skip the cat\'s prologue, from now on? '
                );

                prologuePrefCore.playerHasCatProloguePreference = true;
                choiceMade = true;
            }
        }
        else if (!prologuePrefCore.playerHasPreyProloguePreference) {
            prologuePrefCore.playerPrefersNoPreyPrologue = ChoiceGiver.staticAsk(
                'Would you like to skip Prey\'s prologue, from now on? '
            );

            prologuePrefCore.playerHasPreyProloguePreference = true;
            choiceMade = true;
        }

        preferencesCore.writePreferences();
        if (choiceMade) {
            preferencesCore.remindOfFile();
        }
    }
    
	afterConfirmedRestart() {
		musicPlayer.playSong(nil);
        sfxPlayer.setAmbience(nil);
        sfxPlayer.setDecorations(nil);
	}

    handleConfirmedStateRecovery() {
        // Recover the song from this turn.
        musicPlayer.updateSong();
        recoverAmbience();
    }
	
    showHowToWinAndProgress() {
        if (gCatMode) return;
        "<b>Find all seven pieces of the environment suit, and escape through the
        emergency airlock to win!</b>\b
        <<suitTracker.getProgressLists()>>";
    }
    
    showAdditionalHelp(fromHelpCommand) {
    	if (sneakyCore.allowSneak) {
            "<<formatAlert('AUTO-SNEAK is ENABLED!')>>
            Use <<formatTheCommand('SNEAK')>> (abbreviated <<abbr('SN')>>)
            to automatically
            sneak around the map! For example:
            <<createFlowingList([
                formatCommand('SNEAK NORTH'),
                formatCommand('SN THRU DOOR')
            ])>>
            <<remember>>
            This is a <i>learning tool!</i> \^<<formatTheCommand('SNEAK')>>
            <i>will be disabled outside of tutorial modes,</i>
            meaning you will need to remember to
            <<formatCommand('LISTEN')>>,
            <<formatCommand('PEEK')>>,
            and <<formatCommand('CLOSE DOOR')>> on your own!\b
            If you'd rather practice without auto-sneak, simply enter in
            <<formatTheCommand('sneak off', shortCmd)>>.\b
            <<remember>> You are always free to
            <<formatCommand('turn sneak back on', longCmd)>> in a tutorial mode!";
        }
        if (!gFormatForScreenReader) {
            mapURL.printBase();
            mapURL.printFooter();
        }
    }
    
    explainInstructions() {
		"To read the in-game copy of
        Prey's Survival Guide (which explains how to play this game), type in
        <<formatTheCommand('guide', shortCmd)>> at the prompt.
        This could be necessary, if you are new to
        interactive fiction (<q><<abbr('IF')>></q>), text games, parser games,
        text adventures, etc.";
	}
	
	explainExtraHelp() {
		"\b";
		"Remember, you can always explore a simplified version of the
        world&mdash;<i>without spending turns</i>&mdash;as long as you are
        in <i>map mode!</i>\n
        Use <<formatTheCommand('map', shortCmd)>> to enter or leave map mode!";
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
        <b>Author:</b> Joey Cramsey<<authorEmailURL.printBase()
        >><<authorBandcampURL.printBase()>>\n
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
        over at the <<forumsURL.printBase()>>!\b
        \t<i>Testing:</i>\n
        Mathbrush <<mathbrushURL.printBase()>>\n
        Nightshademaker<<nightshademakerURL.printBase()>>\n
        Piergiorgio d'Errico\n
        Pinkunz<<pinkunzURL.printBase()>>\n
        Rovarsson\b
        \t<i>Accessibility Consulting/Testing:</i>\n
        Rain";

        authorEmailURL.printFooter();
        authorBandcampURL.printFooter();
        forumsURL.printFooter();
        mathbrushURL.printFooter();
        nightshademakerURL.printFooter();
        pinkunzURL.printFooter();
        
        inherited();
    }
}
