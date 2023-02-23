#define expandableSearch 'search' | 'srch' | 'src' | 'sr'

modify VerbRule(Search)
    [badness 20] (expandableSearch) singleDobj :
    allowAll = nil
;

modify VerbRule(LookIn)
    ('look' | 'l' | expandableSearch) ('in' | 'inside') singleDobj :
    allowAll = nil
;

modify VerbRule(LookUnder)
    ('look' | 'l' | expandableSearch) 'under' singleDobj :
    allowAll = nil
;

modify VerbRule(LookBehind)
    ('look' | 'l' | expandableSearch) 'behind' singleDobj :
    allowAll = nil
;

VerbRule(SearchDistant)
    [badness 30] (expandableSearch) singleDobj
    : VerbProduction
    action = SearchDistant
    verbPhrase = 'search/searching (what)'
    missingQ = 'what do you want to search'
    allowAll = nil
;

DefineTAction(SearchDistant)
;

VerbRule(SearchClose)
    [badness 50] (expandableSearch) singleDobj
    : VerbProduction
    action = SearchClose
    verbPhrase = 'search/searching (what)'
    missingQ = 'what do you want to search'
    allowAll = nil
;

DefineTAction(SearchClose)
;

modify Actor {
    roomsTraveled = 0
}

modify Room {
    travelerEntering(traveler, src) {
        inherited(traveler, src);
        if (gPlayerChar.isOrIsIn(traveler)) {
            gPlayerChar.roomsTraveled++;
        }
    }
}

modify Thing {
    roomsTraveledUponLastSearch = 0
    skashekCouldBeHere = true
    skashekFoundHere = nil
    shashekAnnounced = nil
    searchedFromDistance = nil
    beganGenericSearch = nil
    successfulGenericSearch = nil

    dobjFor(Search) {
        preCond = nil
        remap = nil
        verify() { }
        check() { }
        action() { doGenericSearch(); }
        report() { }
    }

    doGenericSearch() {
        beganGenericSearch = true;
        successfulGenericSearch = nil;
        doParkourSearch();
        if (contType == In) {
            doNested(LookIn, self);
            return;
        }
        else {
            local searchingSubs = (remapOn != nil || remapIn != nil);
            local multiSub = (remapOn != nil && remapIn != nil);
            if (remapOn != nil) {
                if (multiSub) {
                    "(Searching the top of <<theName>>...)<.p>";
                }
                doNested(SearchClose, remapOn);
            }
            if (remapIn != nil) {
                if (multiSub) {
                    "<.p>(Searching in <<theName>>...)<.p>";
                }
                doNested(LookIn, remapIn);
            }
            if (!searchingSubs) {
                doNested(SearchClose, self);
            }
        }
        if (!successfulGenericSearch) {
            doNested(SearchDistant, self);
        }
        beganGenericSearch = nil;
    }

    dobjFor(SearchClose) {
        preCond = [objVisible, touchObj]
        verify() { }
        check() { }
        action() {
            beforeSearch();
            doDistantSearch(true);
            doCloseSearch();
            reportShashek();
            afterSearch();
        }
        report() { }
    }

    dobjFor(SearchDistant) {
        preCond = [objVisible]
        verify() { }
        check() { }
        action() {
            beforeSearch();
            doDistantSearch(nil);
            afterSearch();
        }
        report() { }
    }

    dobjFor(LookIn) {
        action() {
            beforeSearch();
            doDistantSearch(true);
            inherited();
            reportShashek();
            afterSearch();
        }
    }

    dobjFor(LookUnder) {
        action() {
            beforeSearch();
            doDistantSearch(true);
            inherited();
            reportShashek();
            afterSearch();
        }
    }

    dobjFor(LookBehind) {
        action() {
            beforeSearch();
            doDistantSearch(true);
            inherited();
            reportShashek();
            afterSearch();
        }
    }

    beforeSearch() {
        if (gActor == gPlayerChar && roomsTraveledUponLastSearch < gActor.roomsTraveled) {
            roomsTraveledUponLastSearch = gActor.roomsTraveled;
            skashekCouldBeHere = true;
            skashekFoundHere = nil;
            shashekAnnounced = nil;
            searchedFromDistance = nil;
        }
    }

    doCloseSearch() {
        if (hiddenIn.length == 0 && getSearchCount() == 0) {
            say(nothingOnMsg);
            return;
        }
            
        local onList = getSearchItems();
        
        if (onList.length > 0) {
            listContentsOn(onList);
        }
        
        if (hiddenIn.length > 0) {
            findHidden(&hiddenIn, In);
        }
    }

    doDistantSearch(isSubstep) {
        if (isSubstep && searchedFromDistance) return;

        if (skashekCouldBeHere) {
            //TODO: Search from distance

            searchedFromDistance = true;
            reportShashek();
        }
    }

    doParkourSearch() {
        // Implemented in the parkour module
    }

    afterSearch() {
        if (beganGenericSearch) {
            successfulGenericSearch = true;
        }
    }

    reportShashek() {
        if (skashekFoundHere) {
            if (!shashekAnnounced) {
                //TODO: Announce skashek
                if (gActionIs(SearchClose)) {
                    //
                    shashekAnnounced = true;
                }
                else if (gActionIs(LookIn)) {
                    //
                    shashekAnnounced = true;
                }
                else if (gActionIs(LookUnder)) {
                    //
                    shashekAnnounced = true;
                }
                else if (gActionIs(LookBehind)) {
                    //
                    shashekAnnounced = true;
                }
                else if (gActionIs(SearchDistant)) {
                    //
                    shashekAnnounced = true;
                }
            }
        }
        skashekCouldBeHere = nil;
    }

    nothingOnMsg = '{I} {find} nothing of interest on {the dobj}. '

    getSearchCount() {
        return contents.countWhich({x: x.searchListed});
    }

    getSearchItems() {
        // Shashek will be listed in a unique way
        return contents.subset({x: x.searchListed && x != skashek});
    }

    listContentsOn(lst) {
        lookInLister.show(lst, self, true);
    }
}

modify Surface {
    dobjFor(Search) {
        preCond = nil
        remap = nil
        verify() { }
        check() { }
        action() { doGenericSearch(); }
        report() { }
    }
}