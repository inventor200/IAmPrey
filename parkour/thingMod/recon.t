modify Thing {
    markAsClimbed() {
        playerClimbed = true;
    }

    hasBeenClimbed() {
        return playerClimbed;
    }

    applyRecon() {
        hasParkourRecon = true;
        local reconLst = valToList(shareReconWith);
        reconLst += valToList(shareReconWithProcedural);
        for (local i = 1; i <= reconLst.length; i++) {
            reconLst[i].hasParkourRecon = true;
        }
    }

    doParkourSearch() {
        doRecon();
    }

    checkLocalPlatformReconHandled(previousSignal) {
        if (!previousSignal && forcedLocalPlatform) {
            learnOnlyLocalPlatform(self, extraReport);
        }
        return forcedLocalPlatform || previousSignal;
    }

    doRecon() {
        if (checkLocalPlatformReconHandled(nil)) {
            return;
        }

        local provider = getParkourProvider(nil, nil);

        if (provider != nil) {
            if (!provider.hasParkourRecon) {
                local pm = gTaxingRunnerModule(gActor);
                if (pm != nil) {
                    pm.doReconForProvider(provider);
                }
            }
        }

        if (!isLikelyContainer()) return;

        if (parkourModule != nil) parkourModule.doRecon();
    }
}