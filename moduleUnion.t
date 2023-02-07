/*
 * This is where I do some extra configuration to make my parkour.t and soundBleed.t work with this specific project,
 * with the goal of keeping them modular and reusable.
 */

climbingNoiseProfile: SoundProfile {
    'the muffled racket of something clambering'
    'the nearby racket of something clambering'
    'the distant reverberations of clambering'
    strength = 3

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

modify parkourCore {
    certifyDiscovery(actor, path) {
        huntCore.revokeFreeTurn();
    }
}

modify Thing {
    doJumpPunishment(actor, traveler, path) {
        if (gCatMode) return; // Cats are silent!
        if (path.direction == parkourDownDir) {
            soundBleedCore.createSound(
                impactNoiseProfile,
                traveler.getOutermostRoom(),
                actor == gPlayerChar
            );
        }
        else {
            soundBleedCore.createSound(
                climbingNoiseProfile,
                traveler.getOutermostRoom(),
                actor == gPlayerChar
            );
        }
    }

    doHarmfulPunishment(actor, traveler, path) {
        if (gCatMode) return; // Cats are silent!
        soundBleedCore.createSound(
            hardImpactNoiseProfile,
            traveler.getOutermostRoom(),
            actor == gPlayerChar
        );
    }
}

defaultLabFloor: Floor { 'the floor'
    //
}

modify Room {
    floorObj = defaultLabFloor
}

class FixedPlatform: Platform {
    isFixed = true
}