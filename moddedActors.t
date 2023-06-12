#define physicalFactorScale 2
#define maxPhysicalFactor (5 * physicalFactorScale)
#define conditionReportDelay 3
#define maxExhaustionInertia 3

modify Actor {
    bulk = actorBulk
    //bulkCapacity = actorCapacity
    bulkCapacity = 2
    maxSingleBulk = 2

    outfit = nil
    lastLocation = nil

    seeReflection(mirror) {
        mirror.confirmSmashed();
        return '{I} {see} a neat-looking creature. ';
    }

    seeShatteredVanity() {
        return '';
    }

    ponderVanity() {
        return '';
    }

    startTheDay() { }

    getClamp(value, max) {
        if (value < 0) value = 0;
        if (value > max) value = max;
        return value;
    }

    soak() { }
    dryOff() { }
    addExhaustion(amount) { }
    updatePhysicalState() { }
    applySweat(exhaustionLevel, wetnessLevel) { }

    moveInto(dest) {
        handleBeforeMove(dest);
        local cachedLastLoc = location;
        inherited(dest);
        if (location != cachedLastLoc) {
            // If we moved, then update our last location
            lastLocation = cachedLastLoc;
            handleMoveInto(lastLocation, dest);
        }
    }

    handleBeforeMove(dest) {
        //
    }

    handleMoveInto(from, to) {
        //
    }
}

class PlayerActor: Actor {
    wetness = 0
    d_wetness = 0
    exhaustion = 0
    oldExhaustion = 0
    exhaustionInertia = 0
    d_exhaustion = 0
    chillFactor = 0
    d_chillFactor = 0
    physicalStateDaemon = nil

    seeReflection(mirror) {
        mirror.confirmSmashed();
        return '{I} {see} a neat-looking creature. ';
    }

    seeShatteredVanity() {
        return '';
    }

    ponderVanity() {
        return '';
    }

    soak() {
        wetness = maxPhysicalFactor;
        d_wetness = maxPhysicalFactor;
    }

    dryOff() {
        wetness = 0;
        d_wetness = 0;
    }

    addExhaustion(amount) {
        oldExhaustion = exhaustion;
        exhaustion = getClamp(exhaustion + amount, maxPhysicalFactor);
        exhaustionInertia = maxExhaustionInertia;
    }

    startTheDay() {
        inherited();
        physicalStateDaemon = new Daemon(self, &updatePhysicalState, 0);
        physicalStateDaemon.eventOrder = 200;
    }

    updatePhysicalState() {
        local om = getOutermostRoom();

        exhaustionInertia = getClamp(exhaustionInertia - 1, maxExhaustionInertia);

        local oldWetness = wetness;
        local oldChillFactor = chillFactor;
        
        wetness = getClamp(wetness + om.moistureFactor, maxPhysicalFactor);
        if (exhaustionInertia <= 0) {
            oldExhaustion = exhaustion;
            exhaustion = getClamp(exhaustion - 1, maxPhysicalFactor);
        }
        if (om.isFreezing) chillFactor = getClamp(
            chillFactor + getClamp(wetness + 1, 2),
            maxPhysicalFactor
        );
        else chillFactor = getClamp(chillFactor - 1, maxPhysicalFactor);

        // Sweating
        applySweat(2, 1);
        applySweat(4, 3);

        d_wetness = wetness - oldWetness;
        d_exhaustion = exhaustion - oldExhaustion;
        d_chillFactor = chillFactor - oldChillFactor;

        oldExhaustion = exhaustion;
    }

    applySweat(exhaustionLevel, wetnessLevel) {
        if (wetness < wetnessLevel * physicalFactorScale &&
            exhaustion >= exhaustionLevel * physicalFactorScale) {
            wetness = wetnessLevel * physicalFactorScale;
        }
    }

    // Player can be seen attempting to hide
    // This value is used to compare against old visibility
    couldSkashekSeeBefore = nil
    previousRoom = nil

    handleBeforeMove(dest) {
        // Was player being stealthy before?
        local hadStealthLastTime =
            location.isHidingSpot && !huntCore.playerWasSeenHiding;
        // Don't bias
        huntCore.playerWasSeenHiding = nil;
        // Rearm Skashek's callout
        skashek.hasSeenPlayerAttemptToHide = nil;
        // Poll visibility before move
        // Account for stealth from before move as well
        couldSkashekSeeBefore = skashek.canSee(self) && !hadStealthLastTime;
        // Track the previous room
        previousRoom = getOutermostRoom();
    }

    handleMoveInto(from, to) {
        // If player intends to hide
        local stayedInRoom = (previousRoom == getOutermostRoom());
        if (to.isHidingSpot || (!skashek.canSee(self) && stayedInRoom)) {
            // They thwart themselves by being caught hiding
            huntCore.playerWasSeenHiding = couldSkashekSeeBefore;
        }
    }
}