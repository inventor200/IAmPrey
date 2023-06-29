modify Actor {
    roomsTraveled = 0
    // Inventor Core remaps these
    remappingSearch = true
    remappingLookIn = true
}

modify Room {
    // Inventor Core remaps these actions
    remappingSearch = true
    remappingLookIn = true

    travelerEntering(traveler, src) {
        inherited(traveler, src);
        if (gPlayerChar.isOrIsIn(traveler)) {
            gPlayerChar.roomsTraveled++;
        }
    }
}

modify Floor {
    getFloorActions() {
        return inherited().append(SearchClose).append(SearchDistant);
    }
}

modify Surface {
    dobjFor(Search) {
        preCond = nil
        remap = nil
        verify() { verifyGenericSearch(); }
        check() { }
        action() { doGenericSearch(); }
        report() { }
    }
}

modify Door {
    allowLookThroughSearch
}

modify lookInLister {
    listed(obj) {
        return (obj.searchListed && !obj.isHidden) || obj.voluntaryFakeContentsItem;
    }
}

DefineDistComponent(ContainerGrate)
    vocab = 'grate;;grating'

    preCreate(_lexParent) {
        hatch = _lexParent;
        local hatchHandled = nil;

        if (_lexParent.contType == In && _lexParent.isOpenable) {
            hatchHandled = true;
        }
        if (_lexParent.remapIn != nil && !hatchHandled) {
            if (_lexParent.remapIn.contType == In && _lexParent.remapIn.isOpenable) {
                hatch = _lexParent.remapIn;
                hatchHandled = true;
            }
        }
        if (_lexParent.remapOn != nil && !hatchHandled) {
            if (_lexParent.remapOn.contType == In && _lexParent.remapOn.isOpenable) {
                hatch = _lexParent.remapOn;
                hatchHandled = true;
            }
        }
        
        if (hatchHandled) {
            owner = hatch;
            ownerNamed = true;
        }
    }

    postCreate(_lexParent) {
        hatch.hasGrating = true;
    }

    remapReach(action) {
        return hatch;
    }

    distOrder = 1
    hatch = nil
    isDecoration = true
    distComponentOwnerNamed = nil

    desc = "A small metal frame with horizontal slits machined into it.
        {I} might be able to look through it."

    decorationActions = [Examine, PeekThrough, LookThrough, PeekInto, Search, LookIn]

    dobjFor(PeekInto) asDobjFor(Search)
    dobjFor(LookThrough) asDobjFor(Search)
    dobjFor(LookIn) asDobjFor(Search)
    dobjFor(Search) {
        remap = nil
        preCond = nil
        verify() {
            if (hatch.isOpenable && hatch.isOpen) {
                illogical('There\'s little point in looking through the
                    grate of something which is already open. ');
            }
        }
        action() {
            if (gActor.isIn(hatch)) {
                doInstead(Look);
                searchCore.reportedSuccess = true;
            }
            else {
                doInstead(SearchDistant, hatch);
            }
        }
    }

    locType() {
        return Outside;
    }
;