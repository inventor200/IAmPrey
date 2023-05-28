#include <file.h>

// We save everything in plain text, in case the player wants to
// manually edit their preferences.

transient prologuePrefCore: InitObject {
    execAfterMe = [screenReaderInit]

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

    preferencesWereLoaded = nil

    fileName = 'I-Am-Prey-Preferences.cfg'
    
    execute() {
        if (preferencesWereLoaded) return;
        preferencesWereLoaded = true;

        try {
            local prefsTextFile = File.openTextFile(fileName, FileAccessRead);

            local preferencesReadOkay = true;
            local lastLine = '';
            local strBfr = new StringBuffer(5);

            do {
                try {
                    lastLine = prefsTextFile.readFile();
                    strBfr.append(lastLine);
                } catch (FileIOException eex1) {
                    preferencesReadOkay = nil;
                    break;
                } catch (FileModeException eex2) {
                    preferencesReadOkay = nil;
                    break;
                }
            } while (lastLine != nil);

            prefsTextFile.closeFile();

            if (preferencesReadOkay) {
                local prefsStatements =
                    toString(strBfr)
                    .toLower()
                    .findReplace('.', ';')
                    .findReplace(',', ';')
                    .findReplace('\n', '; ')
                    .split(';');

                for (local i = 1; i <= prefsStatements.length; i++) {
                    local statement = prefsStatements[i].trim();

                    switch (statement) {
                        case 'player prefers no cat prologue':
                            playerHasCatProloguePreference = true;
                            playerPrefersNoCatPrologue = true;
                            break;
                        case 'player prefers cat prologue':
                            playerHasCatProloguePreference = true;
                            playerPrefersNoCatPrologue = nil;
                            break;
                        case 'player prefers no prey prologue':
                            playerHasPreyProloguePreference = true;
                            playerPrefersNoPreyPrologue = true;
                            break;
                        case 'player prefers prey prologue':
                            playerHasPreyProloguePreference = true;
                            playerPrefersNoPreyPrologue = nil;
                            break;
                        case 'player prefers no intro':
                            playerHasIntroPreference = true;
                            playerPrefersNoIntro = true;
                            break;
                        case 'player prefers intro':
                            playerHasIntroPreference = true;
                            playerPrefersNoIntro = nil;
                            break;
                    }
                }
            }
        } catch (FileNotFoundException ex1) {
            //
        } catch (FileOpenException ex2) {
            //
        } catch (FileSafetyException ex3) {
            //
        }
    }

    writePreferences() {
        try {
            local prefsTextFile = File.openTextFile(fileName, FileAccessWrite);

            if (playerHasCatProloguePreference) {
                if (playerPrefersNoCatPrologue) {
                    prefsTextFile.writeFile('player prefers no cat prologue;\n');
                }
                else {
                    prefsTextFile.writeFile('player prefers cat prologue;\n');
                }
            }

            if (playerHasPreyProloguePreference) {
                if (playerPrefersNoPreyPrologue) {
                    prefsTextFile.writeFile('player prefers no prey prologue;\n');
                }
                else {
                    prefsTextFile.writeFile('player prefers prey prologue;\n');
                }
            }

            if (playerHasIntroPreference) {
                if (playerPrefersNoIntro) {
                    prefsTextFile.writeFile('player prefers no intro;\n');
                }
                else {
                    prefsTextFile.writeFile('player prefers intro;\n');
                }
            }

            if (
                !playerHasCatProloguePreference &&
                !playerHasPreyProloguePreference &&
                !playerHasIntroPreference
            ) {
                prefsTextFile.writeFile('player has no preferences;\n');
            }
            
            prefsTextFile.closeFile();
        } catch (FileNotFoundException ex1) {
            //
        } catch (FileOpenException ex2) {
            //
        } catch (FileSafetyException ex3) {
            //
        }
    }
}

#ifdef __DEBUG
VerbRule(TestDeath)
    'try' 'death'
    : VerbProduction
    action = TestDeath
    verbPhrase = 'test/testing death menu'
;

DefineSystemAction(TestDeath)
    execAction(cmd) {
        finishGameMsg(ftDeath, gEndingOptionsLoss);
    }
;
#endif

modify Restart {
    execAction(cmd) {
        local desireRestart = ChoiceGiver.staticAsk(
            'Are you sure you would like to start a new run? '
        );

        if (desireRestart) {
            handleConfirmedRestart();
            doRestartGame();
        }
    }

    doRestartGame() {
        handleConfirmedRestart();
        PreRestartObject.classExec();
        throw new RestartSignal();
    }

    handleConfirmedRestart() {
        if (!prologuePrefCore.playerHasIntroPreference) {
            prologuePrefCore.playerPrefersNoIntro = ChoiceGiver.staticAsk(
                'Would you like to skip to the difficulty selection, from now on? '
            );

            prologuePrefCore.playerHasIntroPreference = true;
        }

        if (gCatMode) {
            if (!prologuePrefCore.playerHasCatProloguePreference) {
                prologuePrefCore.playerPrefersNoCatPrologue = ChoiceGiver.staticAsk(
                    'Would you like to skip the cat\'s prologue, from now on? '
                );

                prologuePrefCore.playerHasCatProloguePreference = true;
            }
        }
        else if (!prologuePrefCore.playerHasPreyProloguePreference) {
            prologuePrefCore.playerPrefersNoPreyPrologue = ChoiceGiver.staticAsk(
                'Would you like to skip Prey\'s prologue, from now on? '
            );

            prologuePrefCore.playerHasPreyProloguePreference = true;
        }

        prologuePrefCore.writePreferences();

        "\b\t<b>REMEMBER:</b>\n
        You can always reset your skipping preferences by deleting the
        following file:\n
        <tt><<prologuePrefCore.fileName>></tt>
        \b\b\b";

        inputManager.pauseForMore();
    }
}

modify Quit {
    execAction(cmd) {      
        local desireRestart = ChoiceGiver.staticAsk(
            'Are you sure you would like to quit? '
        );

        if (desireRestart) {
            "\b";
            throw new QuittingException;
        }       
    }
}