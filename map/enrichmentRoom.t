enrichmentRoom: Room { 'The Enrichment Room'
    "TODO: Add description. "

    east = commonRoomHall
    south = southEnrichmentRoomDoorInterior

    northMuffle = administration
    eastMuffle = utilityPassage
}

+southEnrichmentRoomDoorInterior: Door { 'the south enrichment room door'
    desc = standardDoorDescription
    otherSide = southEnrichmentRoomDoorExterior
    pullHandleSide = true
}

+commonRoomHall: Passage {
    vocab = otherSide.vocab
    desc = "A short passage to the <<hyperDir('east')>>, curving toward the north. "

    otherSide = enrichmentRoomHall
    destination = commonRoom

    dobjFor(PeekAround) asDobjFor(LookThrough)
    attachPeakingAbility('around {the dobj}')
}

DefineDoorWestTo(westHall, enrichmentRoom, 'the enrichment room door')