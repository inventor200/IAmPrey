centralRoom: Room { 'Central Room'
    "The main room in the center."

    north = hallwayDoor
    westMuffle = sideRoom
    east = eastGap
}

+hallwayDoor: Door { 'hallway door'
    "The door to the hallway. <<catFlapDesc>> "
    otherSide = centralRoomDoor
}

+cargoShelf: FixedPlatform { 'tall cargo shelf'
    "A tall series of cargo shelves. "
    isListed = true
}
++DangerousFloorHeight;

++bottle: Thing { 'water bottle'
    "A difficult water bottle. "
}

++dogCage: Booth { 'dog cage'
    "A weird dog cage. "
}

+cabinet: FixedPlatform { 'tall lab cabinet'
    "A locked, metal cabinet, likely containing lab materials. "
    isListed = true

    remapIn: SubComponent {
        isOpenable = true
        isOpen = true
        isEnterable = true
    }
    remapOn: SubComponent {
        isBoardable = true
    }
}
++HighFloorHeight;
++ClimbUpLink -> cargoShelf;

++grayCrate: FixedPlatform { 'gray crate;grey'
    "A gray crate. It looks suspiciously-boring to climb on. "
    subLocation = &remapOn
    isListed = true
}

++blueCrate: FixedPlatform { 'blue crate'
    "A gray crate. It looks suspiciously-fun to climb on. "
    subLocation = &remapOn
    isListed = true
}
+++LowFloorHeight;

++cup: Thing { 'cup'
    "A ceramic cup. "
    subLocation = &remapOn
}

+exosuit: CoveredVehicle { 'exosuit;small exo;suit'
    "A small exosuit, not much larger than a person. "
    fitForParkour = true
}

+metalCrate: FixedPlatform { 'metal crate'
    "A big metal crate, sitting alone in the corner. "
    //parkourBarriers = [fragileCrateBarrier]
    /*doAccident(actor, traveler, path) {
        traveler.moveInto(centralRoom);
        "{I} {swing} on the flagpole, and land{s/ed} on the metal crate,
        but it collapses, and {i} {am} thrown to the floor. ";
    }*/
}
++LowFloorHeight;

+fragileCrateBarrier: TravelBarrier {
    canTravelerPass(actor, connector) {
        return nil;
    }
    
    explainTravelBarrier(actor, connector) {
        "The crate doesn't seem very sturdy... ";
    }
}

+flagPole: Fixture { 'flagpole'
    "A barren flagpole, sticking horizontally out of the wall,
    between the lab desk and metal crate. "
    isListed = true
    canSwingOnMe = true
    //parkourBarriers = [fragilePoleBarrier]
    /*doProviderAccident(actor, traveler, path) {
        traveler.moveInto(centralRoom);
        "{I} {swing} on the flagpole, but only for a moment.
        With a horrible, metal-wrenching sound, the pole snaps
        free of the wall, dropping {me} to the floor. ";
    }*/
}

/*+fragilePoleBarrier: TravelBarrier {
    canTravelerPass(actor, connector) {
        return nil;
    }
    
    explainTravelBarrier(actor, connector) {
        "The pole seems flimsy... ";
    }
}*/

+desk: FixedPlatform { 'lab desk'
    "A simple lab desk. "
    isListed = true
    canSlideUnderMe = true
}
++LowFloorHeight;
++ClimbUpLink -> cabinet;
++JumpUpLink -> cargoShelf
    pathDescription = 'scale the cargo shelves'
;
++ProviderLink @flagPole ->metalCrate;

+table: FixedPlatform { 'generic table'
    "A generic table, outside of any parkour system. "
    isListed = true
    //doNotSuggestGetOff = true
}

++puzzleCube: Trinket { 'puzzle cube'
    "A 3x3 puzzle cube. "
}

++postItNote: Thing { 'note;postit post-it post sticky'
    "A simple note. "
    readDesc = "Hello world!"
}

+eastGap: ParkourBridgeConnector { 'east gap;eastern;divide'
    "The eastern wall has a hole, and a sudden drop-off meets the floor there. "
    isListed = true
    canJumpOverMe = true
}

+AwkwardProviderBridge @eastGap ->subtleRoom @westGap;

sideRoom: Room { 'Side Room'
    "The additional room to the side."

    north = centerHallway
    eastMuffle = centralRoom
}

longHallway: SenseRegion {
    //
}

centerHallway: Room { 'Hallway (Center)'
    "The central section of a long hallway. "

    southeast = centralRoomDoor
    southwest = sideRoom
    east = eastHallway

    regions = [longHallway]
}

+centralRoomDoor: Door { 'central room door'
    "The door to the central room. <<catFlapDesc>> "
    otherSide = hallwayDoor
}

eastHallway: Room { 'Hallway (East)'
    "The eastern section of a long hallway. "
    west = centerHallway
    south = subtleRoom

    regions = [longHallway]
}

// East of central room
subtleRoom: Room { 'Subtle Room'
    "Just a subtle room. "
    north = eastHallway
    west = westGap
}

+westGap: ParkourBridgeConnector { 'west gap;western;divide'
    "The western wall has a hole, and a sudden drop-off meets the floor there. "
    isListed = true
    canJumpOverMe = true
}