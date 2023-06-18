modify Door {
    clearMyClosingFuse(fuseProp) {
        if (self.(fuseProp) != nil) {
            self.(fuseProp).removeEvent();
            self.(fuseProp) = nil;
        }
    }

    clearFuse(fuseProp) {
        clearMyClosingFuse(fuseProp);

        if (otherSide != nil) {
            otherSide.clearMyClosingFuse(fuseProp);
        }
    }

    startFuse() {
        clearFuse(&closingFuse);

        closingFuse = new Fuse(self, &autoClose, closingDelay);
        closingFuse.eventOrder = 97;
        if (canPlayerSense()) {
            clearFuse(&playerCloseExpectationFuse);
            playerCloseExpectationFuse = new Fuse(self, &endPlayerExpectation, closingDelay);
            playerCloseExpectationFuse.eventOrder = 95;
        }
        if (canEitherBeSeenBy(skashek)) {
            clearFuse(&skashekCloseExpectationFuse);
            skashekCloseExpectationFuse = new Fuse(self, &endSkashekExpectation, closingDelay);
            skashekCloseExpectationFuse.eventOrder = 96;
        }
    }

    contestantExpectsAirlockOpen(contestant) {
        if (contestant == skashek) {
            return skashekExpectsAirlockOpen;
        }
        return playerExpectsAirlockOpen;
    }

    witnessClosing() {
        clearFuse(&closingFuse);
        if (canPlayerSense()) {
            setForBothSides(&wasPlayerExpectingAClose, true);
            clearFuse(&playerCloseExpectationFuse);
        }
        if (canEitherBeSeenBy(skashek)) {
            setForBothSides(&wasSkashekExpectingAClose, true);
            clearFuse(&skashekCloseExpectationFuse);
        }
    }

    getExpectedCloseFuse() {
        local expectedClosingFuse = closingFuse;
        if (expectedClosingFuse == nil && otherSide != nil) {
            expectedClosingFuse = otherSide.closingFuse;
        }
        return expectedClosingFuse;
    }

    getEndExpectationSuspicion(expectingCloseProp, fuseProp) {
        if (airlockDoor) return nil;
        self.(expectingCloseProp) = true;
        local isSuspicious = nil;
        local expectedClosingFuse = getExpectedCloseFuse();
        if (expectedClosingFuse == nil) {
            isSuspicious = true;
        }
        else if (expectedClosingFuse.nextRunTime != self.(fuseProp).nextRunTime) {
            isSuspicious = true;
        }
        clearFuse(fuseProp);

        return isSuspicious;
    }

    checkOpenExpectationFuse(fuseProp) {
        local otherExpectation = nil;
        if (otherSide != nil) otherExpectation = otherSide.(fuseProp);
        return (self.(fuseProp) != nil) || (otherExpectation != nil);
    }

    isStatusSuspiciousTo(contestant, fuseProp) {
        if (!canEitherBeSeenBy(contestant)) return nil;
        if (airlockDoor) {
            return isOpen != contestantExpectsAirlockOpen(contestant);
        }
        return isOpen != checkOpenExpectationFuse(fuseProp);
    }

    checkClosingExpectations() {
        if (!wasPlayerExpectingAClose) {
            makePlayerSuspicious();
        }
        else {
            emitNormalClosingSound();
        }
        setForBothSides(&wasPlayerExpectingAClose, nil);
        if (!wasSkashekExpectingAClose) {
            makeSkashekSuspicious();
        }
        setForBothSides(&wasSkashekExpectingAClose, nil);
    }
}