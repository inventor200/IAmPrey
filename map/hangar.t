hangarSightLine: HallRegion;

storageBay: Room { 'The Storage Bay'
    "The Bay connects seamlessly to the Hangar,
    with only a massive, pressure membrane keeping both areas distinct.
    The space is mostly littered with empty, plastic pallets.\b
    To the <<hyperDir('west')>> is the Loading Area, and the <b>Emergency
    Airlock</b> is visible on the <<hyperDir('east')>> side of the Hangar. "

    west = loadingArea
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

    mapModeDirections = [&west, &south, &east]
    mapModeLockedDoors = [wasteProcessingEntry]
    familiar = roomsFamiliarByDefault
    roomNavigationType = bigRoom
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
        into a game arena. Though he{dummy} is hunting {me}, he has also
        crafted a <q>fair</q> environment, as it includes a means
        of escape.\b
        Whatever waits on the other side of <i>that door</i>,
        however, would be the <i>purest</i> expression of desperate
        evasion, <i>with zero chances of survival</i>.\b
        Maybe {i} should take {my} chances with the plausible exit
        that <<gSkashekName>> has permitted, and remain on <i>this</i>
        side of the door... ";
    }
}

hangar: Room { 'The Hangar'
    "The Hangar boasts the highest of ceilings, and is separated from
    the Storage Bay (<<hyperDir('west')>>) by a pressure membrane.\b
    To the <<hyperDir('east')>> is the Emergency Airlock. "

    regions = [hangarSightLine]

    east = airlockInsideEntry
    
    floorObj = cementFloor
    ceilingObj = industrialCeiling

    mapModeDirections = [&west, &east]
    familiar = roomsFamiliarByDefault
    roomNavigationType = bigRoom
}

+airlockInsideEntry: PrefabDoor { 'the Emergency Airlock door'
    airlockDoorDesc
    otherSide = airlockInsideExit

    airlockDoor = true
    isTransparent = true
    canSlamMe = nil
}

DefineBrokenWindowPairLookingAway(east, west, hangar, storageBay)
    vocab = 'pressure membrane;plastic rubber greasy marked[weak];veil curtain sheet slit'
    desc = "A colossal membrane divides the area into two sections: The Storage Bay, and Hangar.
    The membrane is organic, and has reflexes to seal off the Hangar, in the event of a poison
    gas contamination event. It's transparent, and gives everything behind it a blurry, streaky effect.\b
    There is a single, large slit in the middle, which can be passed through. It jiggles a little, as the
    surface is still very alive. "
    feelDesc = "It feels greasy, like a giant, lubricated condom. "
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
    "The emergency airlock is cramped tube, full of bright colors,
    allowing anyone to identify it in a hurry. "

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
    those{dummy} who wanted to control {me}.
    Luckily, the suit{dummy} allows
    {me} to walk through it all. "

    west = airlockOutsideEntry

    mapModeDirections = [&west]
}

+airlockOutsideEntry: PrefabDoor { 'the outer Airlock door'
    airlockDoorDesc
    otherSide = airlockOutsideExit

    airlockDoor = true
    canSlamMe = nil
}