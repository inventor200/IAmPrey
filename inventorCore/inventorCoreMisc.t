VerbRule(Lick)
    ('lick'|'mlem') singleDobj
    : VerbProduction
    action = Lick
    verbPhrase = 'lick/licking (what)'
    missingQ = 'what do you want to lick'
;

DefineTAction(Lick)
    turnsTaken = (Taste.turnsTaken)
;

modify VerbRule(Inventory)
    'i' | 'inv' | 'inventory' | ('take'|'check') 'inventory' | 'check' 'pockets':
;

modify Thing {
    dobjFor(Lick) asDobjFor(Taste)

    findSurfaceUnder() {
        local surface = location;

        if (surface.ofKind(Room)) {
            return surface.floorObj;
        }

        if (surface.contType == In && surface.enclosing) {
            return surface;
        }

        local masterSurface = surface;
        while (masterSurface.ofKind(SubComponent)) {
            masterSurface = masterSurface.lexicalParent;
        }

        if (surface.contType == On) {
            return masterSurface;
        }

        return masterSurface.findSurfaceUnder();
    }

    examineSurfaceUnder() {
        local xTarget = findSurfaceUnder();
        if (xTarget != nil) {
            "(examining <<xTarget.theName>>)\n";
            doInstead(Examine, xTarget);
        }
        else {
            "{I} {see} nothing under {the dobj}. ";
        }
    }

    registerLookUnderSuccess() {
        // Implemented in better search
    }

    registerLookUnderFailure() {
        // Implemented in better search
    }
}

modify Actor {
    dobjFor(LookIn) asDobjFor(Search)
    dobjFor(Search) {
        verify() {
            if (gPlayerChar != self) {
                inaccessible('{The dobj}{dummy} will not let {me} search {him dobj}. ');
            }
            else {
                logical;
            }
        }
        check() { }
        action() {
            doInstead(Inventory);
        }
        report() { }
    }

    dobjFor(LookUnder) {
        verify() { }
        check() { }
        action() {
            examineSurfaceUnder();
        }
        report() { }
    }
}

modify Room {
    canLookUnderFloor = nil
}

modify Floor {
    decorationActions = (getFloorActions())

    getFloorActions() {
        return [Examine, Search, LookUnder, TakeFrom];
    }

    cannotLookUnderFloorMsg = 'It is impossible to look under <<theName>>. '

    dobjFor(LookUnder) {
        verify() {
            if (!gPlayerChar.outermostVisibleParent().canLookUnderFloor) {
                illogical(cannotLookUnderFloorMsg);
            }
            else {
                inherited();
            }
        }
    }
}