Bunkbed: Fixture { 'bunkbed;bunk bottom;bed cot mattress mattresses'
    "A twin-tier bunkbed with two simple mattresses.
    There's enough space under it to hide. "

    betterStorageHeader

    dobjFor(ParkourClimbOverInto) asDobjFor(Board)
    dobjFor(Climb) asDobjFor(Board)
    dobjFor(Board) {
        remap = remapOn
    }

    dobjFor(Enter) {
        remap = remapOn
    }

    dobjFor(SlideUnder) {
        remap = remapUnder
    }

    dobjFor(GetOutOf) {
        remap = (gActor.isIn(remapUnder) ? remapUnder : remapOn)
    }

    doAfterGoUnder() {
        // Author implementation
    }

    reportAfterGoUnder() {
        "{I} crawl{s/ed} under {the dobj}. ";
    }

    canBonusReachUnderDuring(obj, action) {
        // Author implementation
    }

    finalizeSearchUnder(searchAction) {
        // Author implementation
    }
}

DefineDistSubComponentFor(BunkbedRemapOn, Bunkbed, remapOn)
    betterStorageHeader
    canLieOnMe = true
    isEnterable = true
    isBoardable = true
    isClimbable = true

    dobjFor(ParkourClimbOverInto) asDobjFor(Board)
    dobjFor(Climb) asDobjFor(Board)
;

DefineDistSubComponentFor(BunkbedRemapUnder, Bunkbed, remapUnder)
    betterStorageHeader
    canSlideUnderMe = true
    isHidingSpot = true

    postCreate(_lexParent) {
        // Transfer hidden items
        if (_lexParent.hiddenUnder.length > 0) {
            hiddenUnder = [];
            for (local i = 1; i <= _lexParent.hiddenUnder.length; i++) {
                local hiddenItem = _lexParent.hiddenUnder[i];
                hiddenUnder += hiddenItem;
            }
            _lexParent.hiddenUnder = [];
        }
    }

    dobjFor(SlideUnder) {
        preCond = [touchObj, actorInStagingLocation]
        verify() {
            if (gActor.isIn(self)) {
                illogicalNow(actorAlreadyOnMsg);
            }
        }
        check() { checkInsert(gActor); }
        action() {
            gActor.actionMoveInto(self);
            lexicalParent.doAfterGoUnder();
        }
        report() {
            lexicalParent.reportAfterGoUnder();
        }
    }

    dobjFor(GetOutOf) {
        verify() {
            if (!gActor.isIn(self)) {
                illogicalNow('{I} {am} not under {the dobj}. ');
            }
        }
    }

    canBonusReachDuring(obj, action) {
        return lexicalParent.canBonusReachUnderDuring(obj, action);
    }

    finalizeSearch(searchAction) {
        lexicalParent.finalizeSearchUnder(searchAction);
    }
;

DefineDistComponentFor(TopBunk, Bunkbed)
    isDecoration = true
    vocab = 'top bunk[weak];;mattress[weak]'
;