class Mirror: Decoration {
    vocab = 'mirror'
    desc = "<<gActor.seeReflection(self)>>"
    smashedVocab = 'smashed mirror;broken shattered'
    isSmashed = nil
    decorationActions = [Examine, LookIn]
    isBreakable = true

    confirmSmashed() { }

    remappingLookIn = true
    dobjFor(LookIn) asDobjFor(Examine)

    dobjFor(Break) {
        verify() {
            if (isSmashed) illogical('It\'s already broken. ');
            if (gActorIsCat) {
                illogical('{My} great wisdom advises against breaking the
                    mirror. It\'s best to maintain the <i>illusion</i> of power in
                    {my} old age, and save {my} energy for more urgent matters. ');
            }
            illogical('{I} would not gain anything from that. A shard could be
                a knife, but attacking <<gSkashekName>> with a knife has
                not worked out for previous Prey clones. He must have some
                kind of reliable defense. The less-costly option is to escape. ');
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

mirrorShards: MultiLoc, FakePlural, Decoration {
    vocab = 'shards;partial shattered sharp piece[n] of[prep] mirror[weak] glass one[weak] of[prep];shard chunks chunk glass'
    desc = "A jagged piece of the smashed mirror, still attached to the frame. "
    fakeSingularPhrase = 'shard'

    initialLocationClass = SmashedMirror
    isTakeable = true
    decorationActions = [Examine, Take, TakeFrom]

    takeWarning = '{My} manufactured (but enhanced) instincts kick in.\b
        There are missing chunks already, many of which look like they could have
        been viable knives. From this, {i} conclude that {i} {am} not the first clone
        to think of this idea.\b
        However, <i>he</i> is still alive, which means the previous knife-wielders
        died in their attempts. From this, {i} deduce that <<gSkashekName>> is
        combat-trained, and/or has prepared defenses against this sort of attack.
        If he{dummy} sees {me} with a weapon, then all <q>rules of the game</q>
        will be quickly discarded. <i>Many</i> of {my} instincts{dummy}
        refuse to let {me} walk so blatantly into this deathtrap.\b
        It\'s more tactical to take advantage of his <q>rules</q>. '

    dobjFor(TakeFrom) asDobjFor(Take)
    dobjFor(Take) {
        verify() {
            if (gActorIsPlayer) {
                if (gCatMode) {
                    illogical('{I}\'ll cut {my} mouth! ');
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
                    "<i>Better not get caught,</i> {i} think to {myself}.\b";
                }
            }
            inherited();
        }
    }
}

mirrorShard: Thing { 'shard;partial shattered sharp piece[n] of[prep] mirror[weak] glass;shard chunk glass'
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