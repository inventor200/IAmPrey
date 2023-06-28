modify Thing {
    dobjFor(Search) {
        preCond = nil
        remap = nil
        verify() { verifyGenericSearch(); }
        check() { }
        action() { doGenericSearch(); }
        report() { }
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

    registerLookUnderSuccess() {
        searchCore.reportedSuccess = true;
    }

    registerLookUnderFailure() {
        searchCore.reportedFailure = true;
    }
}