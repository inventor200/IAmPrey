#define physicalFactorScale 2
#define maxPhysicalFactor (5 * physicalFactorScale)
#define conditionReportDelay 3
#define maxExhaustionInertia 3
#define actorCapacity 10

modify Actor {
    bulk = 25
    bulkCapacity = actorCapacity
    maxSingleBulk = 2

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

    getClamp(value, max) {
        if (value < 0) value = 0;
        if (value > max) value = max;
        return value;
    }

    applySweat(exhaustionLevel, wetnessLevel) {
        if (wetness < wetnessLevel * physicalFactorScale &&
            exhaustion >= exhaustionLevel * physicalFactorScale) {
            wetness = wetnessLevel * physicalFactorScale;
        }
    }
}