cloneQuarters: Room { 'Clone Sleeping Quarters'
    "TODO: Add description. "

    north = southEnrichmentRoomDoorExterior
}

+southEnrichmentRoomDoorExterior: Door { 'the enrichment room door'
    desc = standardDoorDescription
    otherSide = southEnrichmentRoomDoorInterior
    soundSourceRepresentative = southEnrichmentRoomDoorInterior
}

//TODO: Parkour exit east to the utility room

DefineDoorWestTo(southwestHall, cloneQuarters, 'the clone sleeping quarters door')