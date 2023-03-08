commonRoom: Room { 'The Common Room'
    "TODO: Add description. "

    north = assemblyShop
    south = enrichmentRoomHall

    northwestMuffle = directorsOffice
    eastMuffle = lifeSupportTop
    westMuffle = administration
}

+enrichmentRoomHall: Passage { 'passage;curving curved;corridor hall'
    "A short passage to the <<hyperDir('south')>>, curving toward the west.
    <<standardDesc>>"

    standardDesc = 'TODO: Add description. '

    otherSide = commonRoomHall
    destination = enrichmentRoom

    dobjFor(PeekAround) asDobjFor(LookThrough)
    attachPeakingAbility('around {the dobj}')
}

//TODO: There is a support beam across the ceiling, exposed because the ceiling
// tiles were removed. Falling from this beam is a hard impact, and it takes more turns
// to reach it from the ground than Skashek will allow.
// This support beam can be used as a swing between the east and west sides of the room.
// It is only possible to climb from the floor to the vent leading to the central node.
// You must swing from that vent to access the one by admin.
// The one by admin is a hard fall to the floor.
// You can jump onto the beam, and jump to the other vent, but it is costly and loud
// Swinging is quieter and takes less energy
DefineVentGrateEastTo(commonRoom, nil, administration, nil, 'administration vent grate;ventilation;door', 'common room vent grate;ventilation;door')