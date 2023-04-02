#define CabinetDrawerProperties \
    subLocation = &remapIn \
    contType = In \
    bulkCapacity = actorCapacity \
    isOpenable = true \
    distOrder = 1 \
    /* Stuff to acknowledge attempts to climb drawers */ \
    getParkourModule() { return nil; } \
    parkourModule = nil \
    cannotBoardMsg = \
        '{The dobj} {is} too unstable to use for climbing. '

class BaseCabinet: Fixture {
    vocab = cabinetSubclass + ' cabinet;office ' + adjectivesFromItems + 'metal'
    desc = "A standard, metal <<cabinetSubclass>> cabinet. It has a top, middle, and bottom
    drawer for storage. "

    cabinetSubclass = 'simple'
    cabinetSubclassInDesc = (cabinetSubclass)
    adjectivesFromItems = ''
    
    betterStorageHeader
    IncludeDistComponent(TinyDoorTopDrawerHandle)
    IncludeDistComponent(TinyDoorMiddleDrawerHandle)
    IncludeDistComponent(TinyDoorBottomDrawerHandle)

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

DefineDistSubComponentFor(BaseCabinetRemapOn, BaseCabinet, remapOn)
    isBoardable = true
    betterStorageHeader
;

DefineDistSubComponentFor(BaseCabinetRemapIn, BaseCabinet, remapIn)
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
;

DefineDistComponent(TinyDoorTopDrawerHandle)
    getLikelyHatch(obj) {
        return obj.topDrawer;
    }

    tinyDoorHandleProperties
;

DefineDistComponent(TinyDoorMiddleDrawerHandle)
    getLikelyHatch(obj) {
        return obj.middleDrawer;
    }

    tinyDoorHandleProperties
;

DefineDistComponent(TinyDoorBottomDrawerHandle)
    getLikelyHatch(obj) {
        return obj.bottomDrawer;
    }

    tinyDoorHandleProperties
;