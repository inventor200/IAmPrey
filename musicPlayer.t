#include "sounddefs.h"

musicPlayer: InitObject {
    songDuringTurn = nil

    execBeforeMe = [inventorCoreInit]

    execute() {
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
                preferencesCore.remindOfFile();
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

            preferencesCore.writePreferences();
            preferencesCore.remindOfFile();
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

transient sfxPlayer: object {
    fadetime = '2.0'
    currentAmbience = nil
    currentRoom = nil

    soundSequence = static new Vector()

    maxSequenceLength = 3
    hadTravel = nil

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

    setDecorations(room) {
        if (!transMusicPlayer.allowSFX) return;
        if (currentRoom == room) return;

        if (currentRoom != nil) {
            say(
                '<SOUND CANCEL=AMBIENT
                FADEOUT=' + sfxPlayer.fadetime + '>'
            );
        }
        currentRoom = room;

        if (currentRoom == nil) return;

        local decorationsList = valToList(currentRoom.decorativeSFX);

        for (local i = 1; i <= decorationsList.length; i++) {
            local snd = decorationsList[i];
            local sndVolume = snd.volume;
            if (currentAmbience != nil) {
                sndVolume = currentAmbience.getDrownedVolume(snd);
            }
            local probability = snd.probability;
            if (probability == nil) probability = 5;
            say(
                '<SOUND SRC="' + snd.sfxURL + '"
                LAYER=AMBIENT
                RANDOM=' + toString(probability) + '
                VOLUME=' + toString(sndVolume) + '>'
            );
        }
    }

    add(soundSrc, alteredForm?) {
        if (soundSrc == nil) return;
        if (!transMusicPlayer.allowSFX) return;
        local soundObj = soundSrc;
        local impact = nil;
        local profile = nil;
        local preferredForm = alteredForm;

        if (soundObj.ofKind(SoundImpact)) {
            impact = soundObj;
            profile = soundObj.soundProfile;
            if (preferredForm == nil) {
                preferredForm = impact.form;
            }
            soundObj = profile.getSFXObject(preferredForm);
            if (soundObj == nil) return;
        }
        else if (soundObj.ofKind(SoundProfile)) {
            profile = soundObj.soundProfile;
            soundObj = profile.getSFXObject(preferredForm);
            if (soundObj == nil) return;
        }

        if (soundObj.ofKind(DistanceSFX)) {
            soundObj = soundObj.getFromForm(preferredForm);
        }
        
        soundSequence.appendUnique(soundObj);
    }

    runSequence(wasBad) {
        if (!transMusicPlayer.allowSFX) return;
        if (soundSequence.length == 0) {
            if (wasBad) {
                play(badMoveSnd);
            }
            else if (hadTravel) {
                play(travelSnd);
            }
            else {
                play(goodMoveSnd);
            }
            hadTravel = nil;
            return;
        }

        hadTravel = nil;

        local sortedSequence = cloneVector(soundSequence);

        sortedSequence.sort(true, {a, b: a.stackingPriority - b.stackingPriority});

        for (local i = maxSequenceLength; i <= sortedSequence.length; i++) {
            // Keep the order which the sounds were added, but only
            // play the most important ones, according to stackingPriority.
            soundSequence.remove(sortedSequence[i]);
        }

        for (local i = 1; i <= soundSequence.length; i++) {
            play(soundSequence[i], 100, i > 1);
        }

        clearVector(soundSequence);
    }

    play(soundObj, attenuation?, doNotInterrupt?) {
        if (!transMusicPlayer.allowSFX) return;
        
        local sndVolume = soundObj.volume;
        if (currentAmbience != nil) {
            sndVolume = currentAmbience.getDrownedVolume(soundObj);
        }

        if (attenuation == nil) attenuation = 100;
        local attenMult = new BigNumber(attenuation) / new BigNumber(100);
        sndVolume = toInteger(new BigNumber(sndVolume) * attenMult);

        say(
            '<SOUND SRC="' + soundObj.sfxURL + '"
            LAYER=FOREGROUND ' +
            (doNotInterrupt ? '' : 'INTERRUPT ') +
            'VOLUME=' + toString(sndVolume) + '>'
        );
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

modify Room {
    ambienceObject = tileAmbience
    decorativeSFX = nil

    travelerEntering(traveler, origin) {
        inherited(traveler, origin);
        if (transMusicPlayer.allowSFX) {
            if (gPlayerChar.isOrIsIn(traveler)) {
                setFullAmbience(true);
            }
        }
    }

    setFullAmbience(traveled?) {
        sfxPlayer.setAmbience(ambienceObject);
        sfxPlayer.setDecorations(self);
        setAmbience(traveled);
    }

    setAmbience(traveled?) {
        //
    }
}

recoverAmbience() {
    if (gPlayerChar == nil) {
        sfxPlayer.setAmbience(nil);
        sfxPlayer.setDecorations(nil);
        return;
    }
    local rm = gPlayerChar.getOutermostRoom();
    if (rm == nil) {
        sfxPlayer.setAmbience(nil);
        sfxPlayer.setDecorations(nil);
        return;
    }

    rm.setFullAmbience();
}

replace cls() {
    aioClearScreen();
    
    musicPlayer.recoverSong();

    local allowAmbience = true;
    if (musicPlayer.songDuringTurn != nil) {
        if (!musicPlayer.songDuringTurn.allowAmbience) allowAmbience = nil;
    }

    if (allowAmbience) {
        sfxPlayer.currentAmbience = nil;
        sfxPlayer.currentRoom = nil;
        recoverAmbience();
    }
    else {
        sfxPlayer.setAmbience(nil);
        sfxPlayer.setDecorations(nil);
    }
}

clsWithSong(nextSong) {
    #if __ALLOW_CLS
    musicPlayer.songDuringTurn = nextSong;
    cls();
    #else
    changeSong(nextSong);
    #endif
}

// Recommended to always use this instead of playSong(),
// because this will enforce ambient sound rules, too.
changeSong(nextSong) {
    musicPlayer.playSong(nextSong);

    if (!transMusicPlayer.allowSFX) return;

    local allowAmbience = true;
    if (nextSong != nil) {
        if (!nextSong.allowAmbience) allowAmbience = nil;
    }

    if (allowAmbience) {
        recoverAmbience();
    }
    else {
        sfxPlayer.setAmbience(nil);
        sfxPlayer.setDecorations(nil);
    }
}

// For some reason the existence of this function crashed the compiler.
playSFX(soundObj, attenuation?, forbidInterrupt?) {
    sfxPlayer.play(soundObj, attenuation, forbidInterrupt);
}

addSFX(soundSrc, alteredForm?) {
    sfxPlayer.add(soundSrc, alteredForm);
}

#ifdef __ALLOW_DEBUG_ACTIONS
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

finishGameMsgSong(msg, song, extra) {
    if (gameTurnBroker.hadNegativeOutcome) {
        playSFX(badMoveSnd);
    }
    else {
        //TODO: Have a specific victory sound?
        playSFX(goodMoveSnd);
    }
    changeSong(song);
    finishGameMsg(msg, extra);
}