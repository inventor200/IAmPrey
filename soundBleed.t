enum bleedSource, wallMuffle, closeEcho, distantEcho;

soundBleedCore: object {
    soundDaemon = nil
    freshBlood = static new Vector(10) // Newly-spawned sound bleeds go here

    selectedDirection = nil
    selectedConnector = nil
    selectedDestination = nil
    selectedMuffleDestination = nil

    activate() {
        soundDaemon = new Daemon(self, &doBleed, 1);
        soundDaemon.eventOrder = 110;
    }

    createSound(soundProfile, room) {
        local _freshBlood = new SoundBlood(soundProfile, room);
        freshBlood.append(_freshBlood);
    }

    doBleed() {
        //TODO: Move all previously-moved Sounds from sound profiles back to storage

        if (freshBlood.length == 0) return;

        for (local i = 1; i <= freshBlood.length; i++) {
            doBleedFor(freshBlood[i]);
        }

        freshBlood.removeRange(1, -1);
    }

    doBleedFor(currentBlood) {
        propagateRoom(currentBlood.room, currentBlood.soundProfile, bleedSource, 3, nil);
    }

    propagateRoom(room, profile, form, strength, sourceDirection) {
        // If sourceDirection is nil, we are in the source room.

        //TODO: Test for player or hunter

        //TODO: Move a Sound object from the profile to the player room.
        // If it's already moved, and the mode is set to muffle, then skip this step.
        //Debug only:
        if (room == gPlayerChar.getOutermostRoom() && !profile.isFromPlayer) {
            say('\n' + profile.getReportString(form, sourceDirection));
        }

        if (strength == 1) return;

        for (local i = 1; i <= 12; i++) {
            room.selectSoundDirection(i);
            if (selectedMuffleDestination != nil && strength == 3) {
                local nextSourceDir = selectedMuffleDestination.getMuffleDirectionTo(room);
                // If we can send the sound through a wall, then prioritize that.
                // The only other way it could arrive would be a distant echo (2 rooms away),
                // which would have the same strength, but has less priority.
                if (nextSourceDir != nil) {
                    propagateRoom(selectedMuffleDestination, profile, wallMuffle, 1, nextSourceDir);
                }
            }
            else if (selectedDestination != nil) {
                local nextSourceDir = selectedDestination.getDirectionTo(room);
                if (nextSourceDir != nil) {
                    //TODO: Muffle through closed doors
                    local nextStrength = strength - 1;
                    local nextForm = (nextStrength == 2) ? closeEcho : distantEcho;
                    propagateRoom(selectedDestination, profile, nextForm, nextStrength, nextSourceDir);
                }
            }
        }
    }
}

class SoundProfile: object {
    construct(_muffledStr, _closeEchoStr, _distantEchoStr, _isFromPlayer?) {
        muffledStr = _muffledStr;
        closeEchoStr = _closeEchoStr;
        distantEchoStr = _distantEchoStr;
        isFromPlayer = _isFromPlayer;
    }

    muffledStr = 'the muffled sound of a mysterious noise'
    closeEchoStr = 'the nearby echo of a mysterious noise'
    distantEchoStr = 'the distant echo of a mysterious noise'
    isFromPlayer = nil

    getReportString(form, direction) {
        local dirTitle = 'the ' + direction.name;
        if (direction == upDir) dirTitle = 'above';
        if (direction == downDir) dirTitle = 'below';
        if (direction == inDir) dirTitle = 'inside';
        if (direction == outDir) dirTitle = 'outside';

        if (form == wallMuffle) {
            return 'Through a wall to ' + dirTitle +
                ', you hear ' + muffledStr + '. ';
        }
        
        return 'From ' + dirTitle +
            ', you hear ' + (form == closeEcho ? closeEchoStr : distantEchoStr) + '. ';
    }
}

class SoundBlood: object {
    construct(_soundProfile, _room) {
        soundProfile = _soundProfile;
        room = _room;
    }

    soundProfile = nil
    room = nil
}

#define selectSoundDirectionExp(i, dir) \
    case i: \
        soundBleedCore.selectedDirection = dir##Dir; \
        soundBleedCore.selectedDestination = nil; \
        soundBleedCore.selectedConnector = getConnector(&##dir); \
        soundBleedCore.selectedMuffleDestination = dir##Muffle; \
        break

#define searchMuffleDirection(dir) if (dir##Muffle == dest) { return dir##Dir; }

modify Room {
    // A room can be assigned to any of these to create a muffling wall connection
    northMuffle = nil     // 1
    northeastMuffle = nil // 2
    eastMuffle = nil      // 3
    southeastMuffle = nil // 4
    southMuffle = nil     // 5
    southwestMuffle = nil // 6
    westMuffle = nil      // 7
    northwestMuffle = nil // 8
    upMuffle = nil        // 9
    downMuffle = nil      // 10
    inMuffle = nil        // 11
    outMuffle = nil       // 12

    getMuffleDirectionTo(dest) {
        searchMuffleDirection(north);
        searchMuffleDirection(northeast);
        searchMuffleDirection(east);
        searchMuffleDirection(southeast);
        searchMuffleDirection(south);
        searchMuffleDirection(southwest);
        searchMuffleDirection(west);
        searchMuffleDirection(northwest);
        searchMuffleDirection(up);
        searchMuffleDirection(down);
        searchMuffleDirection(in);
        searchMuffleDirection(out);
        return nil;
    }

    selectSoundDirection(dirIndex) {
        switch (dirIndex) {
            selectSoundDirectionExp(1, north);
            selectSoundDirectionExp(2, northeast);
            selectSoundDirectionExp(3, east);
            selectSoundDirectionExp(4, southeast);
            selectSoundDirectionExp(5, south);
            selectSoundDirectionExp(6, southwest);
            selectSoundDirectionExp(7, west);
            selectSoundDirectionExp(8, northwest);
            selectSoundDirectionExp(9, up);
            selectSoundDirectionExp(10, down);
            selectSoundDirectionExp(11, in);
            selectSoundDirectionExp(12, out);
        }

        if (soundBleedCore.selectedConnector != nil) {
            soundBleedCore.selectedDestination = soundBleedCore.selectedConnector.destination();
        }
    }
}