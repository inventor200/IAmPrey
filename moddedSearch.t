#define expandableSearch 'search'|'srch'|'src'|'sr'

modify Action {
    remappingSearchCheckProp = nil

    skipSearch() {
        if (remappingSearchCheckProp == nil) return nil;
        return gDobj.(remappingSearchCheckProp);
    }
}

modify VerbRule(Search)
    [badness 20] (expandableSearch) singleDobj :
    allowAll = nil
;

modify Search {
    remappingSearchCheckProp = &remappingSearch
}

modify VerbRule(LookIn)
    ('look'|'l'|expandableSearch) ('in'|'inside' ('of'|)|'in' 'to'|'into') singleDobj :
    allowAll = nil
;

modify LookIn {
    remappingSearchCheckProp = &remappingLookIn
}

modify VerbRule(LookUnder)
    ('look'|'l'|expandableSearch) 'under' singleDobj :
    allowAll = nil
;

modify LookUnder {
    remappingSearchCheckProp = &remappingLookUnder
}

modify VerbRule(LookBehind)
    ('look'|'l'|expandableSearch) 'behind' singleDobj :
    allowAll = nil
;

modify LookBehind {
    remappingSearchCheckProp = &remappingLookBehind
}

VerbRule(SearchDistant)
    [badness 30] (expandableSearch) singleDobj
    : VerbProduction
    action = SearchDistant
    verbPhrase = 'search/searching (what)'
    missingQ = 'what do you want to search'
    allowAll = nil
;

DefineTAction(SearchDistant)
    remappingSearchCheckProp = &remappingSearchDistant
;

VerbRule(SearchClose)
    [badness 50] (expandableSearch) ('on'|('on'|'the'|) 'top' 'of'|'atop') singleDobj
    : VerbProduction
    action = SearchClose
    verbPhrase = 'search/searching (what)'
    missingQ = 'what do you want to search'
    allowAll = nil
;

DefineTAction(SearchClose)
    remappingSearchCheckProp = &remappingSearchClose
; 

#if __DEBUG
#define __DEBUG_SEARCH_LAYERS nil
#else
#define __DEBUG_SEARCH_LAYERS nil
#endif

#define Searchify(originalAction) \
    modify originalAction { \
        execCycle(cmd) { \
            if (allowDebug) extraReport('\bNew cycle!\b'); \
            if (!skipSearch()) { \
                if (isImplicit) searchCore.clearHistory(); \
                searchCore.startSearch(nil); \
            } \
            inherited(cmd); \
            if (!skipSearch()) searchCore.concludeSearch(gDobj, nil, nil, nil); \
        } \
        execAction(cmd) { \
            local isFastAction = searchCore.forceFastSearch(); \
            if (!skipSearch()) { \
                if (isImplicit) searchCore.clearHistory(); \
                searchCore.startSearch(isFastAction); \
            } \
            inherited(cmd); \
            if (!skipSearch()) searchCore.concludeSearch(gDobj, nil, nil, isFastAction); \
        } \
    }

Searchify(Search)
Searchify(SearchClose)
Searchify(SearchDistant)
Searchify(LookIn)
Searchify(LookUnder)
Searchify(LookBehind)

class SearchResults: object {
    // If called by a higher-level result, this will be assigned
    parentSearchResults = nil
    // The action that started this (to check if the action failed)
    responsibleAction = nil
    // The nested search result (usually a failure)
    nestedSearchResults = nil
    // Was there a failure?
    searchHadFailure = (responsibleAction.actionFailed)
}

searchCore: object {
    // The present search in progress
    currentSearch = nil
    // A failure message was reported
    reportedFailure = nil
    // A non-failure message was reported
    reportedSuccess = nil
    // Is it a fast search, or a nested search?
    isFastSearch = nil
    // Is a search in progress?
    searchInProgress = nil
    // Would a distant search be a sub-step?
    distantIsSubStep = nil
    // Is this just a parkour search?
    simplyParkour = nil

    // dobj property tracking
    roomsTraveledUponLastSearch = 0
    skashekFoundHere = nil
    searchedFromDistance = nil

    allowDebug = __DEBUG_SEARCH_LAYERS

    forceFastSearch() {
        if (hasSingularError()) return nil;
        return currentSearch != nil;
    }

    hasSingularError() {
        if (searchInProgress) {
            // Error recovery

            // Lost our last search
            if (currentSearch == nil) {
                #if __DEBUG_SEARCH_LAYERS
                extraReport('\bOops! Running with no currentSearch!');
                #endif
                return true;
            }
            // Our last top-level search failed
            else if (currentSearch.parentSearchResults == nil &&
                currentSearch.searchHadFailure) {
                #if __DEBUG_SEARCH_LAYERS
                extraReport('\bOops! Root failed!');
                #endif
                return true;
            }
        }

        return nil;
    }

    startSearch(startFastSearch, isSimplyParkour?) {
        if (hasSingularError()) {
            reset();
        }

        if (!searchInProgress) {
            // Starting fresh
            isFastSearch = startFastSearch;
            searchInProgress = true;
            simplyParkour = isSimplyParkour;

            // Generic search tracking
            if (gActorIsPlayer && !isFastSearch &&
                gDobj.roomsTraveledUponLastSearch < gActor.roomsTraveled) {
                roomsTraveledUponLastSearch = gActor.roomsTraveled;
                skashekFoundHere = nil;
                searchedFromDistance = nil;
            }
            #if __DEBUG_SEARCH_LAYERS
            extraReport('\bNew root <<startFastSearch ? 'fast' : 'slow'>>\b');
            #endif
        }
        #if __DEBUG_SEARCH_LAYERS
        else {
            extraReport('\bNew sub <<startFastSearch ? 'fast' : 'slow'>>\b');
        }
        #endif

        local resultsObject = new SearchResults();
        resultsObject.responsibleAction = gAction;
        resultsObject.parentSearchResults = currentSearch;
        if (currentSearch != nil) {
            currentSearch.nestedSearchResults = resultsObject;
        }
        currentSearch = resultsObject;
    }

    flushFailure(resultsObject) {
        if (resultsObject == nil) return;

        // Search recursively down
        flushFailure(resultsObject.nestedSearchResults);

        // Add failure status
        if (resultsObject.searchHadFailure) {
            reportedFailure = true;
        }
    }

    concludeSearch(currentDobj, hasReportedSuccess, hasReportedFailure, expectingFastSearch?) {
        if (hasReportedSuccess) reportedSuccess = true;
        if (hasReportedFailure) reportedFailure = true;
        #if __DEBUG_SEARCH_LAYERS
        extraReport('\bisFastSearch: <<isFastSearch == nil ? 'nil' : 'true'>> == expectingFastSearch: <<expectingFastSearch == nil ? 'nil' : 'true'>>');
        extraReport('\ncurrentDobj: <<currentDobj == nil ? 'nil' : currentDobj.theName>>');
        extraReport('\ncurrentSearch: <<currentSearch == nil ? 'nil' : 'active'>>\b');
        #endif
        currentDobj.finalizeSearch(currentSearch.responsibleAction);
        
        // Sometimes tiny, one-off searches can start and end,
        // but we need to make sure this is not part of a larger
        // search first.
        if (expectingFastSearch) {
            if (!isFastSearch) return;
        }

        // Travel to the top of the stack
        while (currentSearch.parentSearchResults != nil) {
            currentSearch = currentSearch.parentSearchResults;
        }

        // Find failures
        if (!reportedFailure) {
            flushFailure(currentSearch);
        }

        if (!simplyParkour) {
            if (!reportedFailure && !reportedSuccess) {
                say(currentDobj.noSearchResultsAtAllMsg);
            }
        }

        // Update generic search stats
        if (!isFastSearch) {
            currentDobj.roomsTraveledUponLastSearch = roomsTraveledUponLastSearch;
            currentDobj.skashekFoundHere = skashekFoundHere;
            currentDobj.searchedFromDistance = searchedFromDistance;
        }

        #if __DEBUG_SEARCH_LAYERS
        extraReport('\bAll done!\n');
        #endif
        reset();
    }

    reset() {
        #if __DEBUG_SEARCH_LAYERS
        extraReport('Resetting...\b');
        #endif
        currentSearch = nil;
        reportedFailure = nil;
        reportedSuccess = nil;
        searchInProgress = nil;
        distantIsSubStep = nil;
        simplyParkour = nil;
    }

    clearHistory() {
        reportedSuccess = nil;
        reportedFailure = nil;
    }
}

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
    // Fake contents allow objects to be treated as contents
    // when they are actually located elsewhere.
    fakeContents = nil
    voluntaryFakeContentsItem = nil

    roomsTraveledUponLastSearch = -1
    skashekFoundHere = nil
    searchedFromDistance = nil

    hasGrating = nil
    grate = nil

    canPeekAtSkashek = (isTransparent || hasGrating || (isOpenable && isOpen))

    distantSearchDesc = "{The subj dobj} seem{s/ed} safe from here. "
    alsoDistantSearchDesc = "However, {he subj dobj} seem{s/ed} safe from here. "

    noSearchResultsAtAllMsg =
        'You find nothing of interest about {the dobj}. ';
    
    remappingSearch = nil
    remappingLookIn = nil
    remappingLookUnder = nil
    remappingLookBehind = nil
    remappingSearchClose = (remappingSearch)
    remappingSearchDistant = (remappingSearch)

    finalizeSearch(searchAction) {
        // Implemented by author for post-search effects
    }

    dobjFor(Search) {
        preCond = nil
        remap = nil
        verify() { verifyGenericSearch(); }
        check() { }
        action() { doGenericSearch(); }
        report() { }
    }

    verifyGenericSearch() {
        if (parkourModule != nil) {
            logical;
            return;
        }
        if (forcedLocalPlatform) {
            logical;
            return;
        }

        local isObviousContainer = nil;
        local isFunctionalContainer = nil;

        if (contType == On) {
            isFunctionalContainer = true;
            isObviousContainer = true;
        }
        else if (contType == In) {
            isFunctionalContainer = true;
            isObviousContainer = true;
        }
        else if (remapOn != nil) {
            isFunctionalContainer = true;
            isObviousContainer = true;
        }
        else if (remapIn != nil) {
            isFunctionalContainer = true;
            isObviousContainer = true;
        }

        if (contType == Under) {
            isFunctionalContainer = true;
        }
        else if (contType == Behind) {
            isFunctionalContainer = true;
        }
        else if (remapUnder != nil) {
            isFunctionalContainer = true;
        }
        else if (remapBehind != nil) {
            isFunctionalContainer = true;
        }

        if (!isFunctionalContainer) {
            illogical(notFunctionalContainerMsg);
            return;
        }

        if (!isObviousContainer) {
            illogical(notObviousContainerMsg);
            return;
        }
    }

    doubleCheckGenericSearch(remapTarg?) {
        if (remapTarg == nil) remapTarg = self;
        if (!searchCore.reportedSuccess) {
            searchCore.distantIsSubStep = true;
            doNested(SearchDistant, remapTarg);
        }
    }

    doGenericSearch() {
        doParkourSearch();

        local roomCouldHaveChanged =
            (roomsTraveledUponLastSearch != gActor.roomsTraveled);

        gAction.turnsTaken = roomCouldHaveChanged ? 1 : 0;

        if (contType == In) {
            doSafeLookIn(self);
            return;
        }
        else {
            doMultiSearch();
        }
    }

    doMultiSearch() {
        local searchingSubs = (remapOn != nil || remapIn != nil);
        local multiSub = (remapOn != nil && remapIn != nil);
        if (remapOn != nil) {
            if (multiSub) {
                "(searching the top of <<theName>>)\n";
                searchCore.clearHistory();
            }
            doNested(SearchClose, remapOn);
            doubleCheckGenericSearch(remapOn);
        }
        if (remapIn != nil) {
            if (multiSub) {
                "\b(searching in <<theName>>)\n";
                searchCore.clearHistory();
            }
            doSafeLookIn(remapIn);
        }
        if (!searchingSubs) {
            doNested(SearchClose, self);
            doubleCheckGenericSearch();
        }
    }

    doSafeLookIn(remapTarg?) {
        if (remapTarg == nil) remapTarg = self;
        accountForSkashekPresence(remapTarg);
        // Don't do something stupid lol
        local hasPeekChance = searchCore.skashekFoundHere && remapTarg.canPeekAtSkashek;
        if (hasPeekChance) {
            searchCore.distantIsSubStep = nil;
            doNested(SearchDistant, remapTarg);
        }
        else {
            doNested(LookIn, remapTarg);
            doubleCheckGenericSearch(remapTarg);
        }
    }

    dobjFor(SearchClose) {
        preCond = [objVisible]
        verify() { }
        check() { }
        action() {
            accountForSkashekPresence();
            doStandardLook(On, hiddenIn, &hiddenIn, &nothingOnMsg);
            reportShashek();
        }
        report() { }
    }

    dobjFor(SearchDistant) {
        preCond = [objVisible]
        remap = remapIn
        verify() { }
        check() { }
        action() {
            if (searchCore.distantIsSubStep && searchCore.searchedFromDistance) {
                return;
            }
            if (contType != In) {
                // We are only interested in seeing eyes
                // through distant grates and such
                searchCore.searchedFromDistance = true;
                return;
            }
            if (maxSingleBulk < actorBulk) {
                searchCore.searchedFromDistance = true;
                return;
            }
            accountForSkashekPresence();
            if (canPeekAtSkashek && searchCore.skashekFoundHere) {
                reportShashek(searchCore.distantIsSubStep, true);
            }
            else if (searchCore.distantIsSubStep) {
                alsoDistantSearchDesc();
            }
            else {
                distantSearchDesc();
            }
            searchCore.reportedSuccess = true;
            searchCore.searchedFromDistance = true;
        }
        report() { }
    }

    dobjFor(LookIn) {
        preCond = [objVisible, containerOpen, touchObj]
        action() {
            accountForSkashekPresence();
            doStandardLook(In, hiddenIn, &hiddenIn, &lookInMsg);
            reportShashek();
        }
    }

    dobjFor(LookUnder) {
        action() {
            accountForSkashekPresence();
            doStandardLook(Under, hiddenUnder, &hiddenUnder, &lookUnderMsg);
            reportShashek();
        }
    }

    dobjFor(LookBehind) {
        action() {
            accountForSkashekPresence();
            doStandardLook(Behind, hiddenBehind, &hiddenBehind, &lookBehindMsg);
            reportShashek();
        }
    }

    doStandardLook(prep, hiddenPrep, hiddenProp, lookPrepMsgProp) {
        if (contType == prep) {
            if (hiddenPrep.length > 0) {
                moveHidden(hiddenProp, self);
            }
            
            if (getListCount() == 0) {
                if (!searchCore.reportedSuccess) display(lookPrepMsgProp);
                searchCore.reportedFailure = true;
            }
            else {
                local relevantContents = getNonSkashekList();
                unmention(relevantContents);
                if (gOutStream.watchForOutput({: listContentsOn(relevantContents) }) == nil) {
                    if (!searchCore.skashekFoundHere && !searchCore.reportedSuccess) {
                        display(lookPrepMsgProp);
                    }
                    searchCore.reportedFailure = true;
                }
                else {
                    searchCore.reportedSuccess = true;
                }
            }
        }
        else if (hiddenPrep.length > 0) {
            findHidden(hiddenProp, prep);
            searchCore.reportedFailure = true;
        }
        else if (!searchCore.reportedSuccess) {
            display(lookPrepMsgProp);
            searchCore.reportedSuccess = true;
        }
    }

    doParkourSearch() {
        // Implemented in the parkour module
    }

    accountForSkashekPresence(remapTarg?) {
        if (remapTarg == nil) remapTarg = self;
        searchCore.skashekFoundHere =
            skashek.location != nil &&
            (skashek.location == remapTarg || skashek.location == remapTarg.lexicalParent);
    }

    reportShashek(isAlso?, forceIn?) {
        if (searchCore.skashekFoundHere) {
            local targPhrase = isAlso ? '{he dobj}, however' : '{the dobj}';
            local gratePhrase = isAlso ? 'the grate, however' : 'the grate of {the dobj}';

            if (gActionIs(SearchClose)) {
                "Crouched atop <<targPhrase>>,
                    {I} {see} a <i>terrifying figure!</i> ";
            }
            else if (gActionIs(LookIn) || gActionIs(SearchDistant) || forceIn) {
                if ((isOpenable && isOpen) || isTransparent) {
                    "Crouched inside <<targPhrase>>,
                        {I} {see} an <i>ominous shadow!</i> ";
                }
                else if (!isOpen && hasGrating) {
                    "Barely visible through <<gratePhrase>>,
                        {I} {see} <i>eyes{dummy}, staring back at {me}!</i> ";
                }
            }
            else if (gActionIs(LookUnder)) {
                "Crouched under <<targPhrase>>,
                        {I} {see} an <i>ominous shadow!</i> ";
            }
            else if (gActionIs(LookBehind)) {
                "Crouched behind <<targPhrase>>,
                        {I} {see} an <i>ominous shadow!</i> ";
            }
            skashek.doPlayerCaughtLooking();
        }
    }

    nothingOnMsg = '{I} {find} nothing of interest on {the dobj}. '
    notObviousContainerMsg =
        '{The subj dobj} {do} not seem to carry or contain anything. '
    notFunctionalContainerMsg =
        '{The subj dobj} {is} neither a container nor parkour route to search. '

    getListCount() {
        return contents.length + (fakeContents == nil ? 0 : fakeContents.length);
    }
    
    getNonSkashekList() {
        local fullList = contents.subset({x: x != skashek});
        fullList += forceListing(true);
        return fullList;
    }

    listContentsOn(lst) {
        lookInLister.show(lst, self, true);
        forceListing(nil);
    }

    forceListing(stat) {
        local fakeContentsList = valToList(fakeContents);
        for (local i = 1; i <= fakeContentsList.length; i++) {
            fakeContentsList[i].voluntaryFakeContentsItem = stat;
        }
        return fakeContentsList;
    }
}

modify lookInLister {
    listed(obj) {
        return (obj.searchListed && !obj.isHidden) || obj.voluntaryFakeContentsItem;
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

#define allowLookThroughSearch \
    verifyGenericSearch() { } \
    doGenericSearch() { \
        doParkourSearch(); \
        doNested(LookThrough, self); \
    }

modify Door {
    allowLookThroughSearch
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
        You might be able to look through it."

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
            doInstead(SearchDistant, hatch);
        }
    }

    locType() {
        return Outside;
    }
;