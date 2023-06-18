catFlapNotificationCounter: object {
    count = 4
}

DefineDistComponentFor(CatFlap, Door)
    vocab = 'cat flap;pet kitty;door[weak] catflap petflap catdoor kittydoor'

    getMiscInclusionCheck(obj, normalInclusionCheck) {
        return normalInclusionCheck && (obj.lockability == notLockable) && !obj.airlockDoor;
    }

    subReferenceProp = &catFlap

    desc = "A ragged, square hole that has been cut into the bottom of the thick, industrial
    door. It must have required a combination of incredible power tools, <i>lots</i> of
    free time, and a radiant, heartfelt fondness for a certain cat."

    isDecoration = true
    decorationActions = [Examine, GoThrough, Enter, PeekThrough, LookThrough, PeekInto, LookIn, Search]

    canGoThroughMe = true
    requiresPeekAngle = true

    dobjFor(Enter) {
        remap = lexicalParent
    }
    dobjFor(GoThrough) {
        remap = lexicalParent
    }

    remappingSearch = true
    remappingLookIn = true
    dobjFor(PeekInto) asDobjFor(LookThrough)
    dobjFor(LookIn) asDobjFor(LookThrough)
    dobjFor(LookThrough) {
        preCond = [actorHasPeekAngle]
        verify() {
            logical;
        }
        action() { }
        report() {
            handleCustomPeekThrough(
                lexicalParent.otherSide.getOutermostRoom(),
                'through the cat flap of <<lexicalParent.theName>>'
            );
        }
    }

    locType() {
        return Outside;
    }
;