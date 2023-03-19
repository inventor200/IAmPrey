enrichmentRoom: Room { 'The Enrichment Room'
    "TODO: Add description. "

    east = commonRoomHall
    south = southEnrichmentRoomDoorInterior

    northMuffle = administration
    eastMuffle = utilityPassage

    mapModeDirections = [&west, &east, &south]
    familiar = roomsFamiliarByDefault
}

+southEnrichmentRoomDoorInterior: PrefabDoor { 'the south Enrichment Room door'
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

DefineDoorWestTo(westHall, enrichmentRoom, 'the Enrichment Room door')