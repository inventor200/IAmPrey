administrationAudioRegion: SenseRegion {
    canSeeAcross = nil
    canHearAcross = true
    canSmellAcross = true
    canTalkAcross = true
    canThrowAcross = nil
    autoGoTo = nil
}

#define populateCubicle(cubicleName) \
+cubicleName##Desk: FixedPlatform { \
    vocab = 'desk;office cubicle;table' \
    desc = "TODO: Add description. " \
} \
++LowFloorHeight; \
+cubicleName##FilingCabinet: FilingCabinet { \
    topDrawer: TopCabinetDrawer { } \
    middleDrawer: MiddleCabinetDrawer { } \
    bottomDrawer: BottomCabinetDrawer { } \
    remapOn: FilingCabinetRemapOn { } \
    remapIn: FilingCabinetRemapIn { } \
} \
++HighFloorHeight;

//Search order!!!
#define standardCubicleDesc "TODO: Add description. "
class Cubicle: Room {
    out = administration

    regions = [administrationAudioRegion]
}

class FakeCubicle: Passage {
    otherSide = destination
    attachPeakingAbility('in {the dobj}')
}

class FilingCabinetRemapOn: SubComponent {
    isBoardable = true
    betterStorageHeader
}

class FilingCabinetRemapIn: SubComponent {
    isOpenable = nil
    isOpen = true
    bulkCapacity = 0
    maxSingleBulk = 0

    getDrawer(index) {
        return lexicalParent.getDrawer(index);
    }

    dobjFor(Open) {
        verify() { }
        check() { }
        action() {
            for (local i = 1; i <= 3; i++) {
                local drawer = getDrawer(i);
                if (!drawer.isOpen) tryImplicitAction(Open, drawer);
            }
            "<.p>Done. ";
        }
        report() { }
    }

    dobjFor(Close) {
        verify() { }
        check() { }
        action() {
            for (local i = 1; i <= 3; i++) {
                local drawer = getDrawer(i);
                if (drawer.isOpen) tryImplicitAction(Close, drawer);
            }
            "<.p>Done. ";
        }
        report() { }
    }

    dobjFor(LookIn) {
        action() {
            for (local i = 1; i <= 3; i++) {
                local drawer = getDrawer(i);
                tryImplicitAction(Open, drawer);
                if (i > 1) "\b";
                "(searching in <<drawer.theName>>)\n";
                searchCore.clearHistory();
                doNested(LookIn, drawer);
            }
        }
    }

    iobjFor(PutIn) {
        verify() { }
        check() { }
        action() {
            local chosenDrawer = nil;
            for (local i = 1; i <= 3; i++) {
                local drawer = getDrawer(i);
                chosenDrawer = drawer;
                if (i > 1) "\b";
                else "\n";
                extraReport('(perhaps in <<drawer.theName>>?)\n');
                if (!drawer.isOpen) {
                    extraReport('(first opening <<drawer.theName>>)\n');
                    drawer.makeOpen(true);
                }
                if (gOutStream.watchForOutput({: drawer.checkIobjPutIn() }) != nil) {
                    chosenDrawer = nil;
                }
                if (chosenDrawer != nil) break;
            }
            if (chosenDrawer == nil) {
                "<.p>It{dummy} seem{s/ed} like none of the drawers{plural}
                {is} suitable for {that dobj}. ";
                exit;
            }
            doNested(PutIn, gDobj, chosenDrawer);
        }
        report() { }
    }

    iobjFor(TakeFrom) {
        //remap = nil
        //verify() { }
        //check() { }
        action() {
            for (local i = 1; i <= 3; i++) {
                local drawer = getDrawer(i);
                if (gDobj.isIn(drawer)) {
                    extraReport('\n(taking from <<drawer.theName>>)\n');
                    doNested(TakeFrom, gDobj, drawer);
                    return;
                }
            }
        }
        report() { }
    }

    notionalContents() {
        local nc = [];
        
        for (local i = 1; i <= 3; i++) {
            local drawer = getDrawer(i);
            if (drawer.isOpen || drawer.isTransparent) {
                nc = nc + drawer.contents;
            }
        }
        
        return nc;
    }
}

class FilingCabinet: Fixture {
    vocab = 'filing cabinet;office paper papers metal'
    desc = "TODO: Add description.
        This will have individual drawers in the full release. "
    
    betterStorageHeader
    topDrawer = nil
    middleDrawer = nil
    bottomDrawer = nil

    getDrawer(index) {
        switch(index) {
            default:
                return topDrawer;
            case 2:
                return middleDrawer;
            case 3:
                return bottomDrawer;
        }
    }

    doMultiSearch() {
        "(searching the top of <<theName>>)\n";
        searchCore.clearHistory();
        doNested(SearchClose, remapOn);
        doubleCheckGenericSearch(remapOn);

        "\b(searching in the drawers of <<theName>>)\n";
        searchCore.clearHistory();
        doNested(LookIn, remapIn);
        doubleCheckGenericSearch(remapIn);
    }

    dobjFor(Open) {
        remap = remapIn
    }

    dobjFor(Close) {
        remap = remapIn
    }

    iobjFor(TakeFrom) {
        remap = (gTentativeDobj.overlapsWith(remapOn.contents) ? remapOn : remapIn)
    }

    notionalContents() {
        return inherited() + remapIn.notionalContents();
    }
}

class CabinetDrawer: SubComponent {
    desc = "TODO: Add description. "
    subLocation = &remapIn
    contType = In
    bulkCapacity = actorCapacity
    maxSingleBulk = 1
    isOpenable = true
    isFixed = true
}

class TopCabinetDrawer: CabinetDrawer {
    vocab = 'top drawer;upper first'
    nameAs(parent) {
        name = parent.name + '\'s top drawer';
    }
}

class MiddleCabinetDrawer: CabinetDrawer {
    vocab = 'middle drawer;mid second center'
    nameAs(parent) {
        name = parent.name + '\'s middle drawer';
    }
}

class BottomCabinetDrawer: CabinetDrawer {
    vocab = 'bottom drawer;lower lowest third'
    nameAs(parent) {
        name = parent.name + '\'s bottom drawer';
    }
}

//TODO: Implement cabinet drawers

administration: Room { 'Administration'
    "TODO: Add description. "

    northeast = fakeNortheastCubicle
    southeast = fakeSoutheastCubicle
    northwest = fakeNorthwestCubicle
    southwest = fakeSouthwestCubicle

    eastMuffle = commonRoom
    southMuffle = enrichmentRoom

    regions = [administrationAudioRegion]
}
+fakeNortheastCubicle: FakeCubicle { 'northeast[weak] cubicle;ne[weak];office'
    destination = northeastCubicle
}
+fakeSoutheastCubicle: FakeCubicle { 'southeast[weak] cubicle;se[weak];office'
    destination = southeastCubicle
}
+fakeNorthwestCubicle: FakeCubicle { 'northwest[weak] cubicle;nw[weak];office'
    destination = northwestCubicle
}
+fakeSouthwestCubicle: FakeCubicle { 'southwest[weak] cubicle;sw[weak];office'
    destination = southwestCubicle
}

northeastCubicle: Cubicle { 'The Northeast Cubicle'
    standardCubicleDesc
}
populateCubicle(northeastCubicle)

JumpUpLink { ->northeastCubicleFilingCabinet
    location = northeastCubicleDesk
}

southeastCubicle: Cubicle { 'The Southeast Cubicle'
    standardCubicleDesc
}
populateCubicle(southeastCubicle)

northwestCubicle: Cubicle { 'The Northwest Cubicle'
    standardCubicleDesc
}
populateCubicle(northwestCubicle)

southwestCubicle: Cubicle { 'The Southwest Cubicle'
    standardCubicleDesc
}
populateCubicle(southwestCubicle)

DefineDoorWestTo(northwestHall, administration, 'the administration door')