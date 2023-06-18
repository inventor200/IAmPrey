enum normalClosingSound, slamClosingSound;

modify Door {
    catFlap = nil
    airlockDoor = nil
    isVentGrateDoor = nil
    closingFuse = nil
    closingDelay = 3

    primedPlayerAudio = nil
    passActionStr = 'enter'
    canSlamMe = true

    doSoundPropagation = true

    pullHandleSide = (airlockDoor)

    // One must be on the staging location to peek through me
    requiresPeekAngle = true

    // What turn does the player expect this to close on?
    playerCloseExpectationFuse = nil
    wasPlayerExpectingAClose = nil
    // What turn does skashek expect this to close on?
    skashekCloseExpectationFuse = nil
    wasSkashekExpectingAClose = nil

    // Airlock-style doors do not close on their own,
    // so expectations are based on previously-witnessed
    // open states.
    playerExpectsAirlockOpen = nil
    skashekExpectsAirlockOpen = nil

    silentDoorRealizationFuse = nil

    allowPeek = (isOpen || hasDistCompCatFlap || isTransparent)

    remappingSearch = true
    remappingLookIn = true

    setForBothSides(prop, stat) {
        self.(prop) = stat;
        if (otherSide != nil) {
            otherSide.(prop) = stat;
        }
    }
}