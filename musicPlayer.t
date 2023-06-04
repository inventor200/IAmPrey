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
                transMusicPlayer.playerGavePreferences = nil;
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
            else {
                transMusicPlayer.playerWantsMusic = nil;
            }

            transMusicPlayer.playerWantsSFX = ChoiceGiver.staticAsk(
                transMusicPlayer.playerWantsMusic ?
                'Would you also like sound effects and ambience?'
                :
                'Would you like sound effects and ambience instead?'
            );

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
            if (previousSong == nil || currentSong == nil) {
                fade = true;
            }
            else {
                fade = true;
                if (previousSong != nil) {
                    if (!previousSong.fadeout) fade = nil;
                }
                if (currentSong != nil) {
                    if (!currentSong.fadein) fade = nil;
                }
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

transient sfxPlayer: object {
    fadetime = '2.0'
    currentAmbience = nil

    setAmbience(ambienceObj) {
        if (!transMusicPlayer.allowSFX) return;
        local previousAmbience = currentAmbience;
        currentAmbience = ambienceObj;

        // No point changing to the same ambience
        if (currentAmbience == previousAmbience) return;

        if (previousAmbience == nil) {
            fadein(currentAmbience.sfxURL, toString(currentAmbience.volume));
        }
        else if (currentAmbience == nil) {
            fadeout();
        }
        else {
            crossfade(currentAmbience.sfxURL, toString(currentAmbience.volume));
        }
    }

    fadeout() {
        say(
            '<SOUND CANCEL=BGAMBIENT
            FADEOUT=CROSSFADE,' + fadetime + '>'
        );
    }

    fadein(sfxURL, sfxVolume) {
        say(
            '<SOUND SRC="' + sfxURL + '"
            LAYER=BGAMBIENT
            FADEIN=CROSSFADE,' + fadetime + '
            REPEAT=LOOP
            VOLUME=' + sfxVolume + '>'
        );
    }

    crossfade(sfxURL, sfxVolume) {
        say(
            '<SOUND SRC="' + sfxURL + '"
            LAYER=BGAMBIENT
            FADEIN=CROSSFADE,' + fadetime + '
            INTERRUPT
            REPEAT=LOOP
            VOLUME=' + sfxVolume + '>'
        );
    }
}

class GameAmbience: object {
    sfxURL = ''
    volume = 75

    // How much will the ambience silence foreground sounds?
    drownOutFactor = 0

    getDrownedVolume(soundObj) {
        local floatVol = new BigNumber(soundObj.volume);
        local one = new BigNumber(1);
        local cent = new BigNumber(100);
        local floatDrownOut =
            (new BigNumber(drownOutFactor) / cent)
            - (new BigNumber(soundObj.antiDrowningFactor) / cent);
        local mult = one - floatDrownOut;
        if (mult < 0) mult = 0;
        if (mult > 1) mult = one;
        local finalVol = floatVol * mult;
        return toInteger(finalVol);
    }
}

carpetAmbience: GameAmbience {
    sfxURL = 'sounds/carpet.ogg'
}

coolingDuctAmbience: GameAmbience {
    sfxURL = 'sounds/coolingduct.ogg'
    drownOutFactor = 75
}

freezerAmbience: GameAmbience {
    sfxURL = 'sounds/coolingduct.ogg'
    volume = 50
}

hangarAmbience: GameAmbience {
    sfxURL = 'sounds/hangar.ogg'
}

industrialAmbience: GameAmbience {
    sfxURL = 'sounds/industrial.ogg'
}

tileAmbience: GameAmbience {
    sfxURL = 'sounds/tile.ogg'
}

utilityCorridorAmbience: GameAmbience {
    sfxURL = 'sounds/utilitycorridor.ogg'
}

serverRoomAmbience: GameAmbience {
    sfxURL = 'sounds/serverroom.ogg'
}

southeastAmbience: GameAmbience {
    sfxURL = 'sounds/southeast.ogg'
}

commonRoomAmbience: GameAmbience {
    sfxURL = 'sounds/commonroom.ogg'
}

assemblyShopLabAAmbience: GameAmbience {
    sfxURL = 'sounds/assemblylaba.ogg'
}

deliveryRoomAmbience: GameAmbience {
    sfxURL = 'sounds/deliveryroom.ogg'
}

reservoirCorridorAmbience: GameAmbience {
    sfxURL = 'sounds/rescorr.ogg'
    drownOutFactor = 50
}

reservoirControlRoomAmbience: GameAmbience {
    sfxURL = 'sounds/rescontrol.ogg'
    drownOutFactor = 75
}

reservoirTopAmbience: GameAmbience {
    sfxURL = 'sounds/waterfall.ogg'
    drownOutFactor = 90
}

reservoirBottomAmbience: GameAmbience {
    sfxURL = 'sounds/reservoir.ogg'
    drownOutFactor = 25
}

strainerStageAmbience: GameAmbience {
    sfxURL = 'sounds/strainer.ogg'
    drownOutFactor = 25
}

lifeSupportAmbience: GameAmbience {
    sfxURL = 'sounds/lifesupport.ogg'
    drownOutFactor = 75
}

ventNodeAmbience: GameAmbience {
    sfxURL = 'sounds/ventnode.ogg'
    drownOutFactor = 25
}

cloneQuartersAmbience: GameAmbience {
    sfxURL = 'sounds/commonroom.ogg'
    volume = 25
}

class GameSFX: object {
    sfxURL = ''
    volume = 100

    // How resistant is this sound to dampening?
    antiDrowningFactor = 0
}

modify Room {
    ambienceObject = tileAmbience

    travelerEntering(traveler, origin) {
        inherited(traveler, origin);
        if (transMusicPlayer.allowSFX) {
            if (gPlayerChar.isOrIsIn(traveler)) {
                setFullAmbience();
            }
        }
    }

    setFullAmbience() {
        say(
            '<SOUND CANCEL=AMBIENT
            FADEOUT=' + sfxPlayer.fadetime + '>'
        );
        sfxPlayer.setAmbience(ambienceObject);
        setAmbience();
    }

    setAmbience() {
        //
    }
}

recoverAmbience() {
    if (gPlayerChar == nil) {
        sfxPlayer.setAmbience(nil);
        return;
    }
    local rm = gPlayerChar.getOutermostRoom();
    if (rm == nil) {
        sfxPlayer.setAmbience(nil);
        return;
    }
    rm.setFullAmbience();
}

replace cls() {
    aioClearScreen();
    musicPlayer.recoverSong();
    recoverAmbience();
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
            recoverAmbience();
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
            recoverAmbience();
        }

        return ret;
    }
}