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

    musicLineHead = 'player prefers music set to '
    
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
                        case 'player prefers no music':
                            transMusicPlayer.playerGavePreferences = true;
                            transMusicPlayer.playerWantsMusic = nil;
                            break;
                        case 'player prefers no sfx':
                            transMusicPlayer.playerGavePreferences = true;
                            transMusicPlayer.playerWantsSFX = nil;
                            break;
                        case 'player prefers sfx':
                            transMusicPlayer.playerGavePreferences = true;
                            transMusicPlayer.playerWantsSFX = true;
                            break;
                        default:
                            if (statement.startsWith(musicLineHead)) {
                                local possibleVolume = nil;
                                local len = musicLineHead.length;
                                if (statement.length > len) {
                                    possibleVolume = tryInt(statement.substr(len));
                                }
                                if (possibleVolume == nil) {
                                    possibleVolume = 50;
                                }
                                transMusicPlayer.playerGavePreferences = true;
                                transMusicPlayer.playerWantsMusic = true;
                                transMusicPlayer.musicVolume = possibleVolume;
                            }
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

    hasWrittenAnything = nil

    writePreference(fl, str) {
        fl.writeFile(str + ';\n');
        hasWrittenAnything = true;
    }

    writePreferences() {
        hasWrittenAnything = nil;
        try {
            local prefsTextFile = File.openTextFile(fileName, FileAccessWrite);

            if (playerHasCatProloguePreference) {
                if (playerPrefersNoCatPrologue) {
                    writePreference(prefsTextFile, 'player prefers no cat prologue');
                }
                else {
                    writePreference(prefsTextFile, 'player prefers cat prologue');
                }
            }

            if (playerHasPreyProloguePreference) {
                if (playerPrefersNoPreyPrologue) {
                    writePreference(prefsTextFile, 'player prefers no prey prologue');
                }
                else {
                    writePreference(prefsTextFile, 'player prefers prey prologue');
                }
            }

            if (playerHasIntroPreference) {
                if (playerPrefersNoIntro) {
                    writePreference(prefsTextFile, 'player prefers no intro');
                }
                else {
                    writePreference(prefsTextFile, 'player prefers intro');
                }
            }

            if (transMusicPlayer.playerGavePreferences) {
                if (transMusicPlayer.playerWantsMusic) {
                    writePreference(prefsTextFile,
                        musicLineHead +
                        transMusicPlayer.musicVolume
                    );
                }
                else {
                    writePreference(prefsTextFile, 'player prefers no music');
                }

                if (transMusicPlayer.playerWantsSFX) {
                    writePreference(prefsTextFile, 'player prefers sfx');
                }
                else {
                    writePreference(prefsTextFile, 'player prefers no sfx');
                }
            }

            if (!hasWrittenAnything) {
                writePreference(prefsTextFile, 'player has no preferences');
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

    remindOfFile() {
        "<<remember>>
        You can always reset your preferences by deleting the
        following file:\n
        <tt><<prologuePrefCore.fileName>></tt>\b
        You can also edit this file directly!\n
        It should be in the same directory as the game file!
        <<wait for player>>";
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
        finishGameMsgSong(ftDeath, gEndingOptionsLoss);
    }
;
#endif

modify Restart {
    execAction(cmd) {
        local desireRestart = ChoiceGiver.staticAsk(
            'Are you sure you would like to start a new run? '
        );

        if (desireRestart) {
            //handleConfirmedRestart();
            doRestartGame();
        }
    }

    doRestartGame() {
        handleConfirmedRestart();
        musicPlayer.playSong(nil);
        sfxPlayer.setAmbience(nil);
        sfxPlayer.setDecorations(nil);
        PreRestartObject.classExec();
        throw new RestartSignal();
    }

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

        prologuePrefCore.writePreferences();
        if (choiceMade) {
            prologuePrefCore.remindOfFile();
        }
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