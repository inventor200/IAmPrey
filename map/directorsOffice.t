directorsOffice: Room { 'The Director\'s Office'
    "TODO: Add description. "

    regions = [directorsOfficeSightLine]

    north = brokenWindowInterior

    inRoomName(pov) { return 'in the office, seen through the window'; }

    descFrom(pov) {
        "TODO: Add remote description. ";
    }
}

//TODO: Broken shards multiloc here and in the north hall, explaining that
// the shards are nowhere to be found

+brokenWindowInterior: Passage { 'broken window;shattered'
    "TODO: Add description. "

    otherSide = brokenWindowExterior
    destination = northHall
    travelDesc = "{I} carefully climb{s/ed} through the broken window,
    wary of any lingering shards. "

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
            northHall.observeFrom(gActor, 'through the broken window');
        }
    }
}

DefineDoorSouthTo(administration, directorsOffice, 'the director\'s office door')