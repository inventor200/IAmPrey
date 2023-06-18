class ClimbUpPlatform: LocalClimbPlatform {
    preferredBoardingAction = Climb
    setPreferredClimbToDirection(Up, Down)
    rejectClimbInto
}

class ClimbUpIntoPlatform: LocalClimbPlatform {
    preferredBoardingAction = Climb
    setPreferredClimbToDirection(Up, Down)
    acceptClimbIntoDirection(Up, Down)
    dobjFor(Enter) asDobjFor(TravelVia)
    dobjFor(GoThrough) asDobjFor(TravelVia)
}

class ClimbUpEnterPlatform: ClimbUpIntoPlatform {
    preferredBoardingAction = Enter
}

class ClimbDownPlatform: LocalClimbPlatform {
    preferredBoardingAction = ClimbDown
    setPreferredClimbToDirection(Down, Up)
    rejectClimbInto
}

class ClimbDownIntoPlatform: LocalClimbPlatform {
    preferredBoardingAction = ClimbDown
    setPreferredClimbToDirection(Down, Up)
    acceptClimbIntoDirection(Down, Up)
    dobjFor(Enter) asDobjFor(TravelVia)
    dobjFor(GoThrough) asDobjFor(TravelVia)
}

class ClimbDownEnterPlatform: ClimbDownIntoPlatform {
    preferredBoardingAction = Enter
}