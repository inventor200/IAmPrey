serverRoomBottom: Room { 'Server Access'
    "TODO: Add description. "

    up = serverLadderBottom
    east = itOffice

    northMuffle = lifeSupportTop
    southeastMuffle = deliveryRoom
    southMuffle = breakroom

    roomDaemon() {
        "A <<freezer.coldSynonyms>> <<one of>>mist<<or>>fog<<at random>>
        <<one of>>falls<<or>>rolls<<at random>>
        <<one of>>down from<<or>>out of<<at random>> the
        <<one of>>opening above<<or>>opening<<or
        >>hatch in the ceiling<<or>>ladder<<at random>>. ";
        inherited();
    }
}

+serverFog: ColdFog;

+serverLadderBottom: TravelConnector, Fixture { 'opening in[prep] the ceiling;access;ladder hatch hole'
    "TODO: Add description. "

    travelDesc =
        "{I} quickly<<one of>>{aac} 
        climb{s/ed}<<or>>{aac} 
        scale{s/ed}<<at random>> the ladder<<if gActor == gPlayerChar>>,
        <<freezer.subclauseAmbienceOnEntry>><<end>>. "

    destination = serverRoomTop
    
    dobjFor(Climb) asDobjFor(TravelVia)
    dobjFor(ClimbUp) asDobjFor(TravelVia)
    dobjFor(ParkourClimbUpTo) asDobjFor(TravelVia)
    dobjFor(ParkourClimbUpInto) asDobjFor(TravelVia)
    dobjFor(ParkourJumpUpTo) asDobjFor(TravelVia)
    dobjFor(ParkourJumpUpInto) asDobjFor(TravelVia)
    dobjFor(Enter) asDobjFor(TravelVia)
    dobjFor(GoThrough) asDobjFor(TravelVia)
}

DefineDoorWestTo(utilityPassage, serverRoomBottom, 'the server access door')

serverRoomTop: Room { 'The Chilled Server Room'
    "TODO: Add description. "

    down = serverLadderTop
    out asExit(down)
    
    atmosphereObj = freezingAtmosphere
    isFreezing = true
}

+serverLadderTop: TravelConnector, Fixture { 'opening in[prep] the floor;access;ladder hatch hole'
    "TODO: Add description. "

    travelDesc =
        "{I} quickly<<one of>>{aac}
        climb{s/ed} down<<or>>{aac}
        descend{s/ed}<<at random>> the ladder<<if gActor == gPlayerChar>>,
        <<freezer.subclauseAmbienceOnExit>><<end>>. "

    destination = serverRoomBottom
    
    dobjFor(Climb) asDobjFor(TravelVia)
    dobjFor(ClimbDown) asDobjFor(TravelVia)
    dobjFor(ParkourClimbDownTo) asDobjFor(TravelVia)
    dobjFor(ParkourClimbDownInto) asDobjFor(TravelVia)
    dobjFor(ParkourJumpDownTo) asDobjFor(TravelVia)
    dobjFor(ParkourJumpDownInto) asDobjFor(TravelVia)
    dobjFor(Enter) asDobjFor(TravelVia)
    dobjFor(GoThrough) asDobjFor(TravelVia)
}

// Has access to coolingDuctUpperOuterGrate