/*
 * This is where I do some extra configuration to make my parkour.t and soundBleed.t work with this specific project,
 * with the goal of keeping them modular and reusable.
 */

#if __DEBUG
//
#else
modify screenReaderInit {
    prepForScreenReaders() {
        inherited();
        parkourCache.formatForScreenReader = true;
    }
}
#endif

modify soundBleedCore {
    freeActionPassed() {
        return gWasFreeAction;
    }
}

climbingNoiseProfile: SoundProfile {
    'the muffled racket of something clambering'
    'the nearby racket of something clambering'
    'the distant reverberations of clambering'
    strength = 4

    afterEmission(room) {
        say('\b(Emitted climbing noise in <<room.roomTitle>>.)');
    }
}

impactNoiseProfile: SoundProfile {
    'the muffled <i>thud</i> of something landing on the floor'
    'the echoing <i>thud</i> of something landing on the floor'
    'the distant <i>wump</i> of something landing on the floor'
    strength = 4

    afterEmission(room) {
        say('\b(Emitted impact noise in <<room.roomTitle>>.)');
    }
}

hardImpactNoiseProfile: SoundProfile {
    'the muffled <i>crack</i> of something hitting the floor'
    'the echoing <i>ka-thump</i> of something hitting the floor'
    'the reverberating <i>wump</i> of something hitting the floor'
    strength = 5

    afterEmission(room) {
        say('\b(Emitted hard impact noise in <<room.roomTitle>>.)');
    }
}

/*modify ParkourPlatform {
    getClimbAdvantageReason(preferredQuality) {
        return preferredQuality + ' enough for a quieter approach';
    }

    getJumpRisk() {
        return ', but {i} might make a lot of noise...  ';
    }

    getFallRisk() {
        return ', but {i} might risk injury and make a lot of noise... ';
    }

    getPlummetRisk() {
        return '{I} certainly {cannot} JUMP OFF, without risking death. ';
    }

    handleJumpUpDifficulty(actor) {
        if (actor != gPlayerChar) return;
        soundBleedCore.createSound(climbingNoiseProfile, getOutermostRoom(), true);
    }

    handleJumpDownDifficulty(actor) {
        if (actor != gPlayerChar) return;
        soundBleedCore.createSound(impactNoiseProfile, getOutermostRoom(), true);
    }

    handleLeapDifficulty(actor) {
        if (actor != gPlayerChar) return;
        soundBleedCore.createSound(impactNoiseProfile, getOutermostRoom(), true);
    }

    handleFallDownDifficulty(actor) {
        if (actor != gPlayerChar) return;
        soundBleedCore.createSound(hardImpactNoiseProfile, getOutermostRoom(), true);
    }

    doRepJumpUp(destThing) {
        local obj = destThing;
        gMessageParams(obj);
        "It's noisy, but {i} jump{s/ed} up,
        and clamber{s/ed} <<jumpUpDirPrep>> {the obj}. ";
    }

    doRepJumpDown(destThing) {
        local obj = destThing;
        gMessageParams(obj);
        "It's noisy, but {i} {hold} onto
        <<gParkourTheEdgeName>>,
        drop{s/?ed} to a hanging position,
        {let} go,
        and land{s/ed} hard <<landingDirPrep>> {the obj} below. <<landingConclusionMsg>>";
    }

    doRepLeap(destThing) {
        local obj = destThing;
        gMessageParams(obj);
        "It's noisy, but {i} jump{s/ed} <<leapDirPrep>> {the obj},
        and tr{ies/ied} to keep {my} balance. ";
    }

    doRepFall(destThing) {
        local obj = destThing;
        gMessageParams(obj);
        "{I} {hold} onto <<gParkourTheEdgeName>>,
        drop{s/?ed} to a hanging position,
        and {let} go. The loud impact{dummy} fire{s/d} a sharp,
        lancing pain through {my} bones.
        {I} {am} stunned, but then recover{s/ed}
        after a moment to find {myself}
        <<landingDirPrep>> {the obj}. <<landingConclusionMsg>>";
    }
}*/

defaultLabFloor: Floor { 'the floor'
    //
}

modify Room {
    floorObj = defaultLabFloor
}

class FixedPlatform: Platform {
    isFixed = true
}

modify Inventory {
    turnsTaken = 0
}

modify Examine {
    turnsTaken = 0
}

modify Look {
    turnsTaken = 0
}