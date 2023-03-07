labA: Room { 'Lab A'
    "TODO: Add description. "

    northMuffle = northHall
    westMuffle = lifeSupportTop
    southMuffle = itOffice
}

//TODO: Parkour exit west to the central vents
//TODO: Parkour exit south to IT office

DefineDoorEastTo(northeastHall, labA, 'the door to[weak] lab A[weak]')
DefineVentGrateNorthTo(labA, nil, itOffice, nil, 'IT office vent grate;ventilation;door', 'lab A vent grate;ventilation;door')