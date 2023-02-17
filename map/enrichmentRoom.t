enrichmentRoom: Room { 'The Enrichment Room'
    "TODO: Add description. "

    east = commonRoomHall
    south = southEnrichmentRoomDoorInterior
}

+southEnrichmentRoomDoorInterior: Door { 'the south enrichment room door'
    desc = standardDoorDescription
    otherSide = southEnrichmentRoomDoorExterior
}

+commonRoomHall: Passage {
    vocab = otherSide.vocab
    desc = "A short passage to the <<hyperDir('east')>>, curving toward the north.
    <<otherSide.standardDesc>>"

    otherSide = enrichmentRoomHall
    destination = commonRoom
}

DefineDoorWestTo(westHall, enrichmentRoom, 'the enrichment room door')