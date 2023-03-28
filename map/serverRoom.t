serverRoomBottom: Room { 'Server Access'
    "The room is pretty barren; the server banks are all found upstairs.\b
    A ladder can be found here, and the exit to the <<hyperDir('east')>>
    goes to the Library, while a door to the <<hyperDir('west')>> goes
    to the Utility Corridor. "

    up = serverLadderBottom
    east = library

    northMuffle = lifeSupportTop
    southeastMuffle = deliveryRoom
    southMuffle = breakroom

    ceilingObj = industrialCeiling
    floorObj = cementFloor

    roomDaemon() {
        checkRoomDaemonTurns;
        "A <<freezer.coldSynonyms>> <<one of>>mist<<or>>fog<<at random>>
        <<one of>>falls<<or>>rolls<<at random>>
        <<one of>>down from<<or>>out of<<at random>> the
        <<one of>>opening above<<or>>opening<<or
        >>hatch in the ceiling<<or>>ladder<<at random>>. ";
        inherited();
    }

    mapModeDirections = [&up, &east, &west]
    familiar = roomsFamiliarByDefault
}

+serverFog: ColdFog;

+serverLadderBottom: ClimbUpIntoPlatform { 'ladder;access in[prep] the ceiling[n];opening hatch hole'
    "A ladder provides access to the chilled room above.
    It is inclined, and looks more like a steep stairway. "

    travelDesc =
        "{I} quickly<<one of>>{aac} 
        climb{s/ed}<<or>>{aac} 
        scale{s/ed}<<at random>> the ladder<<if gActorIsPrey>>,
        <<freezer.subclauseAmbienceOnEntry>><<end>>. "

    destination = serverRoomTop
}

DefineDoorWestTo(utilityPassage, serverRoomBottom, 'the Server Access door')

serverRoomTop: Room { 'The Chilled Server Room'
    "The room here would normally be engulfed in total darkness, if it weren't
    for light spilling in from the ladder, in addition to all the running lights
    of the surrounding server banks. <<dataCableAlcove.desc>>\b
    On the north wall, there is a cooling vent, filling the room with frigid air. "

    down = serverLadderTop
    out asExit(down)
    
    atmosphereObj = freezingAtmosphere
    isFreezing = true

    mapModeDirections = [&down]
    familiar = roomsFamiliarByDefault
    roomNavigationType = escapeRoom

    RoomHasLadderDown(serverLadderTop)
}

+serverBanks: Decoration { 'server bank;;computer server'
    "Large, black cabinets full of running computers, wired together in
    complex ways. Thick cables run from their tops, and feed into an alcove
    to the southeast.\b
    To the north, there is a large vent grate, which pumps freezing air into
    the room. "
    ambiguouslyPlural = true

    dobjFor(Eat) asDobjFor(Attack)
    dobjFor(Cut) asDobjFor(Attack)
    dobjFor(Attack) {
        verify() {
            if (gActorIsPrey) {
                illogical(
                    '{My} tactical intuition begins piecing together the
                    evidence...\b
                    If {i} destroy {the dobj}, then <<gSkashekName>> will be
                    left with corpses, which he will refuse to eat. If he starves
                    to death, then the facility will begin to look inactive from
                    outside. If that happens then {my} creators will retake this
                    place, and restart the clone program all over again.\b
                    That would be an existential threat to both this place
                    <i>and</i> the world outside.\b
                    The enemy <i>must not win</i>, but {i} cannot die either.
                    The solution is to hope most newborns successfully flee,
                    and that just enough of them fail, so <<gSkashekName>>
                    can survive.\b
                    {I} have no room for spite or suicide in my mission.
                    The optimal outcome is escape. '
                );
            }
            else {
                illogical(
                    'Short of biting the wires, there\'s not much {i} can do. '
                );
            }
        }
    }
}

+serverLadderTop: ClimbDownIntoPlatform { 'ladder;access in[prep] the floor[n];opening[weak] hatch[weak] hole[weak]'
    "A ladder allows travel to the floor below. "

    travelDesc =
        "<<if gActorIsCat>>It's a little painful for {my} old
        joints, but {i} manage to land on one of the rungs before
        getting on the floor.<<else
        >>{I} quickly<<one of>>{aac}
        climb{s/ed} down<<or>>{aac}
        descend{s/ed}<<at random>> the ladder<<if gActorIsPrey>>,
        <<freezer.subclauseAmbienceOnExit>><<end>>.<<end>> "

    destination = serverRoomBottom
}

+dataCableAlcove: FixedPlatform { 'floor[n] of[prep] the alcove;data cable to[prep] delivery[n] room[weak] raised'
    "Part of the room is built atop the northwest corner of the Delivery Room,
    which creates the shape of a raised alcove to the southeast.<<
    if gPlayerChar.isIn(dataCableAlcove)>>\b<<descFromAbove>><<end>> "

    simplyRerouteClimbInto = true
    isSafeParkourPlatform = true

    seenHoleFromHere = nil

    descFromAbove =
        '{I} can see an opening in the floor of the alcove,
        where the cables feed into. '

    showDescFromAbove() {
        if (!gPlayerChar.isIn(dataCableAlcove)) return '';
        return '\b' + descFromAbove;
    }

    doAccident(actor, traveler, path) {
        inherited(actor, traveler, path);
        if (seenHoleFromHere && !gameMain.verbose) return;
        seenHoleFromHere = true;
        say('<.p>' + descFromAbove + '<.p>');
    }
}
++AwkwardFloorHeight;
++dataCableServerExit: ClimbDownEnterPlatform { 'opening;extra[weak] in[prep] the floor[n] alcove[weak] cable[weak];hole hatch gap space[weak] exit'
    "There is a wide opening or hatch in the floor of the alcove.
    Through it, data cables feed into the Delivery Room.\b
    {I} notice some extra space around the cables, as if there
    are too few of them being threaded through. "

    oppositeLocalPlatform = deliveryRoomCables
    destination = deliveryRoom

    dobjFor(SqueezeThrough) asDobjFor(TravelVia)

    travelDesc = "{I} squeeze through the opening, climb down the data cables,
        and come to an uneasy landing on the northwest artificial womb. "
}
++serverRoomCables: ClimbDownPlatform { 'cables;server black dark insulated data hanging[weak] on[prep] ceiling[n];bundles[weak] wires cords connections'
    "Thick, dark, data cables feed into an
    <<if gPlayerChar.isIn(dataCableAlcove)>>alcove<<else
    >>opening in the floor of the alcove<<end
    >>, from multiple server banks in the small room. "
    plural = true

    dobjFor(SqueezeThrough) asDobjFor(TravelVia)

    dobjFor(Cut) {
        remap = serverBanks
    }

    dobjFor(Attack) {
        remap = serverBanks
    }

    dobjFor(Eat) {
        verify() {
            if (gActorIsPrey) {
                inherited();
            }
            else {
                illogical(
                    '<<gSkashekName>> must have coated these in something,
                    because the taste{dummy} makes {me} wretch. '
                );
            }
        }
    }

    asAliasFor(dataCableServerExit)
}

// Has access to coolingDuctUpperOuterGrate