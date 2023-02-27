loadingArea: Room { 'The Loading Area'
    "TODO: Add description. "

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
}

class HallwaySegment: Room {
    desc = "You are <<inRoomName(gPlayerChar)>>.
        <<if lookAroundArmed>>TODO: Add description. <<end>>"
    nameHeader = 'The Main Hallway Ring'
}

loadingAreaSightLine: HallRegion;
directorsOfficeSightLine: HallRegion;
eastHallRegion: HallRegion;
westHallRegion: HallRegion;

northHall: HallwaySegment { '<<nameHeader>> (North)'
    //

    regions = [loadingAreaSightLine, directorsOfficeSightLine]

    north = northBathroom
    east = loadingArea
    west = northwestHall

    southeastMuffle = labA

    inRoomName(pov) {
        local omr = pov.getOutermostRoom();
        if (omr == loadingArea) {
            return 'near the middle of the hall (to the <<hyperDir('west')>>)';
        }
        if (omr == directorsOffice) {
            return 'in the hall (through the window)';
        }
        return inherited(pov);
    }

    descFrom(pov) {
        "TODO: Add remote description. ";
    }
}

northeastHall: HallwaySegment { '<<nameHeader>> (Northeast)'
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
}

eastHall: HallwaySegment { '<<nameHeader>> (East)'
    theName = 'the middle of the hall'

    north = northeastHall
    south = southeastHall

    regions = [eastHallRegion]
    lookAroundRegion = eastHallRegion

    inRoomName(pov) { return 'near the middle of the hall'; }
}

southeastHall: HallwaySegment { '<<nameHeader>> (Southeast)'
    theName = 'the south end of the hall'

    north = eastHall
    east = freezerWestEntry
    south = southHall

    regions = [eastHallRegion]
    lookAroundRegion = eastHallRegion

    inRoomName(pov) { return 'in the south end of the hall'; }
}

southHall: HallwaySegment { '<<nameHeader>> (South)'
    //

    northeast = southeastHall
    west = southwestHall
    south = southBathroom

    northeastMuffle = deliveryRoom
    northwestMuffle = cloneQuarters
    southeastMuffle = reactorNoiseRoom
}

northwestHall: HallwaySegment { '<<nameHeader>> (Northwest)'
    theName = 'the north end of the hall'

    north = northHall
    south = westHall

    eastMuffle = directorsOffice

    regions = [westHallRegion]
    lookAroundRegion = westHallRegion

    inRoomName(pov) { return 'in the north end of the hall'; }
}

westHall: HallwaySegment { '<<nameHeader>> (West)'
    theName = 'the middle of the hall'

    north = northwestHall
    south = southwestHall

    westMuffle = armory

    regions = [westHallRegion]
    lookAroundRegion = westHallRegion

    inRoomName(pov) { return 'near the middle of the hall'; }
}

southwestHall: HallwaySegment { '<<nameHeader>> (Southwest)'
    theName = 'the south end of the hall'

    north = westHall
    south = southHall

    regions = [westHallRegion]
    lookAroundRegion = westHallRegion

    inRoomName(pov) { return 'in the south end of the hall'; }
}