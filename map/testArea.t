TEST_centralRoom: Room { 'Central Room'
    "The main room in the center."

    north = TEST_hallwayDoor
    westMuffle = TEST_sideRoom
    //east = TEST_eastGap

    mapModeDirections = [&north]
}

+TEST_hallwayDoor: PrefabDoor { 'Hallway door'
    "The door to the hallway. <<catFlapDesc>> "
    otherSide = TEST_centralRoomDoor
    pullHandleSide = nil
}

+TEST_cargoShelf: FixedPlatform { 'tall cargo shelf'
    "A tall series of cargo shelves. "
    isListed = true
}
++DangerousFloorHeight;

++TEST_bottle: Thing { 'water bottle'
    "A difficult water bottle. "
}

++TEST_dogCage: Booth { 'dog cage'
    "A weird dog cage. "
}

+TEST_cabinet: Fixture { 'tall lab cabinet'
    "A locked, metal cabinet, likely containing lab materials. "
    isListed = true

    betterStorageHeader
    IncludeDistComponent(ContainerGrate)
    IncludeDistComponent(TinyDoorHandle)

    remapIn: SubComponent {
        isOpenable = true
        isEnterable = true
        //includeGrate(TEST_cabinet)
    }
    remapOn: SubComponent {
        isBoardable = true
    }
}
++HighFloorHeight;
++ClimbUpLink ->TEST_cargoShelf;

++TEST_grayCrate: FixedPlatform { 'gray crate;grey'
    "A gray crate. It looks suspiciously-boring to climb on. "
    subLocation = &remapOn
    isListed = true
}

++TEST_blueCrate: FixedPlatform { 'blue crate'
    "A gray crate. It looks suspiciously-fun to climb on. "
    subLocation = &remapOn
    isListed = true
}
+++LowFloorHeight;

++TEST_cup: Thing { 'cup'
    "A ceramic cup. "
    subLocation = &remapOn
}

+TEST_exosuit: CoveredVehicle { 'exosuit;small exo;suit'
    "A small exosuit, not much larger than a person. "
    fitForParkour = true
}

+TEST_metalCrate: FixedPlatform { 'metal crate'
    "A big metal crate, sitting alone in the corner. "
    //parkourBarriers = [TEST_fragileCrateBarrier]
    /*doAccident(actor, traveler, path) {
        traveler.moveInto(TEST_centralRoom);
        "{I} {swing} on the flagpole, and land{s/ed} on the metal crate,
        but it collapses, and {i} {am} thrown to the floor. ";
    }*/
}
++LowFloorHeight;

+TEST_fragileCrateBarrier: TravelBarrier {
    canTravelerPass(actor, connector) {
        return nil;
    }
    
    explainTravelBarrier(actor, connector) {
        "The crate doesn't seem very sturdy... ";
    }
}

+TEST_flagPole: Fixture { 'flagpole'
    "A barren flagpole, sticking horizontally out of the wall,
    between the lab desk and metal crate. "
    isListed = true
    canSwingOnMe = true
    //parkourBarriers = [TEST_fragilePoleBarrier]
    /*doProviderAccident(actor, traveler, path) {
        traveler.moveInto(TEST_centralRoom);
        "{I} {swing} on the flagpole, but only for a moment.
        With a horrible, metal-wrenching sound, the pole snaps
        free of the wall, dropping {me} to the floor. ";
    }*/
}

/*+TEST_fragilePoleBarrier: TravelBarrier {
    canTravelerPass(actor, connector) {
        return nil;
    }
    
    explainTravelBarrier(actor, connector) {
        "The pole seems flimsy... ";
    }
}*/

+TEST_desk: FixedPlatform { 'lab desk'
    "A simple lab desk. "
    isListed = true
    canSlideUnderMe = true
}
++LowFloorHeight;
++ClimbUpLink -> TEST_cabinet;
++JumpUpLink -> TEST_cargoShelf
    pathDescription = 'scale the cargo shelves'
;
++ProviderLink @TEST_flagPole ->TEST_metalCrate;

+TEST_table: FixedPlatform { 'generic table'
    "A generic table, outside of any parkour system. "
    isListed = true
    //doNotSuggestGetOff = true
}

++TEST_puzzleCube: Trinket { 'puzzle cube'
    "A 3x3 puzzle cube. "
}

++TEST_postItNote: Thing { 'note;postit post-it post sticky'
    "A simple note. "
    readDesc = "Hello world!"
}

/*+TEST_eastGap: ParkourBridgeConnector { 'east gap;eastern;divide'
    "The eastern wall has a hole, and a sudden drop-off meets the floor there. "
    isListed = true
    canJumpOverMe = true
}*/

+TEST_eastPillar: Fixture { 'east pillar;e'
    "A pillar to the east. "
}

+TEST_westPillar: Fixture { 'west pillar;w'
    "A pillar to the west. "
}

+TEST_northPorthole: Fixture { 'north porthole;n'
    "A weird porthole. "

    canLookThroughMe = true

    dobjFor(PeekThrough) asDobjFor(LookThrough)
    dobjFor(LookThrough) {
        action() {
            "You peek through the porthole. ";
        }
        report() { }
    }
}

//+AwkwardProviderBridge @TEST_eastGap ->TEST_subtleRoom @TEST_westGap;

TEST_sideRoom: Room { 'Side Room'
    "The additional room to the side."

    north = TEST_centerHallway
    eastMuffle = TEST_centralRoom

    mapModeDirections = [&north]
}

TEST_longHallway: SenseRegion {
    //
}

TEST_centerHallway: Room { 'Hallway (Center)'
    "The central section of a long hallway. "

    southeast = TEST_centralRoomDoor
    southwest = TEST_sideRoom
    east = TEST_eastHallway

    regions = [TEST_longHallway]

    mapModeDirections = [&east, &southeast, &southwest]
}

+TEST_centralRoomDoor: PrefabDoor { 'Central Room door'
    "The door to the central room. <<catFlapDesc>> "
    otherSide = TEST_hallwayDoor
    pullHandleSide = true
}

TEST_eastHallway: Room { 'Hallway (East)'
    "The eastern section of a long hallway. "
    west = TEST_centerHallway
    south = TEST_subtleRoom

    regions = [TEST_longHallway]

    mapModeDirections = [&south, &west]
}

// East of central room
TEST_subtleRoom: Room { 'Subtle Room'
    "Just a subtle room. "
    north = TEST_eastHallway
    //west = TEST_westGap

    mapModeDirections = [&north]
}

/*+TEST_westGap: ParkourBridgeConnector { 'west gap;western;divide'
    "The western wall has a hole, and a sudden drop-off meets the floor there. "
    isListed = true
    canJumpOverMe = true
}*/