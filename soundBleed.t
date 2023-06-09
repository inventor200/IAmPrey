enum bleedSource, wallMuffle, closeEcho, distantEcho;
#define gThroughDoorPriority 3

#ifdef __DEBUG
#define __DEBUG_SOUND_PLAYER_SIDE nil
#define __DEBUG_IGNORE_FAKE_SOUNDS nil
#define __DEBUG_SOUND_SKASHEK_SIDE nil
#define __SHOW_EMISSION_STARTS nil
#else
#define __DEBUG_SOUND_PLAYER_SIDE nil
#define __DEBUG_IGNORE_FAKE_SOUNDS nil
#define __DEBUG_SOUND_SKASHEK_SIDE nil
#define __SHOW_EMISSION_STARTS nil
#endif

soundBleedCore: object {
    envSoundEmissions = static new Vector(16)
    playerSoundEmissions = static new Vector(16)

    propagatedRooms = static new Vector(64)

    activeSubtleSounds = static new Vector(16)

    selectedDirection = nil
    selectedConnector = nil
    selectedDestination = nil
    selectedMuffleDestination = nil

    soundStartRoom = nil
    goalRoom = nil
    propagationPerceivedStrength = 0
    currentSoundImpact = nil

    // Rooms linked with a shared audio region typically do not create
    // falloff, but the Loading Area shares 2 regions, and becomes a
    // sort of extreme audio amplifier, so this bool value alternates
    // after every propagation through a shared audio region, creating
    // the effect of 50% less falloff, but SOME falloff still happens.
    everyOtherCounter = nil

    addEmission(vec, soundProfile, soundSource, room) {
        for (local i = 1; i <= vec.length; i++) {
            if (vec[i].isIdenticalToStart(
                soundProfile, soundSource, room)) {
                return;
            }
        }
        vec.append(new SoundImpact(
            soundProfile,
            soundSource,
            room
        ));
    }

    createSound(soundProfile, emitter, room, causedByPlayer) {
        local soundSource = emitter.getSoundSource();
        addEmission(
            causedByPlayer ? playerSoundEmissions : envSoundEmissions,
            soundProfile,
            soundSource,
            room
        );
    }

    doPropagation() {
        for (local i = 1; i <= activeSubtleSounds.length; i++) {
            activeSubtleSounds[i].checkLifecycle();
        }

        if (envSoundEmissions.length == 0 && playerSoundEmissions.length == 0) return;
        
        if (envSoundEmissions.length > 0) {
            for (local i = 1; i <= envSoundEmissions.length; i++) {
                local emission = envSoundEmissions[i];
                #if __SHOW_EMISSION_STARTS
                emission.soundProfile.afterEmission(emission.sourceLocation);
                #endif
                currentSoundImpact = emission;
                doPropagationForPlayer(emission.soundProfile, emission.sourceLocation);
            }
            envSoundEmissions.removeRange(1, -1);
            gPlayerChar.doPerception();
        }

        if (playerSoundEmissions.length > 0) {
            for (local i = 1; i <= playerSoundEmissions.length; i++) {
                local emission = playerSoundEmissions[i];
                #if __SHOW_EMISSION_STARTS
                emission.afterEmission(emission.sourceLocation);
                #endif
                currentSoundImpact = emission;
                doPropagationForSkashek(emission.soundProfile, emission.sourceLocation);
            }
            playerSoundEmissions.removeRange(1, -1);
            skashek.doPerception();
        }
    }

    doPropagationForPlayer(soundProfile, startRoom) {
        if (startRoom == nil) {
            // Sounds do not travel in a void.
            return;
        }
        goalRoom = gPlayerChar.getOutermostRoom();
        // Putting this here, because some calls are trying
        // to start somewhere other than a room:
        startRoom = startRoom.getOutermostRoom();
        if (startRoom == nil) {
            "<.p>What? You're seeing a startRoom error!<.p>";
            return;
        }
        // If the sound comes from the same room that the player is in,
        // then we should have provided this sound directly by now.
        if (startRoom == gPlayerChar.getOutermostRoom()) return;
        
        propagationPerceivedStrength = 0;
        #if __DEBUG_SOUND_PLAYER_SIDE
        "<.p>(Propagating into <<startRoom.roomTitle>>)<.p>";
        #endif
        soundStartRoom = startRoom;
        propagateRoomForPlayer(startRoom, soundProfile, bleedSource, soundProfile.strength, nil);
        clearRooms();
    }

    doPropagationForSkashek(soundProfile, startRoom) {
        if (startRoom == nil) {
            // Sounds do not travel in a void.
            return;
        }
        goalRoom = skashek.getOutermostRoom();
        soundStartRoom = startRoom;
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

        everyOtherCounter = nil;

        propagatedRooms.removeRange(1, -1);
    }

    propagateRoomForPlayer(room, profile, form, strength, sourceDirection) {
        if (room == goalRoom) {
            #if __DEBUG_SOUND_PLAYER_SIDE
            "<.p>(Found player in <<room.roomTitle>>)<.p>";
            #endif
            // Only reveal to the player if it wasn't heard louder before
            if (propagationPerceivedStrength < strength) {
                propagationPerceivedStrength = strength;

                local throughDoor = nil;
                if (sourceDirection != nil) {
                    local sourceConnector = room.(sourceDirection.dirProp);
                    if (sourceConnector != nil) {
                        #if __DEBUG_SOUND_PLAYER_SIDE
                        if (sourceConnector.isOpenable) {
                            "\n(Player hears through door)";
                        }
                        #endif
                        throughDoor = sourceConnector.isOpenable;
                    }
                }

                currentSoundImpact.sourceDirection = sourceDirection;
                currentSoundImpact.form = form;
                
                #if __DEBUG_SOUND_PLAYER_SIDE
                "\n(Players hears as a <<currentSoundImpact.getFormString()>>)";
                #endif

                currentSoundImpact.throughDoor = throughDoor;
                currentSoundImpact.strength = strength;
                currentSoundImpact.priority = getPriorityFromForm(form, throughDoor);
                gPlayerChar.addSoundImpact(currentSoundImpact, &priorityStrength);
            }
            // It doesn't matter if we were accepted; we just got there
            return;
        }

        // The sound is too quiet to continue
        if (strength <= 1) return;
        // Do not propagate muffles beyond a single room
        if (form == wallMuffle) return;

        for (local i = 1; i <= 12; i++) {
            room.selectSoundDirection(i);
            local nextSourceDir = nil;
            local falloff = 2;

            // 0 = Normal
            // 1 = Door muffle
            // 2 = Wall muffle
            local propagationMode = 0;

            // Only wall-muffle from sound start room with sufficient volume
            if (selectedMuffleDestination != nil && strength >= 3 && soundStartRoom == room) {
                // Muffle through walls propagation
                nextSourceDir = selectedMuffleDestination.getMuffleDirectionTo(room);
                propagationMode = 2;
            }
            else if (selectedDestination != nil) {
                nextSourceDir = selectedDestination.getDirectionTo(room);
                if (nextSourceDir != nil) {
                    if (strength >= 2) {
                        if (selectedConnector.isOpenable) {
                            if (!(selectedConnector.isOpen || selectedConnector.isVentGrateDoor)) {
                                propagationMode = 1;
                                if (selectedConnector.airlockDoor) {
                                    continue;
                                }
                            }
                        }
                    }
                }

                // Otherwise the propagationMode will be 0
                if (propagationMode == 0) {
                    falloff = room.canHearOutTo(selectedDestination)
                        ? (everyOtherCounter ? 1 : 0) : 1;
                    everyOtherCounter = !everyOtherCounter;
                }
            }

            if (nextSourceDir == nil) continue;

            local checkDestination = nil;
            local nextStrength = propagationMode == 2 ? 1 : (strength - falloff);

            checkDestination = propagationMode == 2
                ? selectedMuffleDestination : selectedDestination;

            if (!checkPropagationStep(checkDestination, nextStrength)) continue;

            #if __DEBUG_SOUND_PLAYER_SIDE
            switch (propagationMode) {
                default:
                    // Normal propagation
                    "<.p>(Echoing into <<selectedDestination.roomTitle>>)<.p>";
                    break;
                case 1:
                    // Muffle through doors propagation
                    "<.p>(Door-muffling into <<selectedDestination.roomTitle>>)<.p>";
                    break;
                case 2:
                    // Muffle through walls propagation
                    "<.p>(Muffling into <<selectedMuffleDestination.roomTitle>>)<.p>";
                    break;
            }
            #endif

            local nextForm = propagationMode == 0 ? form : wallMuffle;
            if (nextForm == bleedSource) nextForm = closeEcho;

            // Was "propagationMode != 0", which is weird...
            if (falloff > 0 && propagationMode == 0) {
                nextForm = distantEcho;

                if (form == closeEcho || form == bleedSource) {
                    if (nextStrength >= profile.getCloseStrength()) {
                        // If the signal is clean enough
                        nextForm = closeEcho;
                    }
                }
            }

            propagateRoomForPlayer(checkDestination, profile, nextForm, nextStrength, nextSourceDir);
        }
    }

    propagateRoomForSkashek(room, profile, strength, sourceDirection) {
        if (room == goalRoom) {
            // Only reveal to Skashek if it wasn't heard louder before
            if (propagationPerceivedStrength < strength) {
                propagationPerceivedStrength = strength;

                currentSoundImpact.strength = strength;
                skashek.addSoundImpact(currentSoundImpact, &strength);
            }
            // It doesn't matter if we were accepted; we just got there
            return;
        }

        if (strength <= 1) return;
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
                        if (!(selectedConnector.isOpen || selectedConnector.isVentGrateDoor)) {
                            falloff = 2;
                            if (strength <= falloff || selectedConnector.airlockDoor) {
                                continue;
                            }
                        }
                    }
                    else {
                        falloff = room.canHearOutTo(selectedDestination)
                            ? (everyOtherCounter ? 1 : 0) : 1;
                        everyOtherCounter = !everyOtherCounter;
                    }

                    nextStrength = strength - falloff;

                    if (!checkPropagationStep(selectedDestination, nextStrength)) continue;

                    propagateRoomForSkashek(selectedDestination, profile, nextStrength, nextSourceDir);
                }
            }
        }
    }

    getDirIndexFromDir(dir) {
        switch (dir) {
            default:
                return nil;
            case northDir:
                return 1;
            case northeastDir:
                return 2;
            case eastDir:
                return 3;
            case southeastDir:
                return 4;
            case southDir:
                return 5;
            case southwestDir:
                return 6;
            case westDir:
                return 7;
            case northwestDir:
                return 8;
            case upDir:
                return 9;
            case downDir:
                return 10;
            case inDir:
                return 11;
            case outDir:
                return 12;
        }
    }

    // PRIORITIES:
    // Source       = 5
    // Wall muffle  = 4
    // Door muffle  = 3
    // Close echo   = 2
    // Distant echo = 1
    // Nothing      = 0

    getPriorityFromForm(form, throughDoor) {
        switch (form) {
            default:
                return 0;
            case distantEcho:
                return 1;
            case wallMuffle:
                return throughDoor ? gThroughDoorPriority : 4;
            case closeEcho:
                return 2;
            case bleedSource:
                return 5;
        }
    }

    getFormFromPriority(priority) {
        switch (priority) {
            default:
                return nil;
            case 1:
                return distantEcho;
            case 4:
            case gThroughDoorPriority:
                return wallMuffle;
            case 2:
                return closeEcho;
            case 5:
                return bleedSource;
        }
    }

    getReportStringHeader(form, sourceDirection, throughDoor) {
        local dirTitle = 'the ' + sourceDirection.name;
        if (sourceDirection == upDir) dirTitle = 'above';
        if (sourceDirection == downDir) dirTitle = 'below';
        if (sourceDirection == inDir) dirTitle = 'inside';
        if (sourceDirection == outDir) dirTitle = 'outside';

        local routeSetup = throughDoor ? 'Through a doorway to ' : 'From ';

        if (form == wallMuffle) {
            routeSetup = throughDoor ? 'Through a closed door to ' : 'Through a wall to ';
        }
        
        return routeSetup + dirTitle + ', {i} hear ';
    }
}

modify Thing {
    // Returns the representative of sounds we cause
    getSoundSource() {
        return self;
    }
}

modify Door {
    soundSourceRepresentative = nil

    preinitThing() {
        inherited();
        if (soundSourceRepresentative == nil) {
            // Arbitrarily agree on a source representative
            if (otherSide != nil) {
                if (otherSide.soundSourceRepresentative != nil) {
                    // otherSide has already made its decision
                    // so we must play along
                    soundSourceRepresentative =
                        otherSide.soundSourceRepresentative;
                }
                else {
                    // otherSide has not yet decided,
                    // so we take charge
                    soundSourceRepresentative = self;
                    otherSide.soundSourceRepresentative = self;
                }
            }
            else {
                // There is no otherSide.
                // Anarchy in Adv3Lite!
                soundSourceRepresentative = self;
            }
        }
    }

    getSoundSource() {
        return soundSourceRepresentative;
    }
}

// Used for sorting and prioritizing sound perceptions
class SoundImpact: object {
    construct(soundProfile_, sourceOrigin_, sourceLocation_) {
        soundProfile = soundProfile_;
        sourceOrigin = sourceOrigin_;
        sourceLocation = sourceLocation_;
    }

    soundProfile = nil
    form = nil
    sourceOrigin = nil
    sourceLocation = nil
    sourceDirection = nil
    throughDoor = nil
    strength = 0
    priority = 0
    priorityStrength = ((priority << 4) + strength)

    isIdenticalToStart(soundProfile_, sourceOrigin_, sourceLocation_) {
        if (soundProfile != soundProfile_) return nil;
        if (sourceOrigin != sourceOrigin_) return nil;
        if (sourceLocation != sourceLocation_) return nil;
        return true;
    }

    isIdenticalToImpact(otherImpact) {
        if (soundProfile != otherImpact.soundProfile) return nil;
        if (sourceOrigin != otherImpact.sourceOrigin) return nil;
        return true;
    }

    setSourceBuffer() {
        soundProfile.sourceBuffer = sourceOrigin;
        if (soundProfile.isSuspicious) {
            soundProfile.lastSuspicionTarget = sourceOrigin;
        }
    }

    impactPlayer() {
        setSourceBuffer();

        #if __SHOW_EMISSION_STARTS
        "<.p>Impacting with form of <<getFormString()>>,
        through <<throughDoor ? 'door' : 'other'>>.<.p>";
        #endif

        addSFX(self);

        soundProfile.doPlayerPerception(
            form, sourceDirection, throughDoor
        );
    }

    doSubtleSound() {
        setSourceBuffer();
        soundProfile.subtleSound.perceiveIn(
            gPlayerChar.getOutermostRoom(),
            sourceDirection,
            soundProfile.getReportString(form, sourceDirection, throughDoor),
            self
        );
    }

    getFormString() {
        switch (form) {
            default:
                return 'bleedSource';
            case closeEcho:
                return 'closeEcho';
            case distantEcho:
                return 'distantEcho';
            case wallMuffle:
                return 'wallMuffle';
        }
    }

    getStrengthDebug() {
        return 'S: <<strength>>/<<soundProfile.getCloseStrength()>>;
        P: <<priority>>; PS: <<priorityStrength>>; F: <<getFormString()>>';
    }
}

modify Actor {
    perceivedSoundImpacts = perInstance(new Vector(16))

    addSoundImpact(impact, sortProp) {
        for (local i = 1; i <= perceivedSoundImpacts.length; i++) {
            local otherImpact = perceivedSoundImpacts[i];
            // We are only interested in matches
            if (!impact.isIdenticalToImpact(otherImpact)) continue;
            // Another one is already handling it better
            if (impact.(sortProp) <= otherImpact.(sortProp)) return;
            // We could handle it better
            perceivedSoundImpacts[i] = impact;

            #if __SHOW_EMISSION_STARTS
            "<.p><<theName>> heard that better!\n(<<impact.getStrengthDebug()>>)<.p>";
            #endif

            return;
        }

        // No conflicts at all; add it
        perceivedSoundImpacts.append(impact);
        #if __SHOW_EMISSION_STARTS
        "<.p><<theName>> heard that.\n(<<impact.getStrengthDebug()>>)<.p>";
        #endif
    }

    doPerception() {
        if (gPlayerChar == self) {
            doPlayerPerception();
        }
        if (perceivedSoundImpacts.length > 0) {
            perceivedSoundImpacts.removeRange(1, -1);
        }
    }

    doPlayerPerception() {
        #if __SHOW_EMISSION_STARTS
        "<.p><<theName>>.perceivedSoundImpacts: <<perceivedSoundImpacts.length>><.p>";
        #endif
        // Try simple stuff first...
        if (perceivedSoundImpacts.length == 0) return;
        say('<.p>');
        if (perceivedSoundImpacts.length == 1) {
            local impact = perceivedSoundImpacts[1];
            if (impact.soundProfile.subtleSound != nil) {
                impact.doSubtleSound();
            }
            else {
                impact.impactPlayer();
            }
            return;
        }

        // Otherwise, sort stuff...

        // Prepare to group stuff by direction
        local impactsByDir = new Vector(12);
        local formsByDir = new Vector(12);

        // Initialize vectors
        for (local i = 1; i <= 12; i++) {
            impactsByDir.append(nil);
            formsByDir.append(0);
        }

        // Sort
        for (local i = 1; i <= perceivedSoundImpacts.length; i++) {
            local impact = perceivedSoundImpacts[i];

            // Subtle sounds have thing-based handling,
            // so we handle these individually.
            if (impact.soundProfile.subtleSound != nil) {
                impact.doSubtleSound();
                continue;
            }

            // If requested, we will show these alone
            if (impact.soundProfile.isSuspicious) {
                impact.impactPlayer();
                continue;
            }

            local formPriority =
                soundBleedCore.getPriorityFromForm(impact.form, impact.throughDoor);

            if (formPriority == 0 || formPriority == 5) {
                // We shouldn't be handling these here
                continue;
            }

            local dirIndex =
                soundBleedCore.getDirIndexFromDir(impact.sourceDirection);

            if (dirIndex == nil) {
                impact.impactPlayer();
                continue;
            }

            local dirVec = impactsByDir[dirIndex];
            if (dirVec == nil) {
                dirVec = new Vector(3);
                impactsByDir[dirIndex] = dirVec;
            }
            dirVec.append(impact);

            if (formPriority > formsByDir[dirIndex]) {
                formsByDir[dirIndex] = formPriority;
            }
        }

        // Build
        for (local i = 1; i <= 12; i++) {
            local dirVec = impactsByDir[i];
            if (dirVec == nil) continue;

            if (dirVec.length == 1) {
                local impact = dirVec[1];
                impact.impactPlayer();
                continue;
            }

            // Setup group...
            local strBfr = new StringBuffer((dirVec.length + 2)*2);
            local sourceDirection = dirVec[1].sourceDirection;
            local priority = formsByDir[i];
            local form = soundBleedCore.getFormFromPriority(priority);
            local throughDoor = priority == gThroughDoorPriority;
            strBfr.append(soundBleedCore.getReportStringHeader(
                form, sourceDirection, throughDoor
            ));

            for (local j = 1; j <= dirVec.length; j++) {
                local impact = dirVec[j];
                impact.setSourceBuffer();
                local descString = impact.soundProfile.getDescString(form);
                addSFX(impact, form);
                strBfr.append(descString);
                if (j == dirVec.length - 1) {
                    strBfr.append(', and ');
                }
                else if (j < dirVec.length - 1) {
                    strBfr.append(', ');
                }
            }

            strBfr.append('.');

            say(toString(strBfr));
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
    isSuspicious = nil
    lastSuspicionTarget = nil
    sourceBuffer = nil // Set just before print
    sourceName = (sourceBuffer == nil ? 'something' : sourceBuffer.name)
    theSourceName = (sourceBuffer == nil ? 'something' : sourceBuffer.theName)
    absoluteDesc = nil

    muffledSFXObject = nil
    closeEchoSFXObject = nil
    distantSFXObject = nil

    doPlayerPerception(form, sourceDirection, throughDoor) {
        local reportStr = getReportString(form, sourceDirection, throughDoor);
        if (subtleSound == nil) {
            // Direct perception
            say('\n' + reportStr);
        }
        else {
            // LISTEN perception only
            subtleSound.perceiveIn(
                gPlayerChar.getOutermostRoom(),
                sourceDirection, reportStr,
                getSFXObject(form)
            );
        }
    }

    getReportString(form, sourceDirection, throughDoor) {
        if (absoluteDesc) {
            return getDescString(form);
        }
        local dirTitle = 'the ' + sourceDirection.name;
        if (sourceDirection == upDir) dirTitle = 'above';
        if (sourceDirection == downDir) dirTitle = 'below';
        if (sourceDirection == inDir) dirTitle = 'inside';
        if (sourceDirection == outDir) dirTitle = 'outside';

        local routeSetup = throughDoor ? 'Through a doorway to ' : 'From ';

        if (form == wallMuffle) {
            routeSetup = throughDoor ? 'Through a closed door to ' : 'Through a wall to ';
            return routeSetup + dirTitle +
                ', {i} hear ' + muffledStr + (isSuspicious ? ' ' : '. ');
        }
        
        return routeSetup + dirTitle +
            ', {i} hear ' + (form == closeEcho ? closeEchoStr : distantEchoStr) + (isSuspicious ? ' ' : '. ');
    }

    getDescString(form) {
        switch (form) {
            case wallMuffle:
                return muffledStr;
            case closeEcho:
                return closeEchoStr;
            default:
                return distantEchoStr;
        }
    }

    getSFXObject(form) {
        switch (form) {
            case wallMuffle:
                return muffledSFXObject;
            case closeEcho:
                return closeEchoSFXObject;
            default:
                return distantSFXObject;
        }
    }

    getCloseStrength() {
        local halfPoint = strength >> 1;
        if (halfPoint < 1) halfPoint = 1;
        local closePoint = strength - halfPoint;
        return (closePoint < 2 ? 2 : closePoint);
    }

    afterEmission(room) {
        // For debug purposes.
    }
}

SubtleSound template 'basicName' 'missedMsg'? 'extraAlts'?;

class SubtleSound: Noise {
    construct() {
        if (extraAlts == nil) extraAlts = '';
        else extraAlts = ' ' + extraAlts;
        vocab = basicName + ';muffled distant nearby;echo' + extraAlts;
        if (location != nil) {
            if (location.ofKind(SoundProfile)) {
                location.subtleSound = self;
            }
            location = nil;
        }
        soundBleedCore.activeSubtleSounds.append(self);
        inherited();
    }
    desc() {
        attemptPerception();
    }
    listenDesc() {
        attemptPerception();
    }

    basicName = 'mysterious noise'
    extraAlts = nil
    caughtMsg = '{I} hear{s/d} a mysterious sound. ' // Automatically generated
    missedMsg = 'The sound seems to have stopped. ' // Author-made
    soundSrc = nil

    wasPerceived = nil

    lifecycleFuse = nil
    isBroadcasting = nil
    isSuspicious = nil
    lastDirection = nil
    perceptionDelay = 0

    doAfterPerception() {
        // For setting off actions based on player observation
    }

    perceiveIn(room, dir, _caughtMsg, _soundSrc) {
        moveInto(room);
        caughtMsg = _caughtMsg;
        soundSrc = _soundSrc;
        wasPerceived = nil;
        isBroadcasting = true;
        lastDirection = dir;
        perceptionDelay = 1;
    }

    attemptPerception() {
        if (wasPerceived) {
            say(missedMsg);
            doAfterPerception();
            endLifecycle();
        }
        else {
            say(caughtMsg);
            addSFX(soundSrc);
            wasPerceived = true;
        }
    }

    checkLifecycle() {
        if (!isBroadcasting) return;
        if (perceptionDelay > 0) {
            perceptionDelay--;
            return;
        }
        if (!wasPerceived) {
            endLifecycle();
        }
        isBroadcasting = nil;
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