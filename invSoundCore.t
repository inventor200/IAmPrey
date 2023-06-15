modify Thing {
    actionMoveInto(loc) {
        local oldLoc = location;

        inherited(loc);

        if (gCatMode) return;

        if (loc.isOrIsIn(gPlayerChar)) {
            if (
                ofKind(EnviroSuitPart) &&
                self != fakeHelmet &&
                suitTracker.gatheredPieces.indexOf(self) == nil
            ) {
                addSFX(suitPartStowSnd);
            }
            else if (loc.isOrIsIn(enviroSuitBag) || self == enviroSuitBag) {
                addSFX(bagStowSnd);
            }
            else if (gPlayerChar.isNaked() && !isWearable) {
                addSFX(skinStowSnd);
            }
            else {
                addSFX(clothStowSnd);
            }
        }
        else if (oldLoc.isOrIsIn(gPlayerChar)) {
            if (oldLoc.isOrIsIn(enviroSuitBag) || self == enviroSuitBag) {
                addSFX(bagStowSnd);
            }
            else if (gPlayerChar.isNaked() && !isWearable) {
                addSFX(skinStowSnd);
            }
            else {
                addSFX(clothStowSnd);
            }
        }
    }
}

modify Inventory {
    execAction(cmd) {
        if (enviroSuitBag.isIn(gPlayerChar)) {
            if (!enviroSuitBag.remapIn.isOpen) {
                tryImplicitAction(Open, enviroSuitBag.remapIn);
            }
            addSFX(bagCheckSnd);
        }
        else if (gPlayerChar.isNaked()) {
            addSFX(skinCheckSnd);
        }
        else {
            addSFX(clothCheckSnd);
        }

        inherited(cmd);

        if (
            !enviroSuitBag.isIn(gPlayerChar) &&
            enviroSuitBag.isUnited &&
            gPlayerChar.canReach(enviroSuitBag)
        ) {
            extraReport('\b(also checking the nearby <<enviroSuitBag.name>>');
            if (!enviroSuitBag.remapIn.isOpen) {
                extraReport(', after opening it');
            }
            extraReport(')\n');
            if (!enviroSuitBag.remapIn.isOpen) {
                //nestedAction(Open, enviroSuitBag.remapIn);
                enviroSuitBag.remapIn.makeOpen(true);
            }
            nestedAction(LookIn, enviroSuitBag.remapIn);
            addSFX(bagCheckSnd);
        }
    }
}