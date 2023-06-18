modify skashek {
    hasSeenPreyOutsideOfDeliveryRoom = nil
    playerLeewayTurns = 0
    peekPOV = nil

    // FIXME: This easter egg is causing weird behavior with the leeway counters.
    // Figure out how to reinstate this later.
    checkDeliveryRoom() {
        if (hasSeenPreyOutsideOfDeliveryRoom) return;
        hasSeenPreyOutsideOfDeliveryRoom = true;
        suppressIdleDescription();
        if (!canSee(getPracticalPlayer())) {
            #if __DEBUG_SKASHEK_ACTIONS
            "\nLoaded message.";
            #endif
            reciteAnnouncement(inspectingDeliveryRoomMessage);
            return;
        }
        if (getPlayerWeapon() != nil) {
            // Do not give leeway to an armed player
            return;
        }
        /*if (huntCore.difficulty == nightmareMode) return;
        playerLeewayTurns = huntCore.difficultySettingObj.turnsBeforeSkashekDeploys;
        prepareSpeech();
        "<.p><q>Um, Prey,</q> <<getPeekHe()>> stammers, <q>I'm not sure if you
        dropped out of the womb correctly, but... Well, you <i>do</i> understand
        that you must run, yeah? I'm <i>planning to eat you</i>, if you do not
        escape the facility first!</q>\b
        He puts his hands on his hips, exasperated.\b
        <q>Okay, let me strike you a deal: I will give you a bit more time
        to get the fuck away from me, and <i>then</i> I will hunt you!
        <<remember>> You need to collect all seven pieces of the environment suit
        to escape! I've hidden them around the place! The timer starts <i>now</i>,
        Prey!</q> ";*/
    }

    canSee(target) {
        local normalResult = inherited(target);
        local player = getPracticalPlayer();
        if (target == player) {
            if (skashekAIControls.isNoTargetMode) return nil;
            local playerLoc = player.location;
            return (normalResult && !playerLoc.isHidingSpot) ||
                huntCore.playerWasSeenHiding;
        }
        return normalResult;
    }

    peekInto(room) {
        _skashekProbe.moveInto(room);
        local spotted = _skashekProbe.canSee(getPracticalPlayer());
        _skashekProbe.moveInto(nil);
        #if __DEBUG_SKASHEK_ACTIONS
        "<.p>
        (Skashek spies into <<room.roomTitle>>...)\n
        <<if spotted>>He sees you!!<<else>>You are hidden!<<end>>
        <.p>";
        #endif
        if (spotted && room != deliveryRoom) {
            hasSeenPreyOutsideOfDeliveryRoom = true;
        }
        return spotted;
    }

    doPerception() {
        #if __DEBUG_SOUND_SKASHEK_SIDE
        if (perceivedSoundImpacts.length > 0) {
            "\bSkashek hears:";
        }
        #endif
        for (local i = 1; i <= perceivedSoundImpacts.length; i++) {
            local impact = perceivedSoundImpacts[i];
            #if __DEBUG_SOUND_SKASHEK_SIDE
            say('\n' + impact.soundProfile.closeEchoStr);
            say('\n\tFrom: ' + impact.sourceOrigin.theName);
            #endif
            skashekAIControls.currentState.doPerception(impact);
        }
        #if __DEBUG_SOUND_SKASHEK_SIDE
        if (perceivedSoundImpacts.length > 0) {
            "\b";
        }
        #endif
        clearVector(perceivedSoundImpacts);
    }

    // Player was seen entering room
    playerWasSeenEntering() {
        if (skashekAIControls.isNoTargetMode) return nil;
        return huntCore.playerWasSeenEntering;
    }

    // Check to see if Skashek notices a door being mysteriously opened
    highlightDoorChange(door) {
        if (skashekAIControls.isNoTargetMode) return;
        if (canSee(door)) {
            setDoorMovingOnItsOwn(door);
        }
        if (door.otherSide != nil) {
            if (canSee(door.otherSide)) {
                setDoorMovingOnItsOwn(door.otherSide);
            }
        }
    }

    setDoorMovingOnItsOwn(door) {
        hasSeenPreyOutsideOfDeliveryRoom = true;
        if (!doesDoorGoToValidDest(door)) return;
        huntCore.doorThatMovedOnItsOwn = door;
    }

    getPlayerWeapon() {
        if (huntCore.difficulty == nightmareMode) return nil;
        local player = getPracticalPlayer();
        if (!canSee(player)) return nil;
        if (mirrorShard.isIn(getPracticalPlayer())) return mirrorShard;
        return nil;
    }

    checkPlayerForWeapon() {
        if (!skashekAIControls.currentState.canMockPlayer()) return;
        local weapon = getPlayerWeapon();
        if (weapon == nil) return;

        punishForWeaponMessage.causeForConcern = weapon;
        hasSeenPreyOutsideOfDeliveryRoom = true;
        reciteAnnouncement(punishForWeaponMessage);

        concludeMockingOpportunity();
    }

    popDoorMovingOnItsOwn() {
        local door = huntCore.doorThatMovedOnItsOwn;
        huntCore.doorThatMovedOnItsOwn = nil;
        return door;
    }
}