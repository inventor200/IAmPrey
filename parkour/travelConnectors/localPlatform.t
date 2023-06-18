class LocalClimbPlatform: TravelConnector, Fixture {
    forcedLocalPlatform = true
    isConnectorListed = !secretLocalPlatform
    destinationPlatform = (
        oppositeLocalPlatform == nil ? nil :
        (oppositeLocalPlatform.stagingLocation)
    )
    destination = (otherSide.getOutermostRoom())

    localAliasPlatform = self

    localPlatformGoesUpMsg =
        '{I} must go up to do that. '
    localPlatformGoesDownMsg =
        '{I} must go down to do that. '

    dobjFor(TravelVia) {
        preCond = (isOpenable ?
            [travelPermitted, actorInStagingLocation, objOpen] :
            [travelPermitted, actorInStagingLocation]
        )
    }

    dobjFor(Search) {
        preCond = [actorInStagingLocation]
        remap = nil
        verify() { }
        action() {
            doParkourSearch();
        }
    }

    TravelConnectorUsesParkour
}