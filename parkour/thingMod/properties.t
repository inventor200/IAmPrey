modify Thing {
    // If true, do not implicitly try an enter action for climb/jump into.
    // Just handle it as climb/jump to, instead.
    simplyRerouteClimbInto = nil
    // Can this Thing perform parkour?
    fitForParkour = nil
    // A list of TravelBarriers that prevent parkour with this Thing
    parkourBarriers = nil
    // Was this Thing recon'd for parkour?
    hasParkourRecon = (!parkourCore.requireRouteRecon)
    // Other Things that this will share recon with
    shareReconWith = []
    // This gets added to the above list, and should not be touched by authors
    shareReconWithProcedural = perInstance(new Vector())
    // Do not show get off option (standard containers)
    doNotSuggestGetOff = nil
    // Forced local platforms are:
    //     1. Forcefully added to the locals list.
    //     2. NEVER a container.
    //     3. Implement very strange overrides to parkour actions.
    //     4. Cannot qualify for a parkour module
    forcedLocalPlatform = nil
    // If true, allows a local platform to NEVER show in the locals list
    unlistedLocalPlatform = nil
    // Allows a local platform to be hidden from the list
    // until either searched or utilized
    secretLocalPlatform = nil
    // The preferred action for using this local platform
    preferredBoardingAction = nil
    // The opposite side of a possible two-sided local platform
    oppositeLocalPlatform = nil
    // After moving into the destination, the traveler will be moved
    // to the destination platform
    destinationPlatform = nil
    // Has the player been here before?
    // SET WITH markAsClimbed()
    // GET WITH hasBeenClimbed()
    playerClimbed = nil

    // Objects to inject into the list of locals
    // This is used on the platform itself
    getBonusLocalPlatforms() {
        return nil;
    }

    doProviderAccident(actor, traveler, path) {
        // For author implementation
    }

    doAccident(actor, traveler, path) {
        // For author implementation
    }

    doClimbPunishment(actor, traveler, path) {
        // For author implementation
    }

    doJumpPunishment(actor, traveler, path) {
        // For author implementation
    }

    doHarmfulPunishment(actor, traveler, path) {
        // For author implementation
    }

    checkAsParkourProvider(actor, traveler, path) {
        return true;
    }

    // Best for parkour surfaces only
    canBonusReachDuring(obj, action) {
        return nil;
    }

    // remapReach(action) is best for parkour surfaces only
}