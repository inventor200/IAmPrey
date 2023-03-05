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

#define holdActorStorage 100

modify Thing {
    bulk = ((isEnterable || isBoardable) ? 2 : (isDecoration ? 0 : 1))
    bulkCapacity = ((isEnterable || isBoardable) ? holdActorStorage : actorCapacity)
    maxSingleBulk = ((isEnterable || isBoardable) ? holdActorStorage : actorCapacity)

    sightSize = (bulk > 1 ? medium : small)
    soundSize = large
    smellSize = small

    canAttackWithMe = (isTakeable && gDobj == skashek)
    cannotAttackMsg = (gCatMode ?
        'You like to think that you are a <i>merciful</i> ruler. '
        :
        'Maybe a human would do that,
        but {i} {do} not see the tactical benefit. '
    )

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

modify Floor {
    floorActions = [Examine, Search, SearchClose, SearchDistant, LookUnder, TakeFrom]

    cannotLookUnderFloorMsg = 'It is impossible to look under <<theName>>. '

    dobjFor(LookUnder) {
        verify() {
            illogical(cannotLookUnderFloorMsg);
        }
    }
}

#define betterStorageHeader \
    bulkCapacity = holdActorStorage \
    maxSingleBulk = holdActorStorage

modify Surface {
    bulk = 2
    bulkCapacity = actorCapacity
    maxSingleBulk = actorCapacity
}

modify Platform {
    bulk = 2
    betterStorageHeader
    hideFromAll(action) {
        if (isHeldBy(gPlayerChar)) {
            return nil;
        }
        return true;
    }
}

modify Booth {
    bulk = 2
    betterStorageHeader
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
    betterStorageHeader
    isFixed = true
}

class FixedBooth: Booth {
    betterStorageHeader
    isFixed = true
}

HomeHaver template 'vocab' @location? "basicDesc"?;
class HomeHaver: Thing {
    desc() {
        if (isHome()) {
            homeDesc();
            return;
        }
        basicDesc();
    }
    basicDesc = "TODO: Add description. "
    homeDesc = basicDesc
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

    hideFromAll(action) {
        if (isHeldBy(gPlayerChar)) {
            return nil;
        }
        return true;
    }
}

class Chair: HomeHaver, Platform {
    //bulk = 2
    canSitOnMe = true

    dobjFor(SitIn) asDobjFor(SitOn)
}

class Mirror: Decoration {
    vocab = 'mirror'
    desc = "<<gActor.seeReflection(self)>>"
    smashedVocab = 'smashed mirror;broken shattered'
    isSmashed = nil
    decorationActions = [Examine, LookIn]
    isBreakable = true

    confirmSmashed() { }

    dobjFor(LookIn) asDobjFor(Examine)

    dobjFor(Break) {
        verify() {
            if (isSmashed) illogical('It\'s already broken. ');
            if (gActorIsCat) {
                illogical('Your great wisdom advises against breaking the
                    mirror. It\'s best to maintain the illusion of power in
                    your old age. ');
            }
            inherited();
        }
        action() {
            //TODO: Smash mirror
        }
        report() {
            //TODO: Smash mirror
        }
    }
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

mirrorShards: MultiLoc, Decoration {
    vocab = 'shard;partial shattered sharp piece[n] of[prep] mirror[weak];shard chunk'
    desc = "A jagged piece of the smashed mirror, still attached to the frame. "
    ambiguouslyPlural = true

    initialLocationClass = SmashedMirror
    isTakeable = true
    decorationActions = [Examine, Take, TakeFrom]

    takeWarning = 'Your manufactured (but enhanced) instincts kick in.\b
        There are missing chunks already, many of which look like they could have
        been viable knives. From this, you conclude that you are not the first clone
        to think of this idea.\b
        However, <i>he</i> is still alive, which means the previous knife-wielders
        died in their attempts. From this, you conclude that <<gSkashekName>> is
        combat-trained, and/or has prepared defenses against this sort of attack.
        If he sees you with a weapon, then any <q>rules of the game</q> he might
        follow will surely be discarded quickly, and multiple instincts
        refuse to let you walk so blatantly into this deathtrap.\b
        It\'s more tactical to take advantage of his <q>rules</q>. '

    dobjFor(TakeFrom) asDobjFor(Take)
    dobjFor(Take) {
        verify() {
            if (gActorIsPlayer) {
                if (gCatMode) {
                    illogical('You\'ll cut your mouth! ');
                }
                else if (!mirrorShard.gaveWarning && huntCore.difficulty != nightmareMode) {
                    mirrorShard.armWarning = true;
                }
            }
            if (mirrorShard.isDirectlyIn(gActor)) {
                illogicalNow('{I} already {hold} a piece of the mirror. ');
            }
            inherited();
        }
        action() {
            if (mirrorShard.armWarning) {
                say(takeWarning);
                mirrorShard.gaveWarning = true;
                mirrorShard.armWarning = nil;
                gAction.actionFailed = true;
                exit;
            }
            mirrorShard.actionMoveInto(gActor);
        }
        report() {
            if (gActorIsPrey) {
                if (huntCore.difficulty == nightmareMode) {
                    "Might as well. He can't get any <i>more</i> angry.\b";
                }
                else {
                    "<i>Better not get caught,</i> you think to yourself.\b";
                }
            }
            inherited();
        }
    }
}

//TODO: If you are seen with the shard, the game switches to nightmare mode
mirrorShard: Thing { 'shard;partial shattered sharp piece[n] of[prep] mirror[weak];shard chunk'
    "A jagged, reflective piece of a smashed mirror. Mind the sharp edges. "

    gaveWarning = nil
    armWarning = nil
    canCutWithMe = true

    dobjFor(Break) {
        verify() {
            illogical('It\'s already broken. ');
        }
    }
}