transient prologuePrefCore: PreferencesModule {
    getPreferences() {
        return new Vector([
            new BooleanPreference('Seen intro status', true,
                'player has seen intro',
                'player has not seen intro',
                &playerHasSeenIntro,
                prologuePrefCore,
                nil
            ),
            new BooleanPreference('Cat prologue preference', nil,
                'player prefers no cat prologue',
                'player prefers cat prologue',
                &playerPrefersNoCatPrologue,
                prologuePrefCore,
                &playerHasCatProloguePreference
            ),
            new BooleanPreference('Prey prologue preference', nil,
                'player prefers no prey prologue',
                'player prefers prey prologue',
                &playerPrefersNoPreyPrologue,
                prologuePrefCore,
                &playerHasPreyProloguePreference
            ),
            new BooleanPreference('Intro preference', nil,
                'player prefers no intro',
                'player prefers intro',
                &playerPrefersNoIntro,
                prologuePrefCore,
                &playerHasIntroPreference
            ),
            new IntegerPreference('Music volume preference', nil,
                0, 100, 50,
                'player prefers music set to ',
                &musicVolume,
                transMusicPlayer,
                &playerGavePreferences,
                new BooleanPreference('Music preference', nil,
                    'player prefers music',
                    'player prefers no music',
                    &playerWantsMusic,
                    transMusicPlayer,
                    &playerGavePreferences
                )
            ),
            new BooleanPreference('SFX preference', nil,
                'player prefers sfx',
                'player prefers no sfx',
                &playerWantsSFX,
                transMusicPlayer,
                &playerGavePreferences
            )
        ]);
    }

    playerHasSeenIntro = nil

    playerHasCatProloguePreference = nil
    playerPrefersNoCatPrologue = nil
    skipCatPrologue = (
        playerHasCatProloguePreference &&
        playerPrefersNoCatPrologue
    )

    playerHasPreyProloguePreference = nil
    playerPrefersNoPreyPrologue = nil
    skipPreyPrologue = (
        playerHasPreyProloguePreference &&
        playerPrefersNoPreyPrologue
    )

    playerHasIntroPreference = nil
    playerPrefersNoIntro = nil
    skipIntro = (
        playerHasIntroPreference &&
        playerPrefersNoIntro
    )

    gaveHTMLDisclaimer = nil

    getGameName() {
        return 'I Am Prey';
    }
    
    showWarnings() {
        #if __SHOW_PROLOGUE
        if (!outputManager.htmlMode && !gaveHTMLDisclaimer) {
            gaveHTMLDisclaimer = true;
            """
            <<formatTitle('Interpreter Mismatch')>>
            Games written in TADS 2, TADS 3, and HTML TADS 3 run inside of a program
            called an <q>interpreter</q> <i>(e.g. QTADS, Gargoyle, or Parchment)</i>
            for security and cross-platform compatibility reasons.\b
            Most interpreters support TADS 2 and TADS 3, but <i>this</i> game was written
            in <i><b>HTML TADS 3</b></i>, which is <b>not</b> supported by the interpreter
            you are currently using! As a result, this interpreter will probably remove
            certain kinds content, functionality, and formatting from the game,
            in an attempt to continue running!\b
            I have done everything I can to detect these issues,
            and dynamically rearrange the <b>core game elements</b>
            to work around incompatibilities, but
            you will still be missing out on <b>music</b>, <b>sound effects</b>,
            some <b>extra text styling</b>, as well as <b>clickable menus and actions</b>.\b
            These are all things that are <i>completely outside of my control</i>,
            because I must work within the constraints of the interpreter.\b
            If you would like to see what you might be missing out on (and
            get the most out of your experience), then
            it is recommended that you play this game with either the
            <<QTADSURL.printBase()>> or <<HTMLTADSURL.printBase()>> interpreters!

            <<formatAlert('Note For Screen Reader Users:')>>
            Screen reader users are recommended to use the
            standard HTML TADS interpreter,
            which shares the same name as this game's format,
            because it is able to send text data to your screen reader.\b
            If you do not prefer to listen to game audio while playing text-based games,
            then you can continue using your chosen interpreter.\b
            This game's screen reader mode rearranges a lot of the game's text
            and removes clickable links,
            in an effort to make the audible presentation of the text clearer.
            As a result, you will not be missing out on any HTML TADS features,
            as a screen reader user, if you do not prefer to hear game audio.

            <<QTADSURL.printFooter()>>
            <<HTMLTADSURL.printFooter()>>

            <<wait for player>>
            """;
        }
        #endif
    }
}

#ifdef __ALLOW_DEBUG_ACTIONS
VerbRule(TestDeath)
    'try' 'death'
    : VerbProduction
    action = TestDeath
    verbPhrase = 'test/testing death menu'
;

DefineSystemAction(TestDeath)
    execAction(cmd) {
        gameTurnBroker.makeNegative();
        finishGameMsgSong(ftDeath, gEndingOptionsLoss);
    }
;
#endif
