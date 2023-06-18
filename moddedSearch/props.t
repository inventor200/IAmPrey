#define allowLookThroughSearch \
    verifyGenericSearch() { } \
    doGenericSearch() { \
        doParkourSearch(); \
        doNested(LookThrough, self); \
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
        '{I} find nothing of interest about {the dobj}. ';
    
    remappingSearch = nil
    remappingLookIn = nil
    remappingLookUnder = nil
    remappingLookBehind = nil
    remappingSearchClose = (remappingSearch)
    remappingSearchDistant = (remappingSearch)

    finalizeSearch(searchAction) {
        // Implemented by author for post-search effects
    }

    doParkourSearch() {
        // Implemented in the parkour module
    }

    nothingOnMsg = '{I} {find} nothing of interest on {the dobj}. '
    notObviousContainerMsg =
        '{The subj dobj} {do} not seem to carry or contain anything. '
    notFunctionalContainerMsg =
        '{The subj dobj} {is} neither a container nor parkour route to search. '
}