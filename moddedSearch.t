#define __DEBUG_SEARCH true

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
    searchedFromDistance = nil
    beganGenericSearch = nil
    successfulGenericSearch = nil

    dobjFor(Search) { //FIXME: It's reporting out of reach?
        preCond = nil
        remap = nil
        verify() { }
        check() { }
        action() {
            #if __DEBUG_SEARCH
            extraReport('<.p>(Starting generic search)<.p>');
            #endif
            beganGenericSearch = true;
            successfulGenericSearch = nil;
            doParkourSearch();
            doNested(SearchClose, self);
            if (!successfulGenericSearch) {
                doNested(SearchDistant, self);
            }
            beganGenericSearch = nil;
        }
        report() { }
    }

    dobjFor(SearchClose) {
        preCond = [objVisible, touchObj]
        remap = remapIn
        verify() { }
        check() { }
        action() {
            #if __DEBUG_SEARCH
            extraReport('<.p>(Starting close search)<.p>');
            #endif
            if (contType == In) {
                doNested(LookIn, self);
                return;
            }
            beforeSearch();
            doDistantSearch(true);
            doCloseSearch();
            afterSearch();
        }
        report() { }
    }

    dobjFor(SearchDistant) {
        preCond = [objVisible]
        verify() { }
        check() { }
        action() {
            #if __DEBUG_SEARCH
            extraReport('<.p>(Starting distant search)<.p>');
            #endif
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
            #if __DEBUG_SEARCH
            extraReport('<.p>(Look in follow-through...)<.p>');
            #endif
            inherited();
            afterSearch();
        }
    }

    dobjFor(LookUnder) {
        action() {
            beforeSearch();
            doDistantSearch(true);
            #if __DEBUG_SEARCH
            extraReport('<.p>(Look under follow-through...)<.p>');
            #endif
            inherited();
            afterSearch();
        }
    }

    dobjFor(LookBehind) {
        action() {
            beforeSearch();
            doDistantSearch(true);
            #if __DEBUG_SEARCH
            extraReport('<.p>(Look behind follow-through...)<.p>');
            #endif
            inherited();
            afterSearch();
        }
    }

    beforeSearch() {
        if (gActor == gPlayerChar && roomsTraveledUponLastSearch < gActor.roomsTraveled) {
            roomsTraveledUponLastSearch = gActor.roomsTraveled;
            skashekCouldBeHere = true;
            searchedFromDistance = nil;
        }
    }

    doCloseSearch() {
        //TODO: Likely looking at what is on the container
    }

    doDistantSearch(isSubstep) {
        #if __DEBUG_SEARCH
        extraReport('<.p>(Distant entry...)<.p>');
        #endif
        if (isSubstep && searchedFromDistance) return;
        #if __DEBUG_SEARCH
        extraReport('<.p>(Distant follow-through...)<.p>');
        #endif
        //TODO: Search from distance

        searchedFromDistance = true;
    }

    doParkourSearch() {
        // Implemented in the parkour module
    }

    afterSearch() {
        if (beganGenericSearch) {
            successfulGenericSearch = true;
        }
    }
}