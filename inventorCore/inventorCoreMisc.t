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

modify Floor {
    pleaseIgnoreMe = true
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

// Define other decorative walls to complement a specific wall
#define otherWallVocabFor(directionList) \
    vocab = perInstance( \
        self.getOtherWallsVocab(directionList) \
    ) \
    matchPhrases = perInstance( \
        self.getWallMatchPhrases(directionList, true) \
    )

// Use this if you want to include a special term for the adjectives list
#define otherWallPartVocabFor(directionList, specificPartAdj) \
    vocab = perInstance( \
        self.getOtherWallsVocab(directionList, specificPartAdj) \
    ) \
    matchPhrases = perInstance( \
        self.getWallMatchPhrases(directionList, true) \
    )

// Use if these walls are in one specific room, in particular
class SpecificWalls: FakePlural, Thing {
    vocab = 'walls;north n south s east e west w northeast ne northwest nw southeast se southwest sw one[weak] of[prep];wall'
    desc = "{I} {see} nothing special about <<theName>>. "
    fakeSingularPhrase = 'wall'
    useOneOfThe = nil
    matchPhrases = ['wall', 'walls']
    isFixed = true
    isDecoration = true
    pleaseIgnoreMe = true
    
    decorationActions = (getWallActions())

    // Used in parkour
    omitFromStagingError() {
        return nil;
    }

    getWallActions() {
        return [Examine];
    }

    // In case we implement a wall that actually IS important,
    // then make sure the surrounding walls are not being a problem
    vocabLikelihood = -100
    filterResolveList(np, cmd, mode) {
        if (np.matches.length > 1) {
            np.matches = np.matches.subset({m: m.obj != self});
        }
    }

    getWallMatchPhrases(directionList, handleOthers?) {
        local lst = [];
        local dirLst = valToList(directionList);

        for (local i = 1; i <= dirLst.length; i++) {
            local dir = dirLst[i];
            local name = dir.name + ' ';
            local abbreviation = dir.name.substr(1, 1) + ' ';
            lst += (name + 'wall');
            lst += (abbreviation + 'wall');
        }

        if (handleOthers) {
            lst += 'walls';
        }
        else {
            lst += 'wall';
        }

        return lst;
    }

    getOtherWallsVocab(directionList, specificPartAdj?) {
        local dirLst = valToList(directionList);
        local partAdjStr = toString(specificPartAdj);
        if (partAdjStr.length > 0) partAdjStr += ' ';

        local strBfr = new StringBuffer(20);

        strBfr.append('walls;');

        for (local i = 1; i <= dirLst.length; i++) {
            local dir = dirLst[i];
            local name = dir.name + ' ';
            local abbreviation = dir.name.substr(1, 1) + ' ';
            strBfr.append(name);
            strBfr.append(abbreviation);
        }

        strBfr.append(partAdjStr);
        strBfr.append('other');

        return toString(strBfr);
    }
}

// Use for generic walls
class Walls: MultiLoc, SpecificWalls {
    initialLocationClass = Room
    
    isInitiallyIn(obj) { return obj.wallsObj == self; }
}

class Ceiling: MultiLoc, Thing {
    vocab = 'ceiling'
    desc = "{I} {see} nothing special about <<theName>>. "
    notImportantMsg = '{That dobj} {is} too far{dummy} above {me}. '
    isFixed = true
    isDecoration = true
    initialLocationClass = Room
    pleaseIgnoreMe = true
    
    isInitiallyIn(obj) { return obj.ceilingObj == self; }
    decorationActions = (getCeilingActions())

    omitFromStagingError() {
        return nil;
    }

    getCeilingActions() {
        return [Examine];
    }
}

class Atmosphere: MultiLoc, Thing {
    vocab = 'air;;atmosphere breeze wind'
    desc = "{I} {see} nothing special about <<theName>>. "
    feelDesc = "{I} {feel} nothing special about <<theName>>. "
    smellDesc = "{I} smell{s/ed} nothing special about <<theName>>. "
    isFixed = true
    isDecoration = true
    initialLocationClass = Room
    pleaseIgnoreMe = true
    
    isInitiallyIn(obj) { return obj.atmosphereObj == self; }
    decorationActions = (getAtmosphereActions())   

    getAtmosphereActions() {
        return [Examine, SmellSomething, Feel];
    }   
}

defaultWalls: Walls;

defaultCeiling: Ceiling;

defaultAtmosphere: Atmosphere;

modify Room {
    floorObj = defaultGround
    wallsObj = defaultWalls
    ceilingObj = defaultCeiling
    atmosphereObj = defaultAtmosphere
    canLookUnderFloor = nil
    
    dobjFor(LookIn) asDobjFor(Search)
    dobjFor(LookThrough) asDobjFor(Search)
    dobjFor(Search) {
        verify() {
            illogical('{I} will have to be more specific,
                and search specific containers instead. ');
        }
    }

    dobjFor(LookUnder) {
        remap = floorObj
    }

    roomBeforeAction() {
        if (gActionIs(Smell)) {
            doInstead(SmellSomething, atmosphereObj);
            exit;
        }

        inherited();
    }
}