loadingArea: Room { 'The Loading Area'
    "TODO: Add description. "

    west = northHall
    south = northeastHall
}

class HallRegion: SenseRegion {
    canSeeAcross = true
    canHearAcross = true
    canSmellAcross = nil
    canTalkAcross = true
    canThrowAcross = true
    autoGoTo = nil
}

class HallwaySegment: Room {
    desc = "You are <<inRoomName(nil)>>.
        <<if lookAroundArmed>>TODO: Add description. <<end>>"
    nameHeader = 'The Main Hallway Ring'
}

eastHallRegion: HallRegion;
westHallRegion: HallRegion;

northHall: HallwaySegment { '<<nameHeader>> (North)'
    //

    east = loadingArea
    west = northwestHall
}

northeastHall: HallwaySegment { '<<nameHeader>> (Northeast)'
    theName = 'the north end of the hall'

    north = loadingArea
    south = eastHall

    regions = [eastHallRegion]
    lookAroundRegion = eastHallRegion

    inRoomName(pov) { return 'in the north end of the hall'; }
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