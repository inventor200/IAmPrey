modify ParkourModule {
    doAllPunishmentsAndAccidents(actor, traveler, path) {
        if (lexicalParent == nil) return true;
        if (path.requiresJump) {
            lexicalParent.doJumpPunishment(actor, traveler, path);
        }
        else {
            lexicalParent.doClimbPunishment(actor, traveler, path);
        }
        if (path.isHarmful) {
            lexicalParent.doHarmfulPunishment(actor, traveler, path);
        }
        local hadAccident = gOutStream.watchForOutput({:
            lexicalParent.doAccident(actor, traveler, path)
        });
        parkourCore.hadAccident = parkourCore.hadAccident || hadAccident;
        return !hadAccident;
    }

    doParkourCheck(actor, path) {
        gMoverFrom(actor);
        local source = gParkourRunnerModule;

        if (parkourCore.doParkourRunnerCheck(actor)) {
            local clearedLeaving = true;
            if (source != nil) {
                clearedLeaving = source.checkLeaving(actor, gMover, path);
            }
            if (clearedLeaving) {
                if (checkArriving(actor, gMover, path)) {
                    local barriers = [];
                    if (path != nil) {
                        barriers += valToList(path.injectedParkourBarriers);
                    }
                    if (lexicalParent != nil) {
                        barriers += valToList(lexicalParent.parkourBarriers);
                    }

                    for (local i = 1; i <= barriers.length; i++) {
                        local barrier = barriers[i];
                        // Note: Args are traveler, path
                        // instead of     traveler, connector
                        if (!barrier.checkTravelBarrier(gMover, path)) {
                            return nil;
                        }
                    }

                    return true;
                }
            }
        }

        return nil;
    }
}