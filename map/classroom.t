classroom: Room { 'The Classroom'
    "Scattered desks indicate frequent chases have occurred here before.
    A teacher's desk sits against the north wall, beside a projector screen.
    To the <<hyperDir('east')>>, a passage curves north to the Common Room. "

    east = commonRoomHall
    south = southClassroomDoorInterior

    northMuffle = administration
    eastMuffle = utilityPassage

    mapModeDirections = [&west, &east, &south]
    familiar = roomsFamiliarByDefault
}
+PluralDesk;
+PluralChair;
+Desk {
    'teacher\'s desk;teachers teacher teaching front'
}
+Projector;
+ProjectorScreen;
+classroomShelves: MetalShelves;

+southClassroomDoorInterior: PrefabDoor { 'the Clone Sleeping Quarters door'
    desc = standardDoorDescription
    otherSide = southClassroomDoorExterior
    pullHandleSide = true
}

+commonRoomHall: Passage {
    vocab = otherSide.vocab
    desc = "A short passage to the <<hyperDir('east')>>, curving toward the north. "

    otherSide = classroomHall
    destination = commonRoom

    dobjFor(PeekAround) asDobjFor(LookThrough)
    attachPeakingAbility('around {the dobj}')
}

DefineDoorWestTo(westHall, classroom, 'the Classroom door')