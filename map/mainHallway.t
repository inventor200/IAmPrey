loadingArea: Room {
    vocab = 'loading area;;hall[weak] hallway[weak]'
    roomTitle = '<<HallwaySegment.nameHeader>> (Loading Area)'
    desc = "TODO: Add description. "

    regions = [loadingAreaSightLine, eastHallRegion]

    east = storageBay
    west = northHall
    south = northeastHall

    southeastMuffle = labB

    inRoomName(pov) {
        local omr = pov.getOutermostRoom();
        if (omr == northHall) {
            return 'in the loading area (to the <<hyperDir('east')>>)';
        }
        if (omr == northeastHall) {
            return 'in the loading area (to the <<hyperDir('north')>>)';
        }
        return inherited(pov);
    }

    mapModeDirections = [&east, &west, &south]
    familiar = roomsFamiliarByDefault
}

class HallwaySegment: Room {
    desc = "{I} {am} <<inRoomName(gPlayerChar)>>.
        <<if lookAroundArmed>>TODO: Add description. <<end>><<additionalDesc()>>"
    nameHeader = 'The Main Hallway Ring'

    additionalDesc() { }

    descFrom(pov) {
        "TODO: Add remote description. ";
    }
}

loadingAreaSightLine: HallRegion;
directorsOfficeSightLine: HallRegion;
eastHallRegion: HallRegion;
westHallRegion: HallRegion;
southHallRegion: HallRegion;

northHall: HallwaySegment {
    vocab = 'B hallway[weak];;hall[weak]'
    roomTitle = '<<nameHeader>> (B)'
    theName = 'the middle end of the hall'
    additionalDesc = "\b
    The hall continues <<hyperDir('east')>> and <<hyperDir('west')>>.
    To the <<hyperDir('north')>> is a bathroom. To the <<hyperDir('south')>>
    is the door to the Assembly Shop. "

    regions = [loadingAreaSightLine]

    north = northBathroom
    east = loadingArea
    west = northwestishHall

    southeastMuffle = labA

    inRoomName(pov) {
        local omr = pov.getOutermostRoom();
        if (omr == loadingArea) {
            return 'near the middle of the hall (to the <<hyperDir('west')>>)';
        }
        if (omr == northwestishHall) {
            return 'near the middle of the hall (to the <<hyperDir('east')>>)';
        }
        return inherited(pov);
    }

    descFrom(pov) {
        "TODO: Add remote description. ";
    }

    mapModeDirections = [&north, &east, &west, &south]
    familiar = roomsFamiliarByDefault
}

northwestishHall: HallwaySegment {
    vocab = 'C hallway[weak];;hall[weak]'
    roomTitle = '<<nameHeader>> (C)'
    theName = 'the west end of the hall'
    additionalDesc = "\b
    The hall extends to the <<hyperDir('east')>>, with a nearby
    corner to the <<hyperDir('southwest')>>.
    To the <<hyperDir('south')>> is a broken window. "

    regions = [loadingAreaSightLine, directorsOfficeSightLine]

    east = northHall
    southwest = northwestHall

    inRoomName(pov) {
        local omr = pov.getOutermostRoom();
        if (omr == northHall) {
            return 'near the <<hyperDir('west')>> end of the hall';
        }
        if (omr == directorsOffice) {
            return 'in the hall (through the window)';
        }
        return inherited(pov);
    }

    descFrom(pov) {
        "TODO: Add remote description. ";
    }

    mapModeDirections = [&east, &southwest, &south]
    familiar = roomsFamiliarByDefault
}

northeastHall: HallwaySegment {
    vocab = 'K hallway[weak];;hall[weak]'
    roomTitle = '<<nameHeader>> (K)'
    theName = 'the north end of the hall'

    north = loadingArea
    south = eastHall

    regions = [eastHallRegion]
    lookAroundRegion = eastHallRegion

    inRoomName(pov) {
        if (pov.getOutermostRoom() == loadingArea) {
            return 'in the nearby part of the hall (to the <<hyperDir('south')>>)';
        }
        return 'in the north end of the hall';
    }

    mapModeDirections = [&north, &south, &east, &west]
    familiar = roomsFamiliarByDefault
}

eastHall: HallwaySegment {
    vocab = 'J hallway[weak];;hall[weak]'
    roomTitle = '<<nameHeader>> (J)'
    theName = 'the middle of the hall'

    north = northeastHall
    south = southeastHall

    regions = [eastHallRegion]
    lookAroundRegion = eastHallRegion

    inRoomName(pov) { return 'near the middle of the hall'; }

    mapModeDirections = [&north, &south, &east, &west]
    familiar = roomsFamiliarByDefault
}

southeastHall: HallwaySegment {
    vocab = 'I hallway[weak];;hall[weak]'
    roomTitle = '<<nameHeader>> (I)'
    theName = 'the south end of the hall'

    north = eastHall
    east = freezerWestEntry
    southwest = southHall

    regions = [eastHallRegion]
    lookAroundRegion = eastHallRegion

    inRoomName(pov) { return 'in the south end of the hall'; }

    roomDaemon() {
        checkRoomDaemonTurns;
        westFreezerFog.rollingDesc(freezerWestEntry);
        inherited();
    }

    mapModeDirections = [&north, &southwest, &east, &west]
    familiar = roomsFamiliarByDefault
}

southHall: HallwaySegment {
    vocab = 'H hallway[weak];;hall[weak]'
    roomTitle = '<<nameHeader>> (H)'
    theName = 'the middle of the hall'

    regions = [southHallRegion]

    northeast = southeastHall
    west = southwestishHall
    south = southBathroom

    northeastMuffle = deliveryRoom
    southeastMuffle = reactorNoiseRoom

    inRoomName(pov) {
        local omr = pov.getOutermostRoom();
        if (omr == southwestishHall) {
            return 'near the middle of the hall (to the <<hyperDir('east')>>)';
        }
        return inherited(pov);
    }

    mapModeDirections = [&north, &south, &east, &west, &northeast]
    familiar = roomsFamiliarByDefault
}

southwestishHall: HallwaySegment {
    vocab = 'G hallway[weak];;hall[weak]'
    roomTitle = '<<nameHeader>> (G)'
    theName = 'the west end of the hall'

    regions = [southHallRegion]

    north = southUtilityPassageEntry
    east = southHall
    northwest = southwestHall

    //northwestMuffle = cloneQuarters

    mapModeDirections = [&east, &northwest]
    mapModeLockedDoors = [southUtilityPassageEntry]
    familiar = roomsFamiliarByDefault

    inRoomName(pov) {
        local omr = pov.getOutermostRoom();
        if (omr == southHall) {
            return 'near the <<hyperDir('west')>> end of the hall';
        }
        return inherited(pov);
    }
}

northwestHall: HallwaySegment {
    vocab = 'D hallway[weak];;hall[weak]'
    roomTitle = '<<nameHeader>> (D)'
    theName = 'the north end of the hall'

    northeast = northwestishHall
    south = westHall

    eastMuffle = directorsOffice

    regions = [westHallRegion]
    lookAroundRegion = westHallRegion

    inRoomName(pov) { return 'in the north end of the hall'; }

    mapModeDirections = [&northeast, &south, &east, &west]
    familiar = roomsFamiliarByDefault
}

westHall: HallwaySegment {
    vocab = 'E hallway[weak];;hall[weak]'
    roomTitle = '<<nameHeader>> (E)'
    theName = 'the middle of the hall'

    north = northwestHall
    south = southwestHall

    westMuffle = armory

    regions = [westHallRegion]
    lookAroundRegion = westHallRegion

    inRoomName(pov) { return 'near the middle of the hall'; }

    mapModeDirections = [&north, &south, &east]
    familiar = roomsFamiliarByDefault
}

southwestHall: HallwaySegment {
    vocab = 'F hallway[weak];;hall[weak]'
    roomTitle = '<<nameHeader>> (F)'
    theName = 'the south end of the hall'

    north = westHall
    southeast = southwestishHall

    regions = [westHallRegion]
    lookAroundRegion = westHallRegion

    inRoomName(pov) { return 'in the south end of the hall'; }

    mapModeDirections = [&north, &southeast, &east, &west]
    familiar = roomsFamiliarByDefault
}