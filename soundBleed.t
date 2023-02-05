enum bleedSource, wallMuffle, closeEcho, distantEcho;

soundBleedCore: object {
    envSounds = static new Vector(16) // Non-player sounds go here
    envSoundRooms = static new Vector(16) // Aligned room vector so new objects are not created
    playerSounds = static new Vector(16) // Player sounds go here
    playerSoundRooms = static new Vector(16) // Aligned room vector so new objects are not created

    propagatedRooms = static new Vector(64)

    selectedDirection = nil
    selectedConnector = nil
    selectedDestination = nil
    selectedMuffleDestination = nil

    propagationPlayerPerceivedStrength = 0
    detectedSourceRoom = nil

    createSound(soundProfile, room, causedByPlayer?) {
        if (causedByPlayer) {
            if (playerSounds.indexOf(soundProfile) == nil) {
                playerSounds.append(soundProfile);
                playerSoundRooms.append(room);
            }
        }
        else {
            if (envSounds.indexOf(soundProfile) == nil) {
                envSounds.append(soundProfile);
                envSoundRooms.append(room);
            }
        }
    }

    doPropagation() {
        if (envSounds.length == 0 && playerSounds.length == 0) return;
        
        if (envSounds.length > 0) {
            for (local i = 1; i <= envSounds.length; i++) {
                envSounds[i].afterEmission(envSoundRooms[i]);
                doPropagationForPlayer(envSounds[i], envSoundRooms[i]);
            }
            envSounds.removeRange(1, -1);
            envSoundRooms.removeRange(1, -1);
        }

        if (playerSounds.length > 0) {
            for (local i = 1; i <= playerSounds.length; i++) {
                playerSounds[i].afterEmission(playerSoundRooms[i]);
                doPropagationForSkashek(playerSounds[i], playerSoundRooms[i]);
            }
            playerSounds.removeRange(1, -1);
            playerSoundRooms.removeRange(1, -1);
        }
    }

    doPropagationForPlayer(soundProfile, startRoom) {
        // If the sound comes from the same room that the player is in,
        // then we should have provided this sound directly by now.
        if (startRoom == gPlayerChar.getOutermostRoom()) return;
        
        propagationPlayerPerceivedStrength = 0;
        propagateRoomForPlayer(startRoom, soundProfile, bleedSource, 3, nil);
        clearRooms();
    }

    doPropagationForSkashek(soundProfile, startRoom) {
        detectedSourceRoom = nil;
        propagateRoomForSkashek(startRoom, soundProfile, soundProfile.strength, nil);
        clearRooms();
    }

    checkPropagationStep(room, strength) {
        if (room.highestSoundStrength < strength) {
            room.highestSoundStrength = strength;
            propagatedRooms.appendUnique(room);
            return true;
        }

        return nil;
    }

    clearRooms() {
        if (propagatedRooms.length == 0) return;

        for (local i = 1; i <= propagatedRooms.length; i++) {
            propagatedRooms[i].highestSoundStrength = 0;
        }

        propagatedRooms.removeRange(1, -1);
    }

    propagateRoomForPlayer(room, profile, form, strength, sourceDirection) {
        if (room == gPlayerChar.getOutermostRoom()) {
            // Only reveal to the player if it wasn't heard louder before
            if (propagationPlayerPerceivedStrength < strength) {
                propagationPlayerPerceivedStrength = strength;

                local throughDoor = nil;
                if (sourceDirection != nil) {
                    local sourceConnector = room.(sourceDirection.dirProp);
                    if (sourceConnector != nil) {
                        throughDoor = sourceConnector.isOpenable;
                    }
                }

                profile.doPlayerPerception(form, sourceDirection, throughDoor);
            }
        }

        if (strength == 1) return;

        local priorityFlag = nil;

        if (strength == 3) {
            // Muffle through walls propagation
            for (local i = 1; i <= 12; i++) {
                room.selectSoundDirection(i);
                if (selectedMuffleDestination != nil) {
                    local nextSourceDir = selectedMuffleDestination.getMuffleDirectionTo(room);
                    // If we can send the sound through a wall, then prioritize that.
                    // The only other way it could arrive would be a distant echo (2 rooms away),
                    // which would have the same strength, but has less priority.
                    if (nextSourceDir != nil) {
                        // We are faking strengths:
                        // 1 = distant echo
                        // 2 = through wall
                        // 3 = through closed door
                        // 4 = close echo
                        // 5 = source
                        if (!checkPropagationStep(selectedMuffleDestination, 2)) continue;
                        
                        propagateRoomForPlayer(selectedMuffleDestination, profile, wallMuffle, 1, nextSourceDir);
                        priorityFlag = true; // Gets priority.
                    }
                }
            }
        }

        if (priorityFlag) return;

        if (strength >= 2) {
            // Muffle through closed doors propagation
            for (local i = 1; i <= 12; i++) {
                room.selectSoundDirection(i);
                if (selectedDestination != nil) {
                    local nextSourceDir = selectedDestination.getDirectionTo(room);
                    if (nextSourceDir != nil) {
                        if (selectedConnector.isOpenable) {
                            if (!selectedConnector.isOpen) {
                                if (!checkPropagationStep(selectedDestination, 3)) continue;

                                propagateRoomForPlayer(selectedDestination, profile, wallMuffle, 1, nextSourceDir);
                                priorityFlag = true; // Gets priority.
                            }
                        }
                    }
                }
            }
        }

        if (priorityFlag) return;

        // Echo propagation
        for (local i = 1; i <= 12; i++) {
            room.selectSoundDirection(i);
            if (selectedDestination != nil) {
                local nextSourceDir = selectedDestination.getDirectionTo(room);
                if (nextSourceDir != nil) {
                    local nextStrength = strength - 1;
                    local fakeNextStrength = nextStrength;
                    if (fakeNextStrength > 1) fakeNextStrength += 2;

                    if (!checkPropagationStep(selectedDestination, fakeNextStrength)) continue;

                    local nextForm = (nextStrength == 2) ? closeEcho : distantEcho;
                    propagateRoomForPlayer(selectedDestination, profile, nextForm, nextStrength, nextSourceDir);
                }
            }
        }
    }

    propagateRoomForSkashek(room, profile, strength, sourceDirection) {
        //TODO: Test for Skashek

        if (strength > 1) {
            for (local i = 1; i <= 12; i++) {
                room.selectSoundDirection(i);

                local nextStrength = strength - 2;

                if (selectedMuffleDestination != nil && strength > 2) {
                    local nextSourceDir = selectedMuffleDestination.getMuffleDirectionTo(room);
                    if (nextSourceDir != nil) {
                        if (!checkPropagationStep(selectedMuffleDestination, nextStrength)) continue;

                        propagateRoomForSkashek(selectedMuffleDestination, profile, nextStrength, nextSourceDir);
                    }
                }

                if (selectedDestination != nil) {
                    local nextSourceDir = selectedDestination.getDirectionTo(room);
                    if (nextSourceDir != nil) {
                        local falloff = 1;

                        if (selectedConnector.isOpenable) {
                            if (!selectedConnector.isOpen) {
                                falloff = 2;
                                if (strength <= falloff) continue;
                            }
                        }

                        nextStrength = strength - falloff;

                        if (!checkPropagationStep(selectedDestination, nextStrength)) continue;

                        propagateRoomForSkashek(selectedDestination, profile, nextStrength, nextSourceDir);
                    }
                }
            }
        }
    }
}

SoundProfile template 'muffledStr' 'closeEchoStr' 'distantEchoStr';

class SoundProfile: object {
    strength = 3
    muffledStr = 'the muffled sound of a mysterious noise'
    closeEchoStr = 'the nearby echo of a mysterious noise'
    distantEchoStr = 'the distant echo of a mysterious noise'
    subtleSound = nil

    doPlayerPerception(form, sourceDirection, throughDoor) {
        local reportStr = getReportString(form, sourceDirection, throughDoor);
        if (subtleSound == nil) {
            // Direct perception
            say('\n' + reportStr);
        }
        else {
            // LISTEN perception only
            subtleSound.perceiveIn(gPlayerChar.getOutermostRoom(), reportStr);
        }
    }

    getReportString(form, sourceDirection, throughDoor) {
        local dirTitle = 'the ' + sourceDirection.name;
        if (sourceDirection == upDir) dirTitle = 'above';
        if (sourceDirection == downDir) dirTitle = 'below';
        if (sourceDirection == inDir) dirTitle = 'inside';
        if (sourceDirection == outDir) dirTitle = 'outside';

        local routeSetup = throughDoor ? 'Through a doorway to ' : 'From ';

        if (form == wallMuffle) {
            routeSetup = throughDoor ? 'Through a closed door to ' : 'Through a wall to ';
            return routeSetup + dirTitle +
                ', you hear ' + muffledStr + '. ';
        }
        
        return routeSetup + dirTitle +
            ', you hear ' + (form == closeEcho ? closeEchoStr : distantEchoStr) + '. ';
    }

    afterEmission(room) {
        // For debug purposes.
    }
}

SubtleSound template 'basicName' 'missedMsg'?;

//FIXME: Work this into the freeTurnCore system
class SubtleSound: Noise {
    construct() {
        vocab = basicName + ';muffled distant nearby;echo';
        if (location != nil) {
            if (location.ofKind(SoundProfile)) {
                location.subtleSound = self;
            }
            location = nil;
        }
        inherited();
    }
    desc() {
        attemptPerception();
    }
    listenDesc() {
        attemptPerception();
    }

    basicName = 'mysterious noise'
    caughtMsg = '{I} hear{s/d} a mysterious sound. ' // Automatically generated
    missedMsg = 'The sound seems to have stopped. ' // Author-made

    wasPerceived = nil

    lifecycleFuse = nil

    doAfterPerception() {
        // For setting off actions based on player observation
    }

    perceiveIn(room, _caughtMsg) {
        moveInto(room);
        caughtMsg = _caughtMsg;
        wasPerceived = nil;
        setupFuse();
    }

    attemptPerception() {
        if (wasPerceived) {
            say(missedMsg);
            doAfterPerception();
            endLifecycle();
        }
        else {
            say(caughtMsg);
            wasPerceived = true;
        }
    }

    setupFuse() {
        if (lifecycleFuse != nil) lifecycleFuse.removeEvent();
        lifecycleFuse = new Fuse(self, &checkLifecycle, 1);
    }

    checkLifecycle() {
        if (!wasPerceived) {
            endLifecycle();
        }
        lifecycleFuse = nil;
    }

    endLifecycle() {
        moveInto(nil);
    }
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

    highestSoundStrength = 0

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