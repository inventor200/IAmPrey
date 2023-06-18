modify Thing {
    reportLookTooFar() {
        extraReport('\n(<<theName>> is too far away for a detailed look...)\n');
        searchCore.reportedFailure = true;
    }

    accountForSkashekPresence(remapTarg?) {
        if (remapTarg == nil) remapTarg = self;
        searchCore.skashekFoundHere =
            skashek.location != nil &&
            (skashek.location == remapTarg || skashek.location == remapTarg.lexicalParent);
    }

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
            if (gActor.canReach(remapTarg)) {
                doNested(LookIn, remapTarg);
            }
            else {
                reportLookTooFar();
            }
            doubleCheckGenericSearch(remapTarg);
        }
    }
}