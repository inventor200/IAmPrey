library: Room { 'The Library'
    "TODO: Add description.\b
    A stepladder sits by the north wall, under a vent grate.\b
    The exit door is to the <<hyperDir('east')>>. "

    west = serverRoomBottom

    northMuffle = labA
    norhtwestMuffle = lifeSupportTop
    southMuffle = deliveryRoom

    mapModeDirections = [&east, &west]
    familiar = roomsFamiliarByDefault
}

+stepLadder: FixedPlatform { 'stepladder;step[weak];ladder'
    "A large, metal stepladder. "

    cannotTakeMsg = 'That is way to heavy and clumsy to carry around. '
}
++LowFloorHeight;

DefineDoorEastTo(eastHall, library, 'the Library door')