loadingArea: Room {
    vocab = 'loading area;;hall[weak] hallway[weak]'
    roomTitle = '<<HallwaySegment.nameHeader>> (Loading Area)'
    desc =
    "This part of the hallway is slightly more industrial than clinical,
    as a lot of hauling was facilitated here. On the north wall, some
    lifting straps hang from hooks.\b
    The hallway extends <<hyperDir('west')>> and <<hyperDir('south')>>,
    while a doorway to the <<hyperDir('east')>> opens to the Storage Bay. "

    regions = [loadingAreaSightLine, eastHallRegion]

    east = loadingAreaDoorway
    west = northHall
    south = northeastHall
    ambienceObject = industrialAmbience

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

+FakePlural, Decoration { 'hooks;one[weak] of[prep];hook'
    "Some simple hooks for hanging stuff. "
    fakeSingularPhrase = 'hook'
    isLikelyContainer() {
        return true;
    }
    contType = On
}

++FakePlural, Decoration { 'lifting straps;one[weak] of[prep];strap band bands'
    "Neon green straps, designed to help humans haul heavy objects. "
    fakeSingularPhrase = 'lifting strap'
}

+loadingAreaDoorway: Passage { 'doorway'
    "A metal doorway. There's probably some kind of door or paneling that should
    be here, but it seems to be missing. "

    destination = storageBay
}

+missingLoadingPaneling: Unthing { 'missing door;;paneling'
    'Some kind of door or paneling should be here, between the Loading Area
    and the Storage Bay, but it\'s been removed. '
}

class HallwaySegment: Room {
    desc = "{I} {am} <<inRoomName(gPlayerChar)>>.
        <<if lookAroundArmed>>The hallway is dimly lit, and wide
        enough to comfortably fit two opposing flows of travel. <<end>><<additionalDesc()>>"
    nameHeader = 'The Main Hallway Ring'

    additionalDesc() { }
    ambienceObject = industrialAmbience
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
    To the <<hyperDir('north')>> is a restroom. To the <<hyperDir('south')>>
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

    mapModeDirections = [&east, &southwest, &south]
    familiar = roomsFamiliarByDefault
}

northeastHall: HallwaySegment {
    vocab = 'K hallway[weak];;hall[weak]'
    roomTitle = '<<nameHeader>> (K)'
    theName = 'the north end of the hall'
    additionalDesc = "\b
    The hall extends <<hyperDir('north')>> and <<hyperDir('south')>>. "

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
    additionalDesc = "\b
    The hall extends <<hyperDir('north')>> and <<hyperDir('south')>>. "

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
    additionalDesc = "\b
    The hall extends <<hyperDir('north')>> and <<hyperDir('southwest')>>. "

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
    additionalDesc = "\b
    The hall extends to the <<hyperDir('west')>>, curves <<hyperDir('northeast')>>,
    and also leads to a restroom to the <<hyperDir('south')>>. "

    regions = [southHallRegion]

    northeast = southeastHall
    west = southwestishHall
    south = southBathroom

    northeastMuffle = deliveryRoom
    southeastMuffle = reactorNoiseRoom
    ambienceObject = southeastAmbience

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
    additionalDesc = "\b
    The hall extends <<hyperDir('northwest')>> and <<hyperDir('east')>>. "

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
    additionalDesc = "\b
    The hall extends <<hyperDir('northeast')>> and <<hyperDir('south')>>. "

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
    additionalDesc = "\b
    The hall extends <<hyperDir('north')>> and <<hyperDir('south')>>. "

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
    additionalDesc = "\b
    The hall extends <<hyperDir('north')>> and <<hyperDir('southeast')>>. "

    north = westHall
    southeast = southwestishHall

    regions = [westHallRegion]
    lookAroundRegion = westHallRegion

    inRoomName(pov) { return 'in the south end of the hall'; }

    mapModeDirections = [&north, &southeast, &east, &west]
    familiar = roomsFamiliarByDefault
}