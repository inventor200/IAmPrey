enum parkourUpDir, parkourOverDir, parkourDownDir;

class ParkourPath: object {
    destination = nil
    provider = nil
    requiresJump = nil
    isHarmful = nil
    direction = parkourOverDir
    isAcknowledged = (!parkourCore.requireRouteRecon)
    maker = nil
    cachedOtherSide = nil
    isBackward = nil
    otherSide() {
        if (maker != nil) {
            cachedOtherSide = maker.createdOtherSide(isBackward);
            maker = nil;
        }
        return cachedOtherSide;
    }

    isProviderKnown = (provider == nil ? nil : provider.hasParkourRecon)
    isProviderEffectivelyKnown = (provider == nil ? true : provider.hasParkourRecon)
    isKnown = (destination.hasParkourRecon && isProviderEffectivelyKnown)

    injectedDiscoverMsg = nil
    injectedPerformMsg = nil
    injectedParkourBarriers = nil
    injectedPathDescription = nil

    acknowledge() {
        isAcknowledged = true;
        if (otherSide() != nil) {
            otherSide().isAcknowledged = true;
        }
    }

    getScore() {
        local score = 0;
        if (isHarmful) score += 4;
        if (requiresJump) score += 2;
        if (provider != nil) score++;
        return score;
    }

    getDiscoverMsg() {
        if (injectedDiscoverMsg != nil) {
            return injectedDiscoverMsg;
        }

        if (provider != nil) {
            if (provider.canJumpOverMe) {
                return provider.getJumpOverToDiscoverMsg(destination.parkourModule);
            }
            if (provider.canRunAcrossMe) {
                return provider.getRunAcrossToDiscoverMsg(destination.parkourModule);
            }
            if (provider.canSwingOnMe) {
                return provider.getSwingOnToDiscoverMsg(destination.parkourModule);
            }
            if (provider.canSlideUnderMe) {
                return provider.getSlideUnderToDiscoverMsg(destination.parkourModule);
            }
            if (provider.canSqueezeThroughMe) {
                return provider.getSqueezeThroughToDiscoverMsg(destination.parkourModule);
            }
        }

        if (requiresJump) {
            switch (direction) {
                case parkourUpDir:
                    return destination.parkourModule.getJumpUpDiscoverMsg();
                case parkourOverDir:
                    return destination.parkourModule.getJumpOverDiscoverMsg();
                case parkourDownDir:
                    return destination.parkourModule.getJumpDownDiscoverMsg();
            }
        }

        switch (direction) {
            case parkourOverDir:
                return destination.parkourModule.getClimbOverDiscoverMsg();
            case parkourDownDir:
                return destination.parkourModule.getClimbDownDiscoverMsg();
        }

        return destination.parkourModule.getClimbUpDiscoverMsg();
    }

    getPerformMsg() {
        if (injectedPerformMsg != nil) {
            return injectedPerformMsg;
        }

        if (provider != nil) {
            if (provider.canJumpOverMe) {
                return provider.getJumpOverToMsg(destination.parkourModule);
            }
            if (provider.canRunAcrossMe) {
                return provider.getRunAcrossToMsg(destination.parkourModule);
            }
            if (provider.canSwingOnMe) {
                return provider.getSwingOnToMsg(destination.parkourModule);
            }
            if (provider.canSlideUnderMe) {
                return provider.getSlideUnderToMsg(destination.parkourModule);
            }
            if (provider.canSqueezeThroughMe) {
                return provider.getSqueezeThroughToMsg(destination.parkourModule);
            }
        }

        if (requiresJump) {
            if (isHarmful) {
                return destination.parkourModule.getFallDownMsg();
            }
            switch (direction) {
                case parkourUpDir:
                    return destination.parkourModule.getJumpUpMsg();
                case parkourOverDir:
                    return destination.parkourModule.getJumpOverMsg();
                case parkourDownDir:
                    return destination.parkourModule.getJumpDownMsg();
            }
        }

        switch (direction) {
            case parkourOverDir:
                return destination.parkourModule.getClimbOverMsg();
            case parkourDownDir:
                return destination.parkourModule.getClimbDownMsg();
        }

        return destination.parkourModule.getClimbUpMsg();
    }

    isSafeForAutoParkour() {
        if (requiresJump) return nil;
        if (isHarmful) return nil;
        return true;
    }
}

class ParkourPathMaker: PreinitObject {
    execBeforeMe = [distributedComponentDistributor]

    location = nil
    destination = nil
    provider = nil
    requiresJump = nil
    isHarmful = nil
    direction = parkourOverDir

    discoverMsg = nil
    performMsg = nil
    parkourBarriers = nil
    pathDescription = nil

    startKnown = nil

    otherSide = nil
    createdForward = nil
    createdBackward = (otherSide != nil ? otherSide.createdForward : nil)
    createdOtherSide(isBackward) {
        if (isBackward) return createdForward;
        return createdBackward;
    }

    getTrueLocation() {
        if (location.ofKind(SubComponent)) {
            return location.lexicalParent;
        }
        return location;
    }

    getTrueDestination() {
        if (destination.ofKind(SubComponent)) {
            return destination.lexicalParent;
        }
        return destination;
    }

    execute() {
        getTrueLocation().prepForParkour();
        getTrueDestination().prepForParkour();
        createForwardPath();
        createBackwardPath();
    }

    createForwardPath() {
        createdForward = getNewPathObject(startKnown);
        createdForward.maker = self;
        getTrueLocation().parkourModule.addPath(createdForward);
        return createdForward;
    }

    createBackwardPath() { }

    getNewPathObject(startKnown_?) {
        local path = new ParkourPath();
        path.injectedPathDescription = pathDescription;
        path.injectedDiscoverMsg = discoverMsg;
        path.injectedPerformMsg = performMsg;
        path.injectedParkourBarriers = parkourBarriers;
        path.destination = getTrueDestination();
        path.provider = provider;
        path.requiresJump = requiresJump;
        path.isHarmful = isHarmful;
        path.direction = direction;
        if (startKnown_) {
            path.isKnown = true;
            path.isAcknowledged = true;
        }
        return path;
    }
}

// Creates a blank parkour module with no paths.
// Why? To fake standardized responses!
class BlankParkourInit: ParkourPathMaker {
    execute() {
        getTrueLocation().prepForParkour();
    }
}

// Two-way
class ParkourLinkMaker: ParkourPathMaker {
    requiresJumpBack = (requiresJump)
    isHarmfulBack = (isHarmful)

    pathDescription = (forwardPathDescription)
    discoverMsg = (discoverForwardMsg)
    performMsg = (performForwardMsg)
    parkourBarriers = (forwardParkourBarriers)
    forwardPathDescription = nil // Just to circumvent mistakes
    discoverForwardMsg = nil // Just to circumvent mistakes
    performForwardMsg = nil // Just to circumvent mistakes
    forwardParkourBarriers = nil // Just to circumvent mistakes
    backwardPathDescription = nil
    discoverBackwardMsg = nil
    performBackwardMsg = nil
    backwardParkourBarriers = nil

    startKnown = (startForwardKnown)
    startForwardKnown = nil // Just to circumvent mistakes
    startBackwardKnown = nil

    createBackwardPath() {
        createdBackward = getNewPathObject(startBackwardKnown);
        createdBackward.maker = self;
        createdBackward.isBackward = true;
        createdBackward.injectedPathDescription = backwardPathDescription;
        createdBackward.injectedDiscoverMsg = discoverBackwardMsg;
        createdBackward.injectedPerformMsg = performBackwardMsg;
        createdBackward.injectedParkourBarriers = backwardParkourBarriers;
        createdBackward.destination = getTrueLocation();
        createdBackward.requiresJump = requiresJumpBack;
        createdBackward.isHarmful = isHarmfulBack;
        switch (createdBackward.direction) {
            case parkourUpDir:
                createdBackward.direction = parkourDownDir;
                break;
            case parkourDownDir:
                createdBackward.direction = parkourUpDir;
                break;
        }
        getTrueDestination().parkourModule.addPath(createdBackward);
    }
}

// Floor heights
class FloorHeight: ParkourLinkMaker {
    destination = (location.stagingLocation)
    requiresJump = nil
    isHarmful = nil
    requiresJumpBack = nil
    isHarmfulBack = nil
    direction = parkourDownDir

    createForwardPath() {
        getTrueLocation().parkourModule.addPath(getNewPathObject(true));
    }

    createBackwardPath() {
        local backPath = getNewPathObject(startKnown || startBackwardKnown);
        backPath.destination = location;
        backPath.direction = parkourUpDir;
        backPath.requiresJump = requiresJumpBack;
        backPath.isHarmful = isHarmfulBack;
        destination.parkourModule.addPath(backPath);
    }
}