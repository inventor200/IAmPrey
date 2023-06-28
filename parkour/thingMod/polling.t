modify Thing {
    getParkourProvider(fromParent, fromChild) {
        if (canSlideUnderMe) return self;
        if (canJumpOverMe) return self;
        if (canSlideUnderMe) return self;
        if (canSwingOnMe) return self;
        if (canSqueezeThroughMe) return self;

        if (!fromChild) {
            if (remapOn != nil) {
                local childProvider = remapOn.getParkourProvider(true, nil);
                if (childProvider != nil) {
                    return childProvider;
                }
            }
            if (remapIn != nil) {
                local childProvider = remapIn.getParkourProvider(true, nil);
                if (childProvider != nil) {
                    return childProvider;
                }
            }
            if (remapUnder != nil) {
                local childProvider = remapUnder.getParkourProvider(true, nil);
                if (childProvider != nil) {
                    return childProvider;
                }
            }
            if (remapBehind != nil) {
                local childProvider = remapBehind.getParkourProvider(true, nil);
                if (childProvider != nil) {
                    return childProvider;
                }
            }
        }

        if (!fromParent) {
            if (lexicalParent != nil) {
                local parentProvider = lexicalParent.getParkourProvider(nil, true);
                if (parentProvider != nil) {
                    return parentProvider;
                }
            }
        }

        return nil;
    }

    // Simulate an object on top of this IObj, and do a reach test.
    passesGhostReachTest(actor) {
        reachGhostTest_.moveInto(getGhostReachDestination());
        local canReachResult = Q.canReach(actor, reachGhostTest_);
        reachGhostTest_.moveInto(nil);
        return canReachResult;
    }

    getLocalPlatforms() { // Used for actors and non-containers only
        local masterPlatform = location;
        if (masterPlatform == nil) return [];
        // Find outermost platform or room
        // in case in another non-platform container
        while (!(masterPlatform.contType == On || masterPlatform.ofKind(Room))) {
            masterPlatform = masterPlatform.exitLocation;
            if (masterPlatform == nil) return [];
        }

        if (masterPlatform == nil) return [];

        local platList = valToList(masterPlatform.getBonusLocalPlatforms());
        local contentList = valToList(masterPlatform.contents);

        // A local platform will be in the location's contents,
        // and pass the ghost reach test from an actor
        for (local i = 1; i <= contentList.length; i++) {
            local obj = contentList[i];

            if (omitFromLogicalLocalsList()) continue;

            // Check forced
            if (obj.forcedLocalPlatform) {
                reachGhostTest_.moveInto(
                    obj.stagingLocation.getGhostReachDestination()
                );
                if (!Q.canReach(self, reachGhostTest_)) continue;
                platList += obj;
                continue;
            }

            // Check typical
            local pm = obj.getParkourModule();
            local validPlatform = true;
            local otherOn = (pm != nil ? pm.getStandardOn() : obj.getStandardOn());
            if (!otherOn.isLikelyContainer()) continue;
            if (otherOn == masterPlatform) continue;
            if (pm == nil) {
                validPlatform = obj.isStandardPlatform(true, nil);
            }
            if (!validPlatform) continue;
            reachGhostTest_.moveInto(otherOn.getGhostReachDestination());
            if (!Q.canReach(self, reachGhostTest_)) continue;
            platList += otherOn;
        }

        reachGhostTest_.moveInto(nil);

        return platList;
    }

    checkParkourProviderBarriers(actor, path) {
        if (parkourCore.doParkourRunnerCheck(actor)) {
            if (checkAsParkourProvider(actor, gMover, path)) {
                local barriers = valToList(parkourBarriers);

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

        return nil;
    }
}