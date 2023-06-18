#define hyperDir(dirName) \
    (exitLister.enableHyperlinks ? \
        aHrefAlt( \
            sneakyCore.getDefaultTravelAction() + \
            ' ' + dirName, \
            dirName, \
            dirName \
        ) : dirName)

#define handleComplexPeekThrough(mcRoom, mcNamePhrase, mcRemoteHeader) \
    say('{I} carefully peek{s/ed} ' + mcNamePhrase + '...<.p>'); \
    mcRoom.observeFrom(gActor, mcRemoteHeader)

#define handleCustomPeekThrough(mcRoom, mcRemoteHeader) \
    handleComplexPeekThrough(mcRoom, mcRemoteHeader, mcRemoteHeader)

#define handlePeekThrough(mcRemoteHeader) \
    handleComplexPeekThrough(otherSide.getOutermostRoom(), mcRemoteHeader, mcRemoteHeader)

#define attachPeakingAbility(mcRemoteHeader) \
    requiresPeekAngle = true \
    canLookThroughMe = true \
    skipInRemoteList = true \
    remoteHeader = mcRemoteHeader \
    remappingLookIn = true \
    dobjFor(PeekThrough) asDobjFor(LookThrough) \
    dobjFor(PeekInto) asDobjFor(LookThrough) \
    dobjFor(LookIn) asDobjFor(LookThrough) \
    dobjFor(LookThrough) { \
        action() { } \
        report() { \
            handlePeekThrough(remoteHeader); \
        } \
    }

#define catFlapDesc 'At the bottom of this door is a cat flap.'