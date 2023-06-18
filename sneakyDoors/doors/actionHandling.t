modify Door {
    dobjFor(SneakThrough) {
        verify() {
            if ((lockability == lockableWithKey) && !isOpen) {
                illogical('That door is locked. ');
            }
        }
        action() {
            sneakyCore.trySneaking();
            sneakyCore.doSneakStart(self, self);
            doNested(TravelVia, self);
            sneakyCore.doSneakEnd(self);
        }
    }

    dobjFor(Open) {
        verify() {
            if (gActorIsCat && !isVentGrateDoor) {
                illogical('{That subj dobj} {is} too heavy for an old cat to open.<<
                if hasDistCompCatFlap>> That\'s probably why the Royal Subject installed a cat
                flap<<first time>> <i>(cut a ragged square hold into the bottom with
                power tools)</i><<only>>.<<end>> ');
                return;
            }
            inherited();
        }
        action() {
            if (gActorIsPrey) skashek.highlightDoorChange(self);
            inherited();
        }
    }

    dobjFor(Close) {
        verify() {
            if (gActorIsCat) {
                illogical(catCloseMsg);
                return;
            }
            if (qualifiesForCloseTrick()) {
                if (!isOpen) {
                    illogical(cannotSlamClosedDoorMsg);
                    return;
                }
                if (huntCore.pollTrick(&closeDoorCount) == noTricksRemaining) {
                    illogical(closeDoorDeniedMsg);
                    return;
                }
            }
            inherited();
        }
        action() {
            if (qualifiesForCloseTrick()) {
                extraReport('<.p>(with a bit more urgency)\n');
                doInstead(SlamClosed, self);
                return;
            }
            if (gActorIsPrey) skashek.highlightDoorChange(self);
            primedPlayerAudio = nil;
            inherited();
        }
        report() {
            if (gActorIsPlayer && !airlockDoor) {
                "{I} gently close{s/d} the door,
                so that it{dummy} {do} makes very little sound. ";
                addSFX(doorShutCarefulSnd);
            }
            else {
                inherited();
            }
        }
    }

    dobjFor(SlamClosed) {
        verify() {
            if (gActorIsCat) {
                illogical(catCloseMsg);
                return;
            }
            if (!isOpen) {
                illogicalNow(cannotSlamClosedDoorMsg);
            }
            if (qualifiesForCloseTrick()) {
                if (huntCore.pollTrick(&closeDoorCount) == noTricksRemaining) {
                    illogical(closeDoorDeniedMsg);
                    return;
                }
            }
            inherited();
        }
        action() {
            local qualifies = qualifiesForCloseTrick();
            if (canSlamMe || qualifies) {
                if (gActorIsPrey) {
                    setForBothSides(&wasPlayerExpectingAClose, true);
                }
                else {
                    setForBothSides(&wasSkashekExpectingAClose, true);
                }
                slam();
                if (qualifies) {
                    //huntCore.spendTrick(&closeDoorCount);
                    spendCloseTrick();
                }
                else if (gActorIsPrey) {
                    // This is skipped if door is slammed in face,
                    // because that's not worth a comment.
                    skashek.highlightDoorChange(self);
                }
            }
            else {
                extraReport('<.p>(simply closing, as {that dobj} cannot be slammed)\n');
                doInstead(Close, self);
            }
        }
    }

    dobjFor(GoThrough) { // Assume the cat is using the cat flap
        preCond = (getCatAccessibility())
    }

    dobjFor(PeekInto) asDobjFor(LookThrough)
    dobjFor(LookIn) asDobjFor(LookThrough)
    dobjFor(PeekAround) asDobjFor(LookThrough)
    dobjFor(LookThrough) {
        remap = (isOpen ? nil : (hasDistCompCatFlap ? catFlap : nil))
        verify() {
            if (!allowPeek) {
                illogical('{I} {cannot} peek through an opaque door. ');
            }
        }
        action() { }
        report() {
            handlePeekThrough('through {the dobj}');
        }
    }
}