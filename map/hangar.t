hangarSightLine: HallRegion;

storageBay: Room { 'The Storage Bay'
    "TODO: Add description. "

    northwest = loadingArea
    north = wasteProcessingEntry
    south = freezerNorthEntry

    westMuffle = labB
    southwestMuffle = evaluationRoom

    regions = [hangarSightLine]
    floorObj = cementFloor
    ceilingObj = industrialCeiling

    roomDaemon() {
        checkRoomDaemonTurns;
        northFreezerFog.rollingDesc(freezerNorthEntry);
        inherited();
    }

    mapModeDirections = [&northwest, &south, &east]
    mapModeLockedDoors = [wasteProcessingEntry]
    familiar = roomsFamiliarByDefault
}

+wasteProcessingEntry: MaintenanceDoor { 'the waste processing door'
    desc = lockedDoorDescription
    otherSide = southUtilityPassageExit
    travelBarriers = [wasteProcessingBarrier]
    pullHandleSide = true
}

wasteProcessingBarrier: TravelBarrier {
    canTravelerPass(actor, connector) {
        return actor == skashek || !connector.isOpen;
    }
    
    explainTravelBarrier(actor, connector) {
        "<<gSkashekName>> has apparently modified the facility
        into a game arena. Though he is hunting you, he has also
        crafted a <q>fair</q> environment, as it includes a means
        of escape.\b
        Whatever waits on the other side of <i>that door</i>,
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
    
    floorObj = cementFloor
    ceilingObj = industrialCeiling

    mapModeDirections = [&west, &east]
    familiar = roomsFamiliarByDefault
}

+airlockInsideEntry: PrefabDoor { 'the Emergency Airlock door'
    airlockDoorDesc
    otherSide = airlockInsideExit

    airlockDoor = true
    isTransparent = true
    canSlamMe = nil
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
    
    floorObj = cementFloor
    ceilingObj = industrialCeiling
    mapModeLockedDoors = [wasteProcessingExit]
}

+wasteProcessingExit: MaintenanceDoor { 'the waste processing exit'
    desc = lockedDoorDescription
    otherSide = wasteProcessingEntry
    soundSourceRepresentative = wasteProcessingEntry
    pullHandleSide = nil
}

emergencyAirlock: Room { 'The Emergency Airlock'
    "TODO: Add description. "

    east = airlockOutsideExit
    west = airlockInsideExit

    mapModeDirections = [&east, &west]
    familiar = roomsFamiliarByDefault
}

+airlockInsideExit: PrefabDoor { 'the inner exit door'
    airlockDoorDesc
    otherSide = airlockInsideEntry
    soundSourceRepresentative = airlockInsideEntry

    airlockDoor = true
    isTransparent = true
    canSlamMe = nil
}

+airlockOutsideExit: PrefabDoor { 'the outer exit door'
    airlockDoorDesc
    otherSide = airlockOutsideEntry
    soundSourceRepresentative = airlockOutsideEntry

    airlockDoor = true
    canSlamMe = nil

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

    west = airlockOutsideEntry

    mapModeDirections = [&west]
}

+airlockOutsideEntry: PrefabDoor { 'the outer Airlock door'
    airlockDoorDesc
    otherSide = airlockOutsideExit

    airlockDoor = true
    canSlamMe = nil
}