modify Thing {
    getPreferredBoardingAction() {
        if (preferredBoardingAction != nil) return preferredBoardingAction;
        if (isEnterable) return Enter;
        if (canClimbUpMe) return ClimbUp;
        if (canClimbDownMe) return ClimbDown;
        if (isClimbable) return Climb;
        return Board;
    }

    getLocalPlatformBoardingCommand() {
        local prefAct = getPreferredBoardingAction();
        return prefAct.getVerbPhrase1(
            true, prefAct.verbRule.verbPhrase, theName, nil
        ).trim().toLower();
    }

    omitFromStagingError() {
        // There isn't anything to suggest, so omit it.
        if (stagingLocation == nil) return true;

        // Being on the floor is obvious
        if (stagingLocation.ofKind(Room)) return nil;

        // Being on the same surface as it is obvious
        if (stagingLocation == gMoverLocationFor(gPlayerChar)) return nil;

        // The rest is not obvious
        if (parkourCore.requireRouteRecon) {
            if (forcedLocalPlatform) return secretLocalPlatform;
            if (hasParkourRecon) return nil;
            return !hasBeenClimbed();
        }
        return nil;
    }

    // Do any solvers searching for local platforms consider this?
    omitFromLogicalLocalsList() {
        if (parkourCore.requireRouteRecon) {
            return secretLocalPlatform;
        }
        return nil;
    }

    // Do any printed lists for local platforms consider this?
    omitFromPrintedLocalsList() {
        if (unlistedLocalPlatform) return true;
        if (parkourCore.requireRouteRecon) {
            return secretLocalPlatform;
        }
        return nil;
    }

    standardDoNotSuggestGetOff() {
        if (doNotSuggestGetOff) return true;
        if (remapOn != nil) {
            return remapOn.doNotSuggestGetOff;
        }
        return nil;
    }

    getRouteListString() {
        local closestParkourMod = getParkourModule();
        if (!isStandardPlatform(true, closestParkourMod != nil)) {
            if (closestParkourMod != nil) {
                return closestParkourMod.getRouteListString();
            }
            return '';
        }

        if (remapOn != nil) {
            return remapOn.getRouteListString();
        }

        // Standard platform alternative
        if (standardDoNotSuggestGetOff()) {
            return '';
        }

        local strBfr = new StringBuffer(20);
        if (!parkourCore.formatForScreenReader) {
            parkourCore.loadParkourKeyHint(strBfr);
        }
        loadGetOffSuggestion(strBfr, nil, nil);
        return toString(strBfr);
    }

    loadGetOffSuggestion(strBfr, requiresJump, isHarmful) {
        if (standardDoNotSuggestGetOff()) return;
        if (parkourCore.formatForScreenReader) {
            strBfr.append('\n{I} believe{s/d} {i} {can} <b>');
            if (requiresJump) {
                strBfr.append('JUMP OFF');
            }
            else {
                strBfr.append('GET OFF');
            }
            strBfr.append('</b> to reach ');
            strBfr.append(getExitLocationName());
            strBfr.append('. ');
            if (isHarmful) {
                strBfr.append('However, this action seems dangerous. ');
            }
        }
        else {
            strBfr.append(getBulletPoint(requiresJump, isHarmful));
            local commandText = ' GET OFF';
            if (requiresJump) {
                commandText = ' JUMP OFF';
            }
            strBfr.append(formatCommand(commandText, longCmd));
        }
    }

    checkProviderAccident(actor, traveler, path) {
        local hadAccident = gOutStream.watchForOutput({:
            doProviderAccident(actor, traveler, path)
        });
        parkourCore.hadAccident = parkourCore.hadAccident || hadAccident;
        return !hadAccident;
    }

    getPlatformName() {
        if (forcedLocalPlatform) return theName;
        local pm = getParkourModule();
        if (pm != nil) return pm.theName;
        return theName;
    }

    getExitLocationName() {
        if (exitLocation == nil) return 'the void';
        if (parkourModule != nil) {
            return getBetterDestinationName(parkourModule);
        }
        return exitLocation.theName;
    }
    
    getBetterDestinationName(destination, usePrep?, intelOverride?) {
        local roomA = gMover.getOutermostRoom();
        local roomB = destination.getOutermostRoom();
        local prep = destination.objInPrep + ' ';

        if (roomA == roomB) {
            return (usePrep ? prep : '') + destination.theName;
        }
        if (roomB.visited || intelOverride) {
            if (destination.lexicalParent.ofKind(Room)) {
                prep = destination.lexicalParent.objInPrep + ' ';
                return (usePrep ? prep : '') + destination.lexicalParent.theName;
            }
            return (usePrep ? prep : '') + '<<destination.theName>>
                (<<roomB.objInPrep>> <<roomB.theName>>)';
        }

        prep = 'to ';
        return (usePrep ? prep : '') + 'another location';
    }
}