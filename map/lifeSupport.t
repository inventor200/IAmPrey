//coolingDuctSightLine: HallRegion;

fakeDuctCeiling: Ceiling { 'ceiling;top;top[weak] end airflow'
    "The cooling duct is a wide, vertical drop. Cold air is pumped in from
    below, and is sent up to the server room, found elsewhere. "
}

coolingDuctWalls: Walls { 'walls;inner metal cooling;insides panels duct'
    "Metal panels form the cold walls of the claustrophobic duct."

    decorationActions = [
        Examine, Climb, ParkourClimbGeneric,
        ClimbUp, ParkourClimbUpTo, ParkourJumpUpTo,
        ParkourClimbUpInto, ParkourJumpUpInto,
        ClimbDown, ParkourClimbDownTo, ParkourJumpDownTo,
        ParkourClimbDownInto, ParkourJumpDownInto
    ]

    dobjFor(Climb) asDobjFor(ClimbUp)
    dobjFor(ParkourClimbGeneric) asDobjFor(ClimbUp)
    dobjFor(ParkourClimbUpTo) asDobjFor(ClimbUp)
    dobjFor(ParkourClimbUpInto) asDobjFor(ClimbUp)
    rerouteBasicJumpIntoForPlatform(ParkourJumpUpTo, ClimbUp)
    rerouteBasicJumpIntoForPlatform(ParkourJumpUpInto, ClimbUp)
    dobjFor(ClimbUp) {
        verify() { }
        check() { }
        action() {
            gPlayerChar.getOutermostRoom().attemptVerticalTravel(upDir);
        }
    }

    dobjFor(ParkourClimbDownTo) asDobjFor(ClimbDown)
    dobjFor(ParkourClimbDownInto) asDobjFor(ClimbDown)
    rerouteBasicJumpIntoForPlatform(ParkourJumpDownTo, ClimbDown)
    rerouteBasicJumpIntoForPlatform(ParkourJumpDownInto, ClimbDown)
    dobjFor(ClimbDown) {
        verify() { }
        check() { }
        action() {
            gPlayerChar.getOutermostRoom().attemptVerticalTravel(downDir);
        }
    }
}

fakeDuctFloor: Floor { 'space[n] below;bottom;ground bottom[weak] end drop curve floor'
    "The cooling duct is a wide, vertical drop, and curves below to the east,
    in the direction of the airflow's source. The facility's heat exchanger and
    fans are probably that way. "
}

class CoolingDuctSegment: Room {
    desc = "<<first time
        >>{I} <<one of>><<one of>>hold onto<<or>>grip<<at random>><<or
        >><<one of>>hold<<or>>press<<or>>push<<at random>>
        {myself} against<<at random>> <<insidesDesc>>.<<only>>
        <<if coolingDuctLowerOuterDoor.isOpen
        >>Light spills in from the open access door at the bottom,<<else
        >>Minimal hints of light bounce from the server room above,<<end>>
        giving {my} night vision enough to see. "
    nameHeader = 'Inside Cooling Duct'

    wallsDesc =
        '<<one of>>insides<<or>>walls<<or>>inner panels<<at random>>'
    insidesDesc =
        'the <<one of>><<freezer.coldSynonyms>><<or
        >><<freezer.coldAluminum>><<at random>>
        <<wallsDesc>><<one of>> of the duct<<or>><<at random>>'

    //regions = [coolingDuctSightLine]
    //lookAroundRegion = coolingDuctSightLine

    ceilingObj = fakeDuctCeiling
    wallsObj = coolingDuctWalls
    floorObj = fakeDuctFloor
    atmosphereObj = freezingAtmosphere
    isFreezing = true
    ambienceObject = coolingDuctAmbience

    roomBeforeAction() {
        if (gActionIs(Drop) || gActionIs(Throw) || gActionIs(ThrowDir) || gActionIs(ThrowTo)) {
            "If {i} let go of {that dobj} in here, {i} may never get it back. ";
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
                "<.p>{I} climb into the cooling duct<<if origin.isFreezing == nil
                >>, <<freezer.subclauseAmbienceOnEntry>><<end>>.
                {I} press {my} limbs against the <<freezer.coldAluminum>> walls.
                Now pinned in place, {i} {am} ready to climb
                <<gDirectCmdStr('up')>> or <<gDirectCmdStr('down')>><.p> ";
            }
        }
        if (gPlayerChar.isOrIsIn(actor)) {
            soundBleedCore.createSound(
                climbingNoiseProfile,
                actor,
                self,
                true
            );
        }
        //TODO: Skashek climbing up makes noise
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

lifeSupportSound: SoundProfile
    'the <<standardString>>'
    'the <<standardString>>'
    'the distant, <<standardString>>'
    strength = 3

    standardString =
        '<<one of>>noise<<or>>racket<<or>>din<<or>>activity<<at random>>
        of <<one of>>air moving through ducts<<or>>industrial fans<<or
        >>industrious life support<<at random>>'
;

ambientLifeSupportNoiseRunner: InitObject {
    noiseDaemon = nil

    execute() {
        if (noiseDaemon == nil) {
            noiseDaemon = new Daemon(self, &playNoise, 0);
        }
    }

    playNoise() {
        soundBleedCore.createSound(
            lifeSupportSound, lifeSupportMachines,
            lifeSupportMachines.getOutermostRoom(), nil
        );
    }
}

lifeSupportMachines: MultiLoc, Thing { 'machines;;machinery pipes tubes fans'
    "Pipes, tubes, and machines fill the room with activity. Some even
    span the top and bottom floors of Life Support. "
    isFixed = true
    isDecoration = true
    plural = true

    locationList = [lifeSupportTop, lifeSupportBottom]

    getOutermostRoom() {
        local om = gPlayerChar.getOutermostRoom();
        if (om == lifeSupportBottom || om == reservoirStrainer ||
            om == insideCoolingDuctLower) {
            return lifeSupportBottom;
        }
        return lifeSupportTop;
    }

    getAmbience() {
        "<<one of>><<or
        >>The mechanical roar of machinery continues.
        <<or>>The room is full of noise.
        <<or>>The industrious fans and other mechanisms fill the room with sound.
        <<at random>>";
    }
}

catDownALadderBarrier: TravelBarrier {
    canTravelerPass(actor, connector) {
        return actor != cat;
    }
    
    explainTravelBarrier(actor, connector) {
        "Unlike the other ladder (found by Server Access), this one
        is completely vertical, which {i} cannot climb safely. ";
    }
}

lifeSupportTop: Room { 'Life Support (Upper Level)'
    "Machines, ducts, and pipes fill the room.
    One machine, in particular, occupies the north half of the room:
    the primary fan unit.\b
    The exit door is to the southwest, but it seems to be locked.
    <<if gCatMode>>A ladder is here, but it's not accessible
    to cats.<<else
    >>A ladder{dummy} is available to take {me} <<hyperDir('down')>>
    to the lower floor of Life Support.<<end>> "

    southwest = northUtilityPassageEntry
    down = lifeSupportLadderTop

    northwestMuffle = assemblyShop
    eastMuffle = labA
    westMuffle = commonRoom
    southeastMuffle = library
    southMuffle = serverRoomBottom

    roomDaemon() {
        checkRoomDaemonTurns;
        lifeSupportMachines.getAmbience();
        inherited();
    }

    mapModeDirections = [&down]
    mapModeLockedDoors = [northUtilityPassageEntry]
    familiar = roomsFamiliarByDefault
    roomNavigationType = escapeRoom

    RoomHasLadderDown(lifeSupportLadderTop)
}

+lifeSupportLadderTop: ClimbDownIntoPlatform { 'ladder'
    "<<if gCatMode>>A ladder for citizens, but it's far too vertical
    for {my} old bones to climb.<<
    else>>A ladder allows travel to the floor below.<<end>> "

    travelDesc =
        "{I} quickly<<one of>>{aac}
        climb{s/ed} down<<or>>{aac}
        descend{s/ed}<<at random>> the ladder. "

    destination = lifeSupportBottom
    travelBarriers = [catDownALadderBarrier]
}

+primaryFanUnit: FixedPlatform { 'primary fan unit;;machine[weak]'
    "A massive, metal box, covered in ducts, and roaring with life.
    A strong breeze comes from a vent on the outside of the machine. "
}
++AwkwardFloorHeight;

+coolingDuctMiddleSegment: Decoration { 'cooling duct;access;door hatch'
    "A large, metal duct, running vertically up the south wall. "

    noDoorHereMsg = 'This segment of the duct has no access door. '

    specialDesc = "A large cooling duct runs vertically, along the south wall. "

    remappingLookIn = true
    remappingSearch = true

    decorationActions = [
        Examine, Open, Close, Enter, GoThrough,
        LookIn, PeekThrough, PeekInto,
        Search, SearchClose, SearchDistant
    ]
    dobjFor(Close) asDobjFor(Open)
    dobjFor(Enter) asDobjFor(Open)
    dobjFor(GoThrough) asDobjFor(Open)
    dobjFor(LookIn) asDobjFor(Open)
    dobjFor(Search) asDobjFor(Open)
    dobjFor(SearchClose) asDobjFor(Open)
    dobjFor(SearchDistant) asDobjFor(Open)
    dobjFor(PeekThrough) asDobjFor(Open)
    dobjFor(PeekInto) asDobjFor(Open)
    dobjFor(Open) {
        preCond = [touchObj]
        verify() {
            illogical(noDoorHereMsg);
        }
    }
}

lifeSupportBottom: Room { 'Life Support (Lower Level)'
    "Machines, ducts, and pipes fill the room, and
    the floor is damp with residual water.\b
    To the <<hyperDir('east')>>, a door provides access to the Reservoir Strainer Stage.
    A ladder, meanwhile, goes <<hyperDir('up')>> to the upper floor of Life Support. "

    up = lifeSupportLadderBottom

    roomDaemon() {
        checkRoomDaemonTurns;
        lifeSupportMachines.getAmbience();
        ductFog.rollingDesc(coolingDuctLowerOuterDoor);
        inherited();
    }

    mapModeDirections = [&up, &east]
    familiar = roomsFamiliarByDefault
    roomNavigationType = escapeRoom
}

+Decoration { 'puddle;residual;water'
    "Water, which has not dried after
    a recent entry from the Reservoir Strainer Stage. "
    ambiguouslyPlural = true
}

+lifeSupportLadderBottom: ClimbUpIntoPlatform { 'ladder'
    "A ladder allows travel to the floor above. "

    travelDesc =
        "{I} quickly<<one of>>{aac} 
        climb{s/ed}<<or>>{aac} 
        scale{s/ed}<<at random>> the ladder. "

    destination = lifeSupportTop
}

+coolingDuctLowerSegment: Decoration { 'cooling duct'
    desc = coolingDuctMiddleSegment.desc

    specialDesc = coolingDuctMiddleSegment.specialDesc

    remappingLookIn = true

    decorationActions = (coolingDuctMiddleSegment.decorationActions)
    dobjFor(Open) { remap = coolingDuctLowerOuterDoor }
    dobjFor(Close) { remap = coolingDuctLowerOuterDoor }
    dobjFor(Enter) { remap = coolingDuctLowerOuterDoor }
    dobjFor(GoThrough) { remap = coolingDuctLowerOuterDoor }
    dobjFor(LookIn) { remap = coolingDuctLowerOuterDoor }
    dobjFor(PeekThrough) { remap = coolingDuctLowerOuterDoor }
    dobjFor(PeekInto) { remap = coolingDuctLowerOuterDoor }
    dobjFor(Search) { remap = coolingDuctLowerOuterDoor }
    dobjFor(SearchClose) { remap = coolingDuctLowerOuterDoor }
    dobjFor(SearchDistant) { remap = coolingDuctLowerOuterDoor }
}

++coolingDuctLowerOuterDoor: PrefabDoor {
    vocab = 'access door;cooling[weak] duct;hatch'
    desc = "A discreet access door, probably for maintenance and repairs. "
    passActionStr = 'enter'
    secretLocalPlatform = true
    otherSide = coolingDuctLowerInnerDoor

    mostLikelyDestination() {
        return serverRoomTop;
    }

    airlockDoor = true
    skipHandle = true

    standardExitMsg =
        '<<one of>>{I} awkwardly<<or>>With difficulty, {i}<<at random>>{aac}
        prop{s/?ed} {myself} into position, and exit{s/ed} through <<theName>>'

    travelDesc =
        "<<standardExitMsg>>. "

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

    //regions = [coolingDuctSightLine]

    inRoomName(pov) {
        return 'in the upper segment';
    }
}

+coolingDuctUpperInnerGrate: CoolingDuctGrate {
    vocab = coolingDuctUpperOuterGrate.vocab
    otherSide = coolingDuctUpperOuterGrate

    passActionStr = 'exit'
}

coolingDuctUpperOuterGrate: CoolingDuctGrate {
    vocab = 'cooling outlet ' + defaultVentVocab + ' access duct' + defaultVentVocabSuffix
    location = serverRoomTop
    otherSide = coolingDuctUpperInnerGrate

    mostLikelyDestination() {
        return lifeSupportBottom;
    }
}

class CoolingDuctGrate: VentGrateDoor {
    airlockDoor = true
    isTransparent = true

    catFailMsg = 
        'As with other grates and vents, {i} {am} able to paw this one
        open, but the breeze is colder than {my} old, kingly joints can
        withstand.\b{I} allow the grate to close, and {i} return to
        the floor. '

    dobjFor(Open) {
        verify() {
            if (gActorIsCat) {
                inaccessible(catFailMsg);
            }
            inherited();
        }
    }

    dobjFor(GoThrough) {
        verify() {
            if (gActorIsCat) {
                inaccessible(catFailMsg);
            }
            inherited();
        }
    }
}

insideCoolingDuctLower: CoolingDuctSegment { '<<nameHeader>> (Lower Segment)'
    up = insideCoolingDuctUpper
    down = "If {i} go any lower, {i} might freeze to death;
        the industrial-grade heat exchanger is probably that way. "
    out = coolingDuctLowerInnerDoor

    inRoomName(pov) {
        return 'in the lower segment';
    }
}

+coolingDuctLowerInnerDoor: PrefabDoor {
    vocab = 'access door;cooling[weak] duct;hatch'
    desc = "An access door, probably for maintenance and repairs. "
    otherSide = coolingDuctLowerOuterDoor
    destination = lifeSupportBottom
    destinationPlatform = lifeSupportBottom

    airlockDoor = true
    passActionStr = 'exit'
    skipHandle = true

    standardExitMsg =
        '<<one of>>{I} awkwardly<<or>>With difficulty, {i}<<at random>>{aac}
        prop{s/?ed} {myself} into position, and exit{s/ed} through <<theName>>'

    travelDesc =
        "<<standardExitMsg>>.
        <<if gActorIsPlayer>>\^<<freezer.expressAmbienceOnExit>>. <<end>>"
}