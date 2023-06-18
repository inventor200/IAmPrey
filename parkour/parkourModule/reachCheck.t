modify ParkourModule {
    isInReachFrom(source, canBeUnknown?, doNotFactorJump?) {
        return isInReachFromVerbose(source, canBeUnknown, doNotFactorJump) == parkourReachSuccessful;
    }

    isInReachFromVerbose(source, canBeUnknown?, doNotFactorJump?) {
        #if __PARKOUR_REACH_DEBUG
        extraReport('\nREACH TO: <<theName>>\n');
        #endif
        if (source == gActor) {
            parkourCore.cacheParkourRunner(source);
            source = gParkourRunner;
        }
        #if __PARKOUR_REACH_DEBUG
        extraReport('\nTesting source: <<source.theName>> (<<source.contType.prep>>)\n');
        #endif
        local closestParkourMod = source.getParkourModule();

        // Real quick: Check in with bonus reaches to see if
        // we can skip this whole shitshow.
        /*local myParent = lexicalParent;
        local otherParent = (closestParkourMod != nil) ?
            closestParkourMod.lexicalParent : source;

        if (myParent != nil && otherParent != nil) {
            if (myParent.canBonusReachDuring(otherParent, gAction)) return true;
            if (otherParent.canBonusReachDuring(myParent, gAction)) return true;
        }*/

        // No luck... business as usual, then!

        if (closestParkourMod == nil) {
            // Last ditch ideas for related non-parkour containers!
            // If the source left its current container,
            // would it be on us?
            local realSource = source;
            if (!source.isLikelyContainer() && source.location != nil) {
                // Likely an actor or item; test its location
                realSource = source.location;
            }
            #if __PARKOUR_REACH_DEBUG
            //extraReport('\nNo parkour mod on <<realSource.theName>> (<<realSource.contType.prep>>).\n');
            extraReport('\nNo parkour mod on <<source.theName>> (<<source.contType.prep>>).\n');
            #endif
            // Check two SubComponents a part of the same container
            if (realSource.lexicalParent == self.lexicalParent) {
                #if __PARKOUR_REACH_DEBUG
                extraReport('\nSame container; source: <<realSource.contType.prep>>\n');
                #endif
                // Confirmed SubComponent of same container.
                // Can we reach the parkour module from this SubComponent?
                if (realSource.partOfParkourSurface || realSource.isInReachOfParkourSurface) {
                    return parkourReachSuccessful;
                }
                return parkourSubComponentTooFar;
            }

            #if __PARKOUR_REACH_DEBUG
            extraReport('\nCHECKING PROVIDERS NEXT!\n');
            #endif

            // If paths use the source as a provider, then it must be within reach
            for (local i = 1; i <= pathVector.length; i++) {
                if (pathVector[i].provider == source) return true;
            }

            #if __PARKOUR_REACH_DEBUG
            extraReport('\nCHECKING STAGE/EXIT NEXT! (<<realSource.theName>>)\n');
            #endif

            // Check other normal container relations
            local testStagLoc = realSource.stagingLocation;
            local testExitLoc = realSource.stagingLocation;
            if (testStagLoc == nil) testStagLoc = realSource;
            if (testExitLoc == nil) testExitLoc = realSource;
            #if __PARKOUR_REACH_DEBUG
            extraReport('\nStaging: <<testStagLoc.theName>>\n');
            #endif
            if (checkStagingExitLocationConnection(testStagLoc)) {
                #if __PARKOUR_REACH_DEBUG
                extraReport('\nFOUND!\n');
                #endif
                return parkourReachSuccessful;
            }
            #if __PARKOUR_REACH_DEBUG
            extraReport('\nExit: <<testExitLoc.theName>>\n');
            #endif
            if (checkStagingExitLocationConnection(testExitLoc)) {
                #if __PARKOUR_REACH_DEBUG
                extraReport('\nFOUND!\n');
                #endif
                return parkourReachSuccessful;
            }

            return parkourReachTopTooFar;
        }
        #if __PARKOUR_REACH_DEBUG
        extraReport('\nParkour mod found on <<closestParkourMod.theName>>
            in <<closestParkourMod.getOutermostRoom().roomTitle>>.\n');
        #endif

        // Assuming source is prepared for parkour...
        if (closestParkourMod == self) return parkourReachSuccessful;

        #if __PARKOUR_REACH_DEBUG
        extraReport('\nSTANDARD PARKOUR CHECKS APPLY!\n');
        #endif

        #if __PARKOUR_REACH_DEBUG
        if (doNotFactorJump) {
            extraReport('\nDO NOT FACTOR JUMP!\n');
        }
        #endif

        for (local i = 1; i <= closestParkourMod.pathVector.length; i++) {
            local path = closestParkourMod.pathVector[i];
            if (path.destination != lexicalParent) continue;
            if (path.provider != nil) continue;
            if (path.requiresJump && !doNotFactorJump) continue;
            if (path.isKnown || canBeUnknown) {
                return parkourReachSuccessful;
            }
        }
        return parkourReachTopTooFar;
    }

    checkStagingExitLocationConnection(stagingExitLocation) {
        if (stagingExitLocation == self.lexicalParent) return true;
        if (stagingExitLocation == self.lexicalParent.remapOn) return true;
        if (checkStagingExitLocationConnectionRemap(
            stagingExitLocation, self.lexicalParent.remapIn
        )) return true;
        if (checkStagingExitLocationConnectionRemap(
            stagingExitLocation, self.lexicalParent.remapUnder
        )) return true;
        if (checkStagingExitLocationConnectionRemap(
            stagingExitLocation, self.lexicalParent.remapBehind
        )) return true;

        return nil;
    }

    checkStagingExitLocationConnectionRemap(stagingExitLocation, remapLoc) {
        if (remapLoc != nil) {
            if (remapLoc.partOfParkourSurface || remapLoc.isInReachOfParkourSurface) {
                return stagingExitLocation == remapLoc;
            }
        }

        return nil;
    }
}