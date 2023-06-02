musicPlayer: InitObject {
    songDuringTurn = nil

    execBeforeMe = [screenReaderInit]

    execute() {
        // Don't bother the players who are not using HTML-compatible terps.
        if (!outputManager.htmlMode) {
            if (transMusicPlayer.gaveHTMLDisclaimer) return;
            transMusicPlayer.gaveHTMLDisclaimer = true;
            "\b
            This game comes with optional music and sound effects, but it seems
            like your interpreter does not support these features.\b
            That's okay, though! The music and sound effects do not carry
            critical information, and this game has been tested on
            many kinds of interpreters!\b
            If you would like to get the most out of your experience,
            however, it is recommended that you play this game in
            <a href='https://github.com/realnc/qtads/releases'>QTADS</a>!
            \b";
            inputManager.pauseForMore();
            "\b";
            return;
        }

        #if __SHOW_PROLOGUE
        if (transMusicPlayer.playerGavePreferences) {
            """
            <b>Your previous audio settings were:</b>\n
            <<if transMusicPlayer.playerWantsMusic
            >>Music set to <b><<transMusicPlayer.musicVolume>></b><<else
            >>Music turned <b>OFF</b><<end>>, and\n
            sound effects turned
            <b><<if transMusicPlayer.playerWantsSFX
            >>ON<<else>>OFF<<end>></b>.
            """;

            if (ChoiceGiver.staticAsk(
                'Would you like to keep these settings?'
            )) {
                prologuePrefCore.remindOfFile();
            }
            else {
                transMusicPlayer.playerGavePreferences = true;
            }
        }
        #endif

        // The preference flag could have changed
        if (!transMusicPlayer.playerGavePreferences) {
            transMusicPlayer.playerGavePreferences = true;

            if (ChoiceGiver.staticAsk(
                'Would you like some music to accompany this game?'
            )) {
                transMusicPlayer.playerWantsMusic = true;
                "<.p>
                <<if gFormatForScreenReader>>To not disrupt your screen reader,
                this game offers a music volume option.<<end>>\b
                Please enter a music volume level, numbered from
                <b>0</b>&nbsp;to&nbsp;<b>100</b>.\n
                For a sample, the song with the greatest intensity
                is currently playing at a volume
                level of <b><<transMusicPlayer.musicVolume>></b>.\b";

                local acceptableVolume = nil;
                local volumeLevel = transMusicPlayer.musicVolume;

                playSong(chaseSong, volumeLevel);

                while (!acceptableVolume) {
                    volumeLevel = tryInt(ChoiceGiver.showAskPrompt());

                    if (volumeLevel == nil) {
                        "Please enter a volume level, which can be any
                        whole number from <b>0</b>&nbsp;to&nbsp;<b>100</b>.";
                        continue;
                    }

                    if (volumeLevel < 0) volumeLevel = 0;
                    if (volumeLevel > 100) volumeLevel = 100;

                    if (volumeLevel == 0) {
                        playSong(nil, volumeLevel);
                    }
                    else {
                        playSong(chaseSong, volumeLevel);
                    }

                    acceptableVolume = ChoiceGiver.staticAsk(
                        'Is this a suitable maximum volume level?'
                    );

                    if (!acceptableVolume) {
                        "Okay, let's try a new volume level.";
                    }
                }

                if (volumeLevel == 0) {
                    transMusicPlayer.playerWantsMusic = nil;
                }
                else {
                    transMusicPlayer.musicVolume = volumeLevel;
                }

                playSong(nil);
            }

            //FIXME: Uncomment this once SFX are added
            /*transMusicPlayer.playerWantsSFX = ChoiceGiver.staticAsk(
                transMusicPlayer.playerWantsMusic ?
                'Would you also like sound effects and ambience?'
                :
                'Would you like sound effects and ambience instead?'
            );*/

            //TODO: Save settings, and ask the player if they would
            // like to use their previous sound settings upon restart.

            prologuePrefCore.writePreferences();
            prologuePrefCore.remindOfFile();
        }
    }

    playSong(songObj, volumeLevel?) {
        if (!transMusicPlayer.allowMusic) return;
        if (volumeLevel == nil) {
            volumeLevel = transMusicPlayer.musicVolume;
        }

        // Don't mess with anything if there's no reason to.
        if (
            songObj == songDuringTurn &&
            volumeLevel == transMusicPlayer.musicVolume
        ) return;

        songDuringTurn = songObj;
        updateSong(volumeLevel);
    }

    updateSong(volumeLevel?) {
        if (volumeLevel == nil) {
            volumeLevel = transMusicPlayer.musicVolume;
        }

        local hasChange = nil;

        if (volumeLevel != transMusicPlayer.musicVolume) {
            hasChange = true;
            transMusicPlayer.volumeChanged = true;
        }
        else if (songDuringTurn != transMusicPlayer.currentSong) {
            hasChange = true;
        }

        if (hasChange) {
            transMusicPlayer.loadNextSong(songDuringTurn);
            transMusicPlayer.musicVolume = volumeLevel;

            transMusicPlayer.updateSong();
        }
    }

    // Method to continue song after screen clears
    recoverSong(nextSongObj?) {
        if (!transMusicPlayer.allowMusic) return;
        transMusicPlayer.previousSong = nil;
        transMusicPlayer.currentSong = nil;

        if (nextSongObj != nil) {
            playSong(nextSongObj);
        }
        else {
            updateSong();
        }
    }
}

transient transMusicPlayer: object {
    playerGavePreferences = nil
    gaveHTMLDisclaimer = nil

    playerWantsMusic = nil
    allowMusic = (playerWantsMusic && outputManager.htmlMode)
    musicVolume = 50

    playerWantsSFX = nil
    allowSFX = (playerWantsSFX && outputManager.htmlMode)

    previousSong = nil
    currentSong = nil
    volumeChanged = nil

    fadetime = '1.0'

    updateSong() {
        if (!allowMusic) return;

        local fade = nil;
        if (previousSong != currentSong) {
            if (previousSong != nil) {
                if (previousSong.fadeout) fade = true;
            }
            else {
                // ALWAYS fade in from silence!
                fade = true;
            }
            if (currentSong != nil) {
                if (currentSong.fadein) fade = true;
            }
            else {
                // ALWAYS fade out from silence!
                fade = true;
            }
        }

        if (volumeChanged) {
            volumeChanged = nil;
            if (currentSong != nil) {
                playImmediately(currentSong.songURL);
            }
            else {
                stopMusic();
            }
            return;
        }
        else if (previousSong == currentSong) {
            // We are changing neither the song nor volume.
            // There is no reason to continue this method.
            return;
        }

        if (currentSong == nil) {
            if (fade) {
                fadeout();
            }
            else {
                stopMusic();
            }
        }
        else if (previousSong == nil) {
            if (fade) {
                fadein(currentSong.songURL);
            }
            else {
                playImmediately(currentSong.songURL);
            }
        }
        else if (fade) {
            crossfade(currentSong.songURL);
        }
        else {
            playImmediately(currentSong.songURL);
        }
    }

    fadeout() {
        say(
            '<SOUND CANCEL=BACKGROUND
            FADEOUT=CROSSFADE,' + fadetime + '>'
        );
    }

    fadein(songURL) {
        say(
            '<SOUND SRC="' + songURL + '"
            LAYER=BACKGROUND
            FADEIN=CROSSFADE,' + fadetime + '
            REPEAT=LOOP
            VOLUME=' + musicVolume + '>'
        );
    }

    crossfade(songURL) {
        say(
            '<SOUND SRC="' + songURL + '"
            LAYER=BACKGROUND
            FADEIN=CROSSFADE,' + fadetime + '
            INTERRUPT
            REPEAT=LOOP
            VOLUME=' + musicVolume + '>'
        );
    }

    playImmediately(songURL) {
        say(
            '<SOUND SRC="' + songURL + '"
            LAYER=BACKGROUND
            INTERRUPT
            REPEAT=LOOP
            VOLUME=' + musicVolume + '>'
        );
    }

    stopMusic() {
        say(
            '<SOUND CANCEL=BACKGROUND>'
        );
    }

    loadNextSong(nextSong) {
        if (!allowMusic) return;
        if (nextSong == currentSong) return;

        previousSong = currentSong;
        currentSong = nextSong;
    }
}

class GameSong: object {
    songURL = ''
    fadein = nil
    fadeout = nil
}

chillSong: GameSong {
    songURL = 'music/chill.ogg'
    fadein = true
}

chaseSong: GameSong {
    songURL = 'music/chase.ogg'
    fadeout = true
}

preySong: GameSong {
    songURL = 'music/prey.ogg'
    fadein = true
    fadeout = true
}

skashekSong: GameSong {
    songURL = 'music/predator.ogg'
    fadein = true
    fadeout = true
}

replace cls() {
    aioClearScreen();
    musicPlayer.recoverSong();
}

clsWithSong(nextSong) {
    musicPlayer.songDuringTurn = nextSong;
    cls();
}

#ifdef __DEBUG
VerbRule(TestChaseSong)
    'try' 'chase'
    : VerbProduction
    action = TestChaseSong
    verbPhrase = 'test/testing chase song'
;

DefineSystemAction(TestChaseSong)
    includeInUndo = true
    execAction(cmd) {
        musicPlayer.playSong(chaseSong);
        "Playing chase song.<.p>";
    }
;

VerbRule(TestChillSong)
    'try' 'chill'
    : VerbProduction
    action = TestChillSong
    verbPhrase = 'test/testing chill song'
;

DefineSystemAction(TestChillSong)
    includeInUndo = true
    execAction(cmd) {
        musicPlayer.playSong(chillSong);
        "Playing chill song.<.p>";
    }
;

VerbRule(TestNilSong)
    'try' 'silence'
    : VerbProduction
    action = TestNilSong
    verbPhrase = 'test/testing silence'
;

DefineSystemAction(TestNilSong)
    includeInUndo = true
    execAction(cmd) {
        musicPlayer.playSong(nil);
        "Music silenced.<.p>";
    }
;
#endif

modify Undo {
    execAction(cmd) {
        local ret = inherited(cmd);
        
        if (ret) {
            // Recover the song from this turn.
            musicPlayer.updateSong();
        }

        return ret;
    }   
}

modify Restore {
    performRestore(fname, code) {
        local ret = inherited(fname, code);

        if (ret) {
            // Recover the song from this turn.
            musicPlayer.updateSong();
        }

        return ret;
    }
}