modify Door {
    oppositeLocalPlatform = (otherSide)
    destination = (otherSide.getOutermostRoom())
    destinationPlatform = (
        oppositeLocalPlatform == nil ? nil :
        (oppositeLocalPlatform.stagingLocation)
    )
    stagingLocation = (location)

    configureDoorOrPassageAsLocalPlatform(GoThrough)

    dobjFor(GoThrough) {
        preCond = [travelPermitted, actorInStagingLocation, objOpen]
    }

    dobjFor(Open) {
        action() {
            inherited();
            if (!gAction.isImplicit) {
                learnOnlyLocalPlatform(self, reportAfter);
            }
        }
    }

    getParkourModule() {
        return location.parkourModule;
    }

    TravelConnectorUsesParkour
}