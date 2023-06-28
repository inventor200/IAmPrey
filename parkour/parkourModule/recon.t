modify ParkourModule {
    doRecon() {
        local platformSignal = checkLocalPlatformReconHandled(nil);
        if (lexicalParent != nil) {
            if (lexicalParent.checkLocalPlatformReconHandled(platformSignal)) {
                platformSignal = true;
            }

            if (platformSignal) return;

            if (!lexicalParent.hasParkourRecon) {
                gMoverFrom(gActor);
                local pm = gParkourRunnerModule;
                if (pm != nil) {
                    local path = getPathFrom(pm, true, true);
                    if (path != nil) {
                        lexicalParent.applyRecon();
                        parkourCore.showNewRoute = true;
                        learnPath(path, reportAfter);
                    }
                }
            }
        }
    }

    doReconForProvider(provider) {
        local jumpPath = nil;
        for (local i = 1; i <= pathVector.length; i++) {
            local path = pathVector[i];
            if (path.provider != provider) continue;
            if (path.requiresJump) {
                jumpPath = path;
            }
            else {
                provider.applyRecon();
                parkourCore.showNewRoute = true;
                learnPath(path, reportAfter);
                return;
            }
        }

        if (jumpPath != nil) {
            provider.applyRecon();
            parkourCore.showNewRoute = true;
            learnPath(jumpPath, reportAfter);
        }
    }
}