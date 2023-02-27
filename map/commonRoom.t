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
}

//TODO: Parkour exit west to administration
//TODO: Parkour exit northeast to central vent system