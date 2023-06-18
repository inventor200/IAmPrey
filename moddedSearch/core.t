#ifdef __DEBUG
#define __DEBUG_SEARCH_LAYERS nil
#else
#define __DEBUG_SEARCH_LAYERS nil
#endif

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