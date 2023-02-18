hangarSightLine: HallRegion;

#define airlockDoorDesc "TODO: Add description. "

storageBay: Room { 'The Storage Bay'
    "TODO: Add description. "

    west = loadingArea
    north = wasteProcessingEntry

    regions = [hangarSightLine]
}

+wasteProcessingEntry: MaintenanceDoor { 'the waste processing door'
    desc = lockedDoorDescription
    otherSide = southUtilityPassageExit
    travelBarriers = [wasteProcessingBarrier]
}

wasteProcessingBarrier: TravelBarrier {
    canTravelerPass(actor, connector) {
        return actor == skashek;
    }
    
    explainTravelBarrier(actor, connector) {
        "<<gSkashekName>> has apparently modified the facility
        into a game arena. Though he is hunting you, he has also
        crafted a <q>fair</q> environment, as it includes a means
        of escape.\b
        Whatever waits on the other side of the waste processing door,
        however, would be the <i>purest</i> expression of desperate
        evasion, <i>with zero chances of survival</i>.\b
        Maybe you should take your chances with the plausible exit
        that <<gSkashekName>> has permitted, and remain on <i>this</i>
        side of the door... ";
    }
}

hangar: Room { 'The Hangar'
    "TODO: Add description. "

    regions = [hangarSightLine]

    east = airlockInsideEntry
}

+airlockInsideEntry: Door { 'the emergency airlock door'
    airlockDoorDesc
    otherSide = airlockInsideExit
    oppositeAirlockDoor = airlockOutsideExit

    airlockDoor = true
    isTransparent = true
}

DefineBrokenWindowPairLookingAway(east, west, hangar, storageBay)
    vocab = 'pressure membrane;plastic rubber;veil curtain sheet'
    desc = "TODO: Add description. "
    breakMsg = 'The membrane absolutely refuses to be torn, cut, or sliced in any way. '
    remoteHeader = 'through the membrane'
    travelDesc = "{I} pass{es/ed} through a marked slit
        in the greasy pressure membrane. "
;

wasteProcessing: Room { 'Waste Processing'
    "An ominous, dark corridor. It does not likely connect to
    the rest of the facility, so entry might be more of a death
    trap than a valid escape route. "

    south = wasteProcessingExit
}

+wasteProcessingExit: MaintenanceDoor { 'the waste processing exit'
    desc = lockedDoorDescription
    otherSide = wasteProcessingEntry
    soundSourceRepresentative = wasteProcessingEntry
}

emergencyAirlock: Room { 'The Emergency Airlock'
    "TODO: Add description. "

    east = airlockOutsideExit
    west = airlockInsideExit
}

+airlockInsideExit: Door { 'the inner exit door'
    airlockDoorDesc
    otherSide = airlockInsideEntry
    oppositeAirlockDoor = airlockOutsideExit
    soundSourceRepresentative = airlockInsideEntry

    airlockDoor = true
    isTransparent = true
}

+airlockOutsideExit: Door { 'the outer exit door'
    airlockDoorDesc
    otherSide = airlockOutsideEntry
    oppositeAirlockDoor = airlockInsideExit
    soundSourceRepresentative = airlockOutsideEntry

    airlockDoor = true

    dobjFor(Open) {
        verify() {
            // TODO: Check for suit pieces.
            logical;
        }
        action() {
            epilogueCore.leaveFacility();
        }
        report() { }
    }
}

fakeOutside: Room { 'Outside the Facility'
    "Ominous toxic fumes fill the air; a measure taken by
    those who wanted to control you. Luckily, the suit allows
    you to walk through it all. "
}

+airlockOutsideEntry: Door { 'the outer airlock door'
    airlockDoorDesc
    otherSide = airlockOutsideExit
    oppositeAirlockDoor = airlockInsideExit

    airlockDoor = true
}