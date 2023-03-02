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
    [badness 50] (expandableSearch) ('on'|('on'|'the'|) 'top' 'of'|'atop') singleDobj
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
    skashekFoundHere = nil
    searchedFromDistance = nil
    beganGenericSearch = nil
    successfulGenericSearch = nil

    hasGrating = nil
    grate = nil

    canPeekAtSkashek = (isTransparent || hasGrating || (isOpenable && isOpen))

    distantSearchDesc = "{The subj dobj} seem{s/ed} safe from here. "
    alsoDistantSearchDesc = "However, {he subj dobj} seem{s/ed} safe from here. "

    dobjFor(Search) {
        preCond = nil
        remap = nil
        verify() { verifyGenericSearch(); }
        check() { }
        action() { doGenericSearch(); }
        report() { }
    }

    verifyGenericSearch() {
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

    startGenericSearch(remapTarg?) {
        if (remapTarg == nil) remapTarg = self;
        remapTarg.beganGenericSearch = true;
        remapTarg.successfulGenericSearch = nil;
    }

    doubleCheckGenericSearch(remapTarg?) {
        if (remapTarg == nil) remapTarg = self;
        if (!remapTarg.successfulGenericSearch) {
            remapTarg.doDistantSearch(true);
        }
        remapTarg.beganGenericSearch = nil;
    }

    doGenericSearch() {
        doParkourSearch();

        if (contType == In) {
            doSafeLookIn(self);
            return;
        }
        else {
            local searchingSubs = (remapOn != nil || remapIn != nil);
            local multiSub = (remapOn != nil && remapIn != nil);
            if (remapOn != nil) {
                if (multiSub) {
                    "(searching the top of <<theName>>)<.p>";
                }
                startGenericSearch(remapOn);
                doNested(SearchClose, remapOn);
                doubleCheckGenericSearch(remapOn);
            }
            if (remapIn != nil) {
                if (multiSub) {
                    "<.p>(searching in <<theName>>)<.p>";
                }
                doSafeLookIn(remapIn);
            }
            if (!searchingSubs) {
                startGenericSearch();
                doNested(SearchClose, self);
                doubleCheckGenericSearch();
            }
        }
    }

    doSafeLookIn(remapTarg?) {
        if (remapTarg == nil) remapTarg = self;
        accountForSkashekPresence(remapTarg);
        // Don't do something stupid lol
        local hasPeekChance = remapTarg.skashekFoundHere && remapTarg.canPeekAtSkashek;
        if (hasPeekChance) {
            remapTarg.doDistantSearch(nil);
        }
        else {
            startGenericSearch(remapTarg);
            doNested(LookIn, remapTarg);
            doubleCheckGenericSearch(remapTarg);
        }
    }

    dobjFor(SearchClose) {
        preCond = [objVisible]
        verify() { }
        check() { }
        action() {
            beforeSearch();
            doCloseSearch();
            reportShashek();
            afterSearch();
        }
        report() { }
    }

    dobjFor(SearchDistant) {
        preCond = [objVisible]
        remap = remapIn
        verify() { }
        check() { }
        action() {
            if (contType == In) {
                beforeSearch();
                doDistantSearch(nil);
                afterSearch();
            }
        }
        report() { }
    }

    dobjFor(LookIn) {
        preCond = [objVisible, containerOpen, touchObj]
        action() {
            beforeSearch();
            accountForSkashekPresence();
            doStandardLook(In, hiddenIn, &hiddenIn, &lookInMsg);
            reportShashek();
            afterSearch();
        }
    }

    dobjFor(LookUnder) {
        action() {
            beforeSearch();
            accountForSkashekPresence();
            doStandardLook(Under, hiddenUnder, &hiddenUnder, &lookUnderMsg);
            reportShashek();
            afterSearch();
        }
    }

    dobjFor(LookBehind) {
        action() {
            beforeSearch();
            accountForSkashekPresence();
            doStandardLook(Behind, hiddenBehind, &hiddenBehind, &lookBehindMsg);
            reportShashek();
            afterSearch();
        }
    }

    doStandardLook(prep, hiddenPrep, hiddenProp, lookPrepMsgProp) {
        if (contType == prep) {
            if (hiddenPrep.length > 0) {
                moveHidden(hiddenProp, self);
            }
            
            if (getListCount() == 0) {
                display(lookPrepMsgProp);
            }
            else {
                local relevantContents = getNonSkashekList();
                unmention(relevantContents);
                if (gOutStream.watchForOutput({: listContentsOn(relevantContents) }) == nil) {
                    if (!skashekFoundHere) display(lookPrepMsgProp);
                }
            }
        }
        else if (hiddenPrep.length > 0) {
            findHidden(hiddenProp, prep);
        }
        else {
            display(lookPrepMsgProp);
        }
    }

    beforeSearch() {
        if (gActor == gPlayerChar && roomsTraveledUponLastSearch < gActor.roomsTraveled) {
            roomsTraveledUponLastSearch = gActor.roomsTraveled;
            skashekFoundHere = nil;
            searchedFromDistance = nil;
        }
    }

    doCloseSearch() {
        if (contType == On) {
            if (hiddenIn.length > 0) {
                moveHidden(&hiddenIn, self);
            }

            if (getListCount() == 0) {
                say(nothingOnMsg);
            }
            else {
                local relevantContents = getNonSkashekList();
                unmention(relevantContents);
                if (gOutStream.watchForOutput({: listContentsOn(relevantContents) }) == nil) {
                    if (!skashekFoundHere) say(nothingOnMsg);
                }
            }
        }
        else if (hiddenIn.length > 0) {
            findHidden(&hiddenIn, In);
        }
        else {
            say(nothingOnMsg);
        }
    }

    doDistantSearch(isSubstep) {
        if (isSubstep && searchedFromDistance) return;
        if (contType != In) {
            // We are only interested in seeing eyes through distant grates and such
            searchedFromDistance = true;
            return;
        }

        accountForSkashekPresence();
        if (canPeekAtSkashek && skashekFoundHere) {
            reportShashek(isSubstep, true);
        }
        else if (isSubstep) {
            alsoDistantSearchDesc();
        }
        else {
            distantSearchDesc();
        }

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

    accountForSkashekPresence(remapTarg?) {
        if (remapTarg == nil) remapTarg = self;
        remapTarg.skashekFoundHere =
            skashek.location != nil &&
            (skashek.location == remapTarg || skashek.location == remapTarg.lexicalParent);
    }

    reportShashek(isAlso?, forceIn?) {
        if (skashekFoundHere) {
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
        '{The subj dobj} {is} not a container to search. '

    getListCount() {
        return contents.length;
    }
    
    getNonSkashekList() {
        return contents.subset({x: x != skashek});
    }

    listContentsOn(lst) {
        lookInLister.show(lst, self, true);
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

#define includeGrate(destination) \
    preinitThing() { \
        inherited(); \
        if (grate == nil) { \
            hasGrating = true; \
            grate = new ContainerGrate(self, destination); \
            grate.preinitThing(); \
        } \
    }

class ContainerGrate: Decoration {
    construct(_hatch, destination) {
        owner = hatch;
        ownerNamed = true;
        vocab = 'grate;;grating';
        inherited();
        hatch = _hatch;
        lexicalParent = destination;
        moveInto(destination);
    }

    hatch = nil

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
}