library: Room { 'The Library'
    "This isn't exactly a library for <i>books</i>, as such a
    room is considered an <q>ancient fad</q>. This modern library
    is instead where document searches and archive access is done.
    A librarian would work the help desk, and rent out tablet computers
    to facility staff, if they did not want to spend time at
    desktop computer.\b
    A storage cabinet sits by the south wall, and chairs are strewn about.\b
    A stepladder sits by the north wall, under a vent grate. "

    west = serverRoomBottom

    northMuffle = labA
    norhtwestMuffle = lifeSupportTop
    southMuffle = deliveryRoom

    mapModeDirections = [&east, &west]
    familiar = roomsFamiliarByDefault
}

+PluralChair;
+PluralDesk;
+libraryCabinet: StorageCabinet;
+Desk {
    'help desk;librarian service'
}

+Unthing { 'computer;tablet;computers'
    'The computer devices have apparently been removed. '
}

+stepLadder: FixedPlatform { 'stepladder;step[weak];ladder'
    "A large, metal stepladder. "

    cannotTakeMsg = 'That is way to heavy and clumsy to carry around. '
}
++LowFloorHeight;

DefineDoorEastTo(eastHall, library, 'the Library door')