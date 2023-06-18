modify Thing {
    requiresPeekAngle = nil
    skipHandle = nil

    dobjFor(SneakThrough) {
        verify() {
            illogical('{That dobj} {is} not something to sneak through. ');
        }
    }

    dobjFor(PeekThrough) asDobjFor(LookThrough)
    dobjFor(PeekInto) asDobjFor(LookIn)

    dobjFor(LookThrough) {
        preCond = [actorHasPeekAngle, containerOpen]
    }

    dobjFor(LookIn) {
        preCond = [objVisible, touchObj, actorHasPeekAngle, containerOpen]
    }

    dobjFor(SlamClosed) {
        preCond = [touchObj]
        remap = ((!isCloseable && remapIn != nil && remapIn.isCloseable) ? remapIn : self)
        verify() {
            if (!isCloseable) {
                illogical(cannotCloseMsg);
            }
            if (!isOpen) {
                illogicalNow(alreadyClosedMsg);
            }
            logical;
        }
        check() { }
        action() {
            extraReport('({I} {don\'t need} to slam {that dobj}.)\n');
            doNested(Close, self);
        }
        report() { }
    }

    wasRead = nil

    dobjFor(Open) {
        report() {
            if (gActorIsCat) {
                "After gingerly whapping {him dobj} with {my} paws,
                {I} finally open{s/ed} <<gActionListStr>>. ";
                return;
            }
            inherited();
        }
    }

    dobjFor(Close) {
        report() {
            if (gActorIsCat) {
                "After careful taps with {my} paws,
                {I} manage{s/d} to close <<gActionListStr>>. ";
                return;
            }
            inherited();
        }
    }

    dobjFor(Read) {
        action() {
            if (self != catNameTag && gActorIsCat) {
                "The strange hairless citizens make odd chants while
                staring at these odd shapes, sometimes for hours
                at a time. {I'm} not sure what <i>this</i> particular
                example would do to them, but {i} resent it anyway.";
            }
            else {
                if (propType(&readDesc) == TypeNil) {
                    say(cannotReadMsg);
                }
                else {
                    display(&readDesc);
                    if (!wasRead) {
                        huntCore.revokeFreeTurn();
                    }
                    wasRead = true;
                }
            }
        }
    }
}