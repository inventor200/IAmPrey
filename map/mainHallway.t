loadingArea: Room { 'The Loading Area'
    "TODO: Add description. "

    regions = [loadingAreaSightLine, eastHallRegion]

    west = northHall
    south = northeastHall

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

    east = loadingArea
    west = northwestHall
    southwest = brokenWindowExterior

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

+brokenWindowExterior: Passage { 'broken director\'s office window;directors[weak] shattered'
    desc = otherSide.desc
    travelDesc = otherSide.travelDesc

    otherSide = brokenWindowInterior
    destination = directorsOffice

    dobjFor(SqueezeThrough) asDobjFor(TravelVia)
    dobjFor(ParkourClimbGeneric) asDobjFor(TravelVia)
    dobjFor(ParkourClimbOverInto) asDobjFor(TravelVia)
    dobjFor(ParkourJumpOverInto) asDobjFor(TravelVia)

    canLookThroughMe = true

    dobjFor(LookIn) asDobjFor(LookThrough)
    dobjFor(Search) asDobjFor(LookThrough)
    dobjFor(LookThrough) {
        action() { }
        report() {
            directorsOffice.observeFrom(gActor, 'through the broken window');
        }
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
    south = southHall

    regions = [eastHallRegion]
    lookAroundRegion = eastHallRegion

    inRoomName(pov) { return 'in the south end of the hall'; }
}

southHall: HallwaySegment { '<<nameHeader>> (South)'
    //

    east = southeastHall
    west = southwestHall
}

northwestHall: HallwaySegment { '<<nameHeader>> (Northwest)'
    theName = 'the north end of the hall'

    north = northHall
    south = westHall

    regions = [westHallRegion]
    lookAroundRegion = westHallRegion

    inRoomName(pov) { return 'in the north end of the hall'; }
}

westHall: HallwaySegment { '<<nameHeader>> (West)'
    theName = 'the middle of the hall'

    north = northwestHall
    south = southwestHall

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