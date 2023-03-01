coolingDuctSightLine: HallRegion;

fakeDuctCeiling: Ceiling { 'ceiling;top;top[weak] end airflow'
    "The cooling duct is a wide, vertical drop. Cold air is pumped in from
    below, and is sent up to the server room, found elsewhere. "
}

coolingDuctWalls: Walls { 'walls;inner metal;insides panels'
    "TODO: Add description."
}

fakeDuctFloor: Floor { 'floor;bottom;ground bottom[weak] end drop curve below'
    "The cooling duct is a wide, vertical drop, and curves below to the east,
    in the direction of the airflow's source. The facility's heat exchanger and
    fans are probably that way. "
}

class CoolingDuctSegment: HallwaySegment {
    desc = "<<if lookAroundArmed
        >>You <<one of>><<one of>>hold onto<<or>>grip<<at random>><<or
        >><<one of>>hold<<or>>press<<or>>push<<at random>>
        yourself against<<at random>> <<insidesDesc>>.
        TODO: Add description. <<end>>"
    nameHeader = 'Inside Cooling Duct'

    wallsDesc =
        '<<one of>>insides<<or>>walls<<or>>inner panels<<at random>>'
    insidesDesc =
        'the <<one of>><<freezer.coldSynonyms>><<or
        >><<freezer.coldAluminum>><<at random>>
        <<wallsDesc>><<one of>> of the duct<<or>><<at random>>'

    regions = [coolingDuctSightLine]
    lookAroundRegion = coolingDuctSightLine

    ceilingObj = fakeDuctCeiling
    wallsObj = coolingDuctWalls
    floorObj = fakeDuctFloor
    atmosphereObj = freezingAtmosphere
    isFreezing = true

    roomBeforeAction() {
        if (gActionIs(Drop) || gActionIs(Throw) || gActionIs(ThrowDir) || gActionIs(ThrowTo)) {
            "If you let go of {that dobj} in here, you may never get it back. ";
            exit;
        }

        if (gActionIs(ClimbUpVague) || gActionIs(Jump)) {
            attemptVerticalTravel(upDir);
        }
        
        if (gActionIs(ClimbDownVague) || gActionIs(ParkourClimbOffIntransitive) ||
            gActionIs(ParkourJumpOffIntransitive) || gActionIs(JumpOffIntransitive)) {
            attemptVerticalTravel(downDir);
        }

        inherited();
    }

    attemptVerticalTravel(dir) {
        if (hasTravelConnectorTo(dir)) {
            self.(dir.dirProp).travelVia(gActor);
        }
        else {
            nonTravel(self, dir);
        }
        exit;
    }

    hasTravelConnectorTo(dir) {
        switch (propType(dir.dirProp)) {
            default:
                return true;
            case TypeNil:
            case TypeDString:
            case TypeCode:
            case TypeSString:
                return nil;
        }
    }

    matchOrigin(dir, origin) {
        if (!hasTravelConnectorTo(dir)) return nil;
        return origin == self.(dir.dirProp).destination;
    }

    ductTravelPrefix =
        '<.p><<if climbStreak < 2
        >>Pressing {my} limbs against the <<insidesDesc>>, {i}
        <<else>>{I} <<end>>walk {myself} <<if climbStreak > 1>>back<<end>>'

    ductTravelSuffix =
        'the vertical cooling duct.<.p>'

    climbStreak = 0

    travelerEntering(traveler, origin) {
        inherited(traveler, origin);
        if (gPlayerChar.isOrIsIn(traveler)) {
            if (matchOrigin(upDir, origin)) {
                setClimbStreak(climbStreak + 1);
                "<<ductTravelPrefix>> down <<ductTravelSuffix>> ";
            }
            else if (matchOrigin(downDir, origin)) {
                setClimbStreak(climbStreak + 1);
                "<<ductTravelPrefix>> up <<ductTravelSuffix>> ";
            }
            else if (matchOrigin(outDir, origin)) {
                setClimbStreak(climbStreak + 1);
                "<.p>You climb into the cooling duct<<if origin.isFreezing == nil
                >>, <<freezer.subclauseAmbienceOnEntry>><<end>>.
                You press your limbs against the <<freezer.coldAluminum>> walls.
                Now pinned in place, you are ready to climb
                <<gDirectCmdStr('up')>> or <<gDirectCmdStr('down')>><.p> ";
            }
        }
        //TODO: Climbing noise
    }

    setClimbStreak(value) {
        local otherHalf = (hasTravelConnectorTo(upDir) ? up : down);
        if (lookAroundArmed) {
            climbStreak = 0;
            otherHalf.climbStreak = 0;
            return;
        }
        climbStreak = value;
        otherHalf.climbStreak = value;
    }
}

class CoolingDuctInnerDoor: Door {
    vocab = 'access door;cooling[weak] duct;hatch'
    desc = "TODO: Add description. "

    airlockDoor = true
    passActionStr = 'exit'

    standardExitMsg =
        '<<one of>>{I} awkwardly<<or>>With difficulty, {i}<<at random>>{aac}
        prop{s/?ed} {myself} into position, and exit{s/ed} through <<theName>>'

    travelDesc =
        "<<standardExitMsg>>. "
}

class CoolingDuctOuterDoor: CoolingDuctInnerDoor {
    vocab = 'cooling duct;access;door hatch'
    passActionStr = 'enter'
}

lifeSupportTop: Room { 'Life Support (Upper Level)'
    "TODO: Add description. "

    southwest = northUtilityPassageEntry
    down = lifeSupportBottom

    northwestMuffle = assemblyShop
    eastMuffle = labA
    westMuffle = commonRoom
    southeastMuffle = itOffice
    southMuffle = serverRoomBottom
}

+coolingDuctMiddleSegment: Decoration { 'cooling duct;access;door hatch'
    "TODO: Add description. "

    noDoorHereMsg = 'This segment of the duct has no access door. '

    decorationActions = [Examine, Open, Close, Enter, GoThrough, LookIn, PeekThrough, PeekInto]
    dobjFor(Close) asDobjFor(Open)
    dobjFor(Enter) asDobjFor(Open)
    dobjFor(GoThrough) asDobjFor(Open)
    dobjFor(LookIn) asDobjFor(Open)
    dobjFor(PeekThrough) asDobjFor(Open)
    dobjFor(PeekInto) asDobjFor(Open)
    dobjFor(Open) {
        validate() {
            illogical(noDoorHereMsg);
        }
    }
}

lifeSupportBottom: Room { 'Life Support (Lower Level)'
    "TODO: Add description. "

    up = lifeSupportTop

    roomDaemon() {
        ductFog.rollingDesc(coolingDuctLowerOuterDoor);
        inherited();
    }
}

+coolingDuctLowerOuterDoor: CoolingDuctOuterDoor {
    otherSide = coolingDuctLowerInnerDoor

    makeOpen(stat) {
        inherited(stat);

        if (stat) {
            ductFog.moveInto(lifeSupportBottom);
        }
        else {
            ductFog.moveInto(nil);
        }
    }
}

class ColdFog: Decoration {
    vocab = 'fog;cold freezing frozen;mist'
    desc = "{I} {see} nothing special about the cold fog. "
    feelDesc = freezingAtmosphere.feelDesc
    smellDesc = freezingAtmosphere.smellDesc

    decorationActions = [Examine, SmellSomething, Feel]

    rollingDesc(door) {
        if (!door.isOpen) return;
        "A <<freezer.coldSynonyms>> <<one of>>mist<<or>>fog<<at random>>
        rolls <<one of>>from<<or>>out of<<at random>> the open
        <<door.name>>. ";
    }
}

ductFog: ColdFog;

insideCoolingDuctUpper: CoolingDuctSegment { '<<nameHeader>> (Upper Segment)'
    up = "The duct seems to end here. "
    down = insideCoolingDuctLower
    out = coolingDuctUpperInnerGrate

    regions = [coolingDuctSightLine]

    inRoomName(pov) {
        return 'in the upper segment';
    }
}

+coolingDuctUpperInnerGrate: Door {
    vocab = coolingDuctUpperOuterGrate.vocab
    desc = coolingDuctUpperOuterGrate.desc
    otherSide = coolingDuctUpperOuterGrate

    airlockDoor = true
    isTransparent = true
    passActionStr = 'exit'
}

coolingDuctUpperOuterGrate: Door { 'cooling outlet grate;access duct' @serverRoomTop
    "TODO: Add description. "

    otherSide = coolingDuctUpperInnerGrate

    airlockDoor = true
    isTransparent = true
}

insideCoolingDuctLower: CoolingDuctSegment { '<<nameHeader>> (Lower Segment)'
    up = insideCoolingDuctUpper
    down = "If you go any lower, you might freeze to death;
        the industrial-grade heat exchanger is probably that way. "
    out = coolingDuctLowerInnerDoor

    inRoomName(pov) {
        return 'in the lower segment';
    }
}

+coolingDuctLowerInnerDoor: CoolingDuctInnerDoor {
    otherSide = coolingDuctLowerOuterDoor

    travelDesc =
        "<<standardExitMsg>>.
        <<if gActor == gPlayerChar>>\^<<freezer.expressAmbienceOnExit>>. <<end>>"
}