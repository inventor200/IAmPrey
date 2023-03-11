utilityPassage: Room { 'The Utility Corridor'
    "TODO: Add description. "

    northeast = northUtilityPassageExit
    south = southUtilityPassageExit

    northwestMuffle = enrichmentRoom
    southeastMuffle = breakroom
    westMuffle = cloneQuarters
}

+southUtilityPassageExit: MaintenanceDoor { 'the south-end exit door'
    desc = lockedDoorDescription
    otherSide = southUtilityPassageEntry
    soundSourceRepresentative = southUtilityPassageEntry
    pullHandleSide = nil
}

+northUtilityPassageExit: MaintenanceDoor { 'the door to[weak] life support'
    desc = lockedDoorDescription
    otherSide = northUtilityPassageEntry
    pullHandleSide = true
}

+utilityWallPipes: PassablePipes { 'pipes[n] on[prep] the wall;west[weak] w[weak] in[prep] the wall[n];tubing tubes hole'
    desc = "Part of the wall here has been demolished, leaving some pipes exposed.<<
        observeHistory()>> "
    destination = cloneQuarters
    destinationPlatform = southeastCloneBed.remapUnder
    oppositeLocalPlatform = underBedWallPipes

    foundOtherSide = nil

    specialDesc = "Some pipes are exposed through a hole in the west wall. "

    travelDesc = "<<if gCatMode
        >>You easily slip between the pipes in the wall<<else
        >>It's a tight squeeze, but you manage to fit between the pipes
        in the wall<<end>>, and crawl under a bed on the other side. "

    observedHistory = nil

    observeHistory() {
        if (observedHistory) return '';
        observedHistory = true;
        if (gCatMode) return 'You remember watching the original citizens doing
            this, just before the killing started.
            You were not sure of the <i>reason</i>, but it\'s safe to assume that it was
            important to your kingdom, somehow. They tried to hide this, originally,
            but <<gSkashekName>> eventually left it exposed.';
        return '';
    }

    dobjFor(LookThrough) {
        preCond = [objVisible, touchObj]
        action() {
            underBedWallPipes.spotFromOtherSide();
        }
        report() {
            "{I} {find} that the wall on the other side has been preserved, except for
            the bottom fourth, which has been demolished. Not much{dummy} {is}
            visible from this side,<<if foundOtherSide>>
            as a result<<else>>
            but if {i} reach{s/ed} the other side, this
            this could prove to be a useful way to peek through to this corridor<<end>>. ";
        }
    }

    dobjFor(TravelVia) {
        action() {
            // Make sure there's a destination waiting for us lol
            underBedWallPipes.revealUnderBed();
            southeastCloneBed.remapUnder.hiddenUnder = [];
            inherited();
        }
    }
}

southUtilityPassageEntry: MaintenanceDoor { 'the south-end access door' @southHall
    desc = lockedDoorDescription
    otherSide = southUtilityPassageExit
    pullHandleSide = true
}

northUtilityPassageEntry: MaintenanceDoor { 'the exit door' @lifeSupportTop
    desc = lockedDoorDescription
    otherSide = northUtilityPassageExit
    soundSourceRepresentative = northUtilityPassageExit
    pullHandleSide = nil
}

class PassablePipes: LocalClimbPlatform {
    secretLocalPlatform = true
    plural = true
    preferredBoardingAction = SqueezeThrough

    dobjFor(SlideUnder) asDobjFor(TravelVia)
    dobjFor(SqueezeThrough) asDobjFor(TravelVia)

    dobjFor(PeekBetween) asDobjFor(LookThrough)
    attachPeakingAbility('between the pipes')

    // Intercept reveal for other side; it looks redundant in practice
    dobjFor(TravelVia) {
        action() {
            oppositeLocalPlatform.secretLocalPlatform = nil;
            inherited();
        }
    }

    lookInMsg = '{The subj dobj} {is} not something {i} {can} peek into.
        {I} <i>could</i> peek <i>through</i> {him dobj}, however. '
}