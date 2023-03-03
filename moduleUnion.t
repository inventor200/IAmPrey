/*
 * This is where I do some extra configuration to make my parkour.t and soundBleed.t work with this specific project,
 * with the goal of keeping them modular and reusable.
 */

climbingNoiseProfile: SoundProfile {
    'the muffled racket of something clambering'
    'the nearby racket of something clambering'
    'the distant reverberations of clambering'
    strength = 2

    afterEmission(room) {
        //say('\b(Emitted climbing noise in <<room.roomTitle>>.)');
    }
}

impactNoiseProfile: SoundProfile {
    'the muffled <i>thud</i> of something landing on the floor'
    'the echoing <i>thud</i> of something landing on the floor'
    'the distant <i>wump</i> of something landing on the floor'
    strength = 3

    afterEmission(room) {
        //say('\b(Emitted impact noise in <<room.roomTitle>>.)');
    }
}

hardImpactNoiseProfile: SoundProfile {
    'the muffled <i>crack</i> of something hitting the floor'
    'the echoing <i>ka-thump</i> of something hitting the floor'
    'the reverberating <i>wump</i> of something hitting the floor'
    strength = 3

    afterEmission(room) {
        //say('\b(Emitted hard impact noise in <<room.roomTitle>>.)');
    }
}

/*modify parkourCore {
    certifyDiscovery(actor, path) {
        if (gActor != gPlayerChar) return;
        if (gAction.turnsTaken > 0) return;
        huntCore.revokeFreeTurn();
    }
}*/

modify actorInStagingLocation {
    spendImplicitTurn() {
        if (gActor != gPlayerChar) return;
        if (gAction.turnsTaken > 0) return;
        huntCore.revokeFreeTurn();
    }
}

modify Thing {
    bulk = (isDecoration ? 0 : 1)

    sightSize = (bulk > 1 ? medium : small)
    soundSize = large
    smellSize = small

    doClimbPunishment(actor, traveler, path) {
        actor.addExhaustion(1);
    }

    doJumpPunishment(actor, traveler, path) {
        actor.addExhaustion(2);

        if (gCatMode && actor == gPlayerChar) return; // Cats are silent!
        if (path.direction == parkourDownDir) {
            soundBleedCore.createSound(
                impactNoiseProfile,
                getSoundSource(),
                traveler.getOutermostRoom(),
                actor == gPlayerChar
            );
        }
        else {
            soundBleedCore.createSound(
                climbingNoiseProfile,
                getSoundSource(),
                traveler.getOutermostRoom(),
                actor == gPlayerChar
            );
        }
    }

    doHarmfulPunishment(actor, traveler, path) {
        actor.addExhaustion(3);

        if (gCatMode && actor == gPlayerChar) return; // Cats are silent!
        soundBleedCore.createSound(
            hardImpactNoiseProfile,
            getSoundSource(),
            traveler.getOutermostRoom(),
            actor == gPlayerChar
        );
    }
}

#define holdActorStorage 100
#define holdsActors \
    bulkCapacity = holdActorStorage \
    maxSingleBulk = holdActorStorage

class ActorContainer: Thing {
    holdsActors
}

modify Platform {
    holdsActors

    hideFromAll(action) {
        if (isHeldBy(gPlayerChar)) {
            return nil;
        }
        return true;
    }
}

modify Booth {
    holdsActors

    hideFromAll(action) {
        if (isHeldBy(gPlayerChar)) {
            return nil;
        }
        return true;
    }
}

modify Door {
    sightSize = large
}

class FixedPlatform: Platform {
    isFixed = true
}

class FixedBooth: Booth {
    isFixed = true
}

Chair template 'vocab' @location? "basicDesc"?;
class Chair: Platform {
    desc() {
        if (isHome()) {
            chairDesc();
            return;
        }
        basicDesc();
    }
    basicDesc = "TODO: Add description. "
    chairDesc = basicDesc
    bulk = 2
    canSitOnMe = true
    home = nil
    backHomeMsg = '{I} {put} {the dobj} back where it belongs. '

    setHome() {
        home = location;
    }

    isHome() {
        if (isHeldBy(gPlayerChar)) return nil;
        if (home == nil) return true;
        return location == home;
    }

    dobjFor(Take) {
        action() {
            setHome();
            inherited();
        }
    }

    dobjFor(TakeFrom) {
        action() {
            setHome();
            inherited();
        }
    }

    dobjFor(Drop) {
        report() {
            if (location == home) {
                say(backHomeMsg);
            }
            else {
                inherited();
            }
        }
    }

    dobjFor(SitIn) asDobjFor(SitOn)
}

class Mirror: Decoration {
    vocab = 'mirror'
    desc = "<<gActor.seeReflection(self)>>"
    smashedVocab = ''
    isSmashed = nil
    decorationActions = [Examine, LookIn]

    confirmSmashed() { }

    dobjFor(LookIn) asDobjFor(Examine)
}

class SmashedMirror: Mirror {
    vocab = 'mirror;smashed broken shattered'
    desc = "<<gActor.seeShatteredVanity()
        >>The mirror is smashed, though most of it still remains.
        <<gActor.seeReflection(self)>><<
        gActor.seeShatteredVanity()>>"
    smashedVocab = 'smashed mirror;broken shattered'
    isSmashed = true
    seenSmashed = nil

    confirmSmashed() {
        if (isSmashed && !seenSmashed) {
            seenSmashed = true;
            replaceVocab(smashedVocab);
        }
    }
}