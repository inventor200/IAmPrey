fakePumpRoom: Room { 'The Reactor Turbine Room'
    desc = wasteProcessing.desc

    north = southReservoirCorridorEntry
    floorObj = cementFloor
    ceilingObj = industrialCeiling

    eastMuffle = reservoirControlRoom
}
+reactorTurbines: Decoration 'the reactor turbine pumps'
    plural = true
;

reactorNoiseRoom: Room { 'The Reactor Room'
    "How the actual fuck are you reading this right now?!"

    northMuffle = southHall
    westMuffle = southBathroom
    northeastMuffle = kitchen
}
+reactor: Decoration 'the reactor';

reactorHumSound: SoundProfile
    '<<standardString>>'
    '<<standardString>>'
    '<<standardString>>'
    strength = 4

    standardString =
        'the <<one of>>mighty<<or>>deep<<or>>resonant<<at random>>, muffled
        <<one of>>hum<<or>>thrum<<or>>growl<<at random>> of
        <<one of>>the facility reactor<<or>>the reactor<<or
        >>a <<one of>>faraway<<or>>distant<<at random>>
        <<one of>>powerplant<<or>>power source<<or>>machine<<at random>><<at random>>'
;
+reactorSubtleSound: SubtleSound
    'reactor hum'
    'The hum seems to have stopped'
    'thrum growl'
;

turbineSound: SoundProfile
    'the <<standardString>>'
    'the <<standardString>>'
    'the distant, <<standardString>>'
    strength = 3

    standardString =
        '<<one of>>hideous<<or>>cacophonous<<or>>dissonant<<or
        >>thunderous<<at random>><<one of
        >>, muffled <<one of>>scream<<or>>shriek<<or>>screech<<at random>><<or
        >>, <<one of>>air-<<one of>>ripping<<or>>tearing<<or>>shredding<<at random>><<or
        >>wall-<<one of>>shaking<<or>>vibrating<<or>>shivering<<at random>><<at random>>
        <<one of>>noise<<or>>racket<<or>>din<<or>>whir<<at random
        >><<at random>> of <<one of
        >>the reactor turbine pumps<<or>>the reactor pumps<<or
        >>the reactor turbines<<or>>the turbine pumps<<or>>turbines<<or>>the pumps<<or
        >><<one of>>powerful <<or>>industrious
        <<or>>spinning <<or>>energetic <<or>><<at random>>machines<<at random>>'
;

waterfallSound: SoundProfile
    'the muffled, <<standardString>>'
    'the <<standardString>>'
    'the <<standardString>>'
    strength = 3

    standardString =
        '<<one of>>all-consuming<<or>>reality-filling<<or
        >><<one of>>awesome<<or>>grand<<or>>colossal<<at random>>,
        <<one of>>steady<<or>>gushing<<or>>constant<<at random
        >><<at random>>
        <<one of>>hiss<<or>>noise<<or
        >>rush<<at random>> of
        <<one of>>waterfalls<<or>><<one of
        >>falling<<or>>plummeting<<or>>surging<<at random>> water<<at random>>'
;

ambientReactorNoiseRunner: InitObject {
    noiseDaemon = nil

    execute() {
        if (noiseDaemon == nil) {
            noiseDaemon = new Daemon(self, &playNoise, 0);
        }
    }

    playNoise() {
        soundBleedCore.createSound(reactorHumSound, reactor, reactorNoiseRoom, nil);
        soundBleedCore.createSound(turbineSound, reactorTurbines, fakePumpRoom, nil);
        soundBleedCore.createSound(waterfallSound, reservoirWaterFromAbove, reservoir, nil);
    }
}

reservoirCorridor: Room { 'The Reservoir Corridor'
    "TODO: Add description. "

    north = northReservoirCorridorExit
    east = reservoirControlRoom
    south = southReservoirCorridorExit

    westMuffle = kitchen

    floorObj = cementFloor
    ceilingObj = industrialCeiling
    atmosphereObj = humidAtmosphere
    moistureFactor = 0
}

+northReservoirCorridorExit: MaintenanceDoor { 'the exit door'
    desc = lockedDoorDescription
    otherSide = northReservoirCorridorEntry
    soundSourceRepresentative = northReservoirCorridorEntry
}

+southReservoirCorridorExit: MaintenanceDoor { 'the reactor access door'
    desc = lockedDoorDescription
    otherSide = southReservoirCorridorEntry
    travelBarriers = [wasteProcessingBarrier]
}

northReservoirCorridorEntry: MaintenanceDoor { 'the reservoir access door' @freezer
    desc = lockedDoorDescription
    otherSide = northReservoirCorridorExit
}

southReservoirCorridorEntry: MaintenanceDoor { 'the reservoir access south door' @fakePumpRoom
    desc = lockedDoorDescription
    otherSide = southReservoirCorridorExit
    soundSourceRepresentative = southReservoirCorridorExit
}

reservoirControlSightLine: WindowRegion;

reservoirControlRoom: Room { 'The Reservoir Control Room'
    "TODO: Add description. "

    east = reservoirDoorwayOut
    west = reservoirCorridor
    out asExit(east)

    southwestMuffle = fakePumpRoom

    regions = [reservoirControlSightLine]
    floorObj = cementFloor
    ceilingObj = industrialCeiling
    atmosphereObj = humidAtmosphere
    moistureFactor = 0

    getSpecialPeekDirectionTarget(dirObj) {
        if (dirObj == eastDir) return windowInreservoirControlRoom;
        return inherited(dirObj);
    }
}

+reservoirDoorwayOut: Passage { 'the access doorway;;door'
    "TODO: Add description. "
    destination = reservoir
}

DefineWindowPair(reservoirControlRoom, reservoir)
    vocab = 'observation window;reinforced monitoring control room[weak] reactor[weak] reservoir'
    desc = "TODO: Add description. "
    breakMsg = 'The window is reinforced, and designed to resist creatures like you. '
    remoteHeader = 'through the window'
;

/*
 * UPPER:
 * Reactor water sprays into from the south as steam, cools,
 * and hot air is pulled into a large ceiling fan. A condenser
 * feed acts as a secondary waterfall from the east. The upper
 * half is much like a sauna.
 * 
 * LOWER:
 * Cooler water condenses and collects at the bottom. This
 * reservoir also acts as an overflow containment system. The
 * water here is "cooler", but it's still quite hot (just not
 * harmful).
 */

reservoir: Room { 'The Reactor Reservoir'
    "TODO: Add description. "

    west = reservoirDoorwayIn
    down = diveIntoWaterConnector
    in asExit(west)

    regions = [reservoirControlSightLine]
    ceilingObj = reservoirCeilingFan
    floorObj = reservoirCatwalk
    atmosphereObj = humidAtmosphere
    moistureFactor = 1

    descFrom(pov) {
        "TODO: Add remote description. ";
    }

    getSpecialPeekDirectionTarget(dirObj) {
        if (dirObj == westDir) return windowInreservoir;
        if (dirObj == downDir) return reservoirWaterFromAbove;
        return inherited(dirObj);
    }

    jumpIntoWater() {
        diveIntoWaterConnector.travelVia(gActor);
    }

    jumpOffFloor() {
        doInstead(ParkourJumpDownInto, reservoirWaterFromAbove);
    }

    canGetOffFloor = true

    roomBeforeAction() {
        if (gActionIs(JumpOffIntransitive) || gActionIs(ParkourJumpOffIntransitive) || gActionIs(Jump)) {
            jumpOffFloor();
            exit;
        }

        inherited();
    }
}

+diveIntoWaterConnector: TravelConnector {
    isConnectorListed = nil
    destination = reservoirStrainer

    travelDesc() {
        gActor.soak();
        if (gCatMode) {
            "Your regal confidence might have been a little <i>too</i> high this time,
            but you only wonder this for a few moments before you are
            swallowed by the hot reactor water. In a split second, you think
            you see <<gSkashekName>>, searching the water for something.\b
            <i><q><<gCatName>>?!</q></i> he screams, already sputtering
            through the water after you, and ditching an armful of harvested kelp.\b
            You thrash and reach the steamy surface, as the channel
            carries you and your echoing, panicked meows. Everything in you
            is devoted to a singular purpose: <i>Stay above water!</i>\b
            You hit the grate wall of the strainer stage, where the water
            becomes colder. You wrap your limbs around the its metal structure,
            desperate to not be swept away further.\b
            Running along the wall of the channel&mdash;like a
            <i>giant spider</i>&mdash;is
            <<gSkashekName>>. He sweeps you up in his arms and holds you close.\b
            <q>Bloody <i>hell</i>, <<gCatNickname>>, there are <i>other</i> ways to
            get my attention! I guess we're skipping bath time, then...</q>";
            finishGameMsg(ftVictory, gEndingOptionsWin);
        }
        else { //TODO: Write this better
            "You dive into the water, and the channel carries you. ";
        }
        inherited();
    }
}

+reservoirDoorwayIn: Passage { 'the control room doorway;;door'
    "TODO: Add description. "
    destination = reservoirControlRoom
}

+reservoirWaterFromAbove: Decoration { 'the water;;reservoir pit below down'
    "TODO: Add description.<<revealSkashekFishing()>> "

    decorationActions = [
        Examine, Search, SearchClose, SearchDistant, PeekInto, PeekThrough,
        ParkourJumpGeneric, ParkourJumpOverTo, ParkourJumpDownTo,
        ParkourJumpOverInto, ParkourJumpDownInto
    ]
    notImportantMsg = '{The subj cobj} {is} too far away. '
    
    dobjFor(Search) asDobjFor(Examine)
    dobjFor(LookIn) asDobjFor(Examine)
    dobjFor(SearchClose) asDobjFor(Examine)
    dobjFor(SearchDistant) asDobjFor(Examine)
    dobjFor(PeekInto) asDobjFor(Examine)
    dobjFor(PeekThrough) asDobjFor(Examine)
    dobjFor(LookThrough) asDobjFor(Examine)

    dobjFor(ParkourJumpGeneric) asDobjFor(ParkourJumpDownInto)
    dobjFor(ParkourJumpOverTo) asDobjFor(ParkourJumpDownInto)
    dobjFor(ParkourJumpDownTo) asDobjFor(ParkourJumpDownInto)
    dobjFor(ParkourJumpOverInto) asDobjFor(ParkourJumpDownInto)
    dobjFor(ParkourJumpDownInto) {
        preCond = nil
        remap = nil
        verify() { }
        check() { }
        action() {
            reservoir.jumpIntoWater();
        }
        report() { }
    }

    skashekRevealedFishing = nil

    revealSkashekFishing() {
        if (!gCatMode) return '';
        if (skashekRevealedFishing) return '';

        skashekRevealedFishing = true;
        skashekFishing.moveInto(reservoir);

        return '\bIn the water below, you see <<gSkashekName>>.
            It looks like he\'s collecting plants of some kind.\b
            If you were to attack him for scheduling bath time,
            then this would be a tactical method. Sure, it\'s a long way down,
            but you could probably get him after landing in the water.
            Element of surprise, and all that.';
    }
}

+reactorKelp: Decoration { 'plant;mutated subspecies[weak] leafy glowing white pale reactor[weak];kelp leaf{leaves}'
    "They're hard to see from up here, but they vaguely look like pale leaves.
    It might be an illusion, but they seem to glow slightly, too. Maybe it's a
    mutated subspecies of kelp...? "
    ambiguouslyPlural = true
    notImportantMsg = '{The subj cobj} {is} too far away. '
}

modify VerbRule(Attack)
    ('attack'|'kill'|'hit'|'kick'|'punch'|'strike'|'punish'|
    ('lunge'|'dive') (('down'|) 'at'|)|'pounce' ('at'|'on'|'upon')|
    'tackle'|'ambush') singleDobj :
;

skashekFishing: Decoration {
    vocab = skashek.vocab
    desc = "He seems to be collecting some kind of leafy plant, growing
        in the reservoir water. He already has a collection, and seems
        distracted. He has no idea you're up here. "

    decorationActions = [
        Examine,
        ParkourJumpGeneric, ParkourJumpOverTo, ParkourJumpDownTo,
        ParkourJumpOverInto, ParkourJumpDownInto, Attack
    ]
    notImportantMsg = 'He\'s a little too far down for that. '

    dobjFor(ParkourJumpGeneric) asDobjFor(ParkourJumpDownInto)
    dobjFor(ParkourJumpOverTo) asDobjFor(ParkourJumpDownInto)
    dobjFor(ParkourJumpDownTo) asDobjFor(ParkourJumpDownInto)
    dobjFor(ParkourJumpOverInto) asDobjFor(ParkourJumpDownInto)
    dobjFor(Attack) asDobjFor(ParkourJumpDownInto)
    dobjFor(ParkourJumpDownInto) {
        preCond = nil
        remap = nil
        verify() { }
        check() { }
        action() {
            reservoir.jumpIntoWater();
        }
        report() { }
    }
}

reservoirCeilingFan: Ceiling { 'large ceiling fan'
    "TODO: Add description."
}

humidAtmosphere: Atmosphere { 'air;humid moist wet;mist fog steam humidity moisture atmosphere breeze wind'
    "The air is thick with warm humidity. It's like a sauna here. "
    feelDesc = "{I} can feel the humidity{dummy} stick to {me}. "
    smellDesc = "The hot, wet air{dummy} fills {my} lungs. "
}

reservoirCatwalk: Floor { 'catwalk;;platform floor ground deck ledge edge'
    "TODO: Add description. "

    dobjFor(LookUnder) {
        verify() { }
        action() {
            doNested(Examine, reservoirWaterFromAbove);
        }
        report() { }
    }
}

reservoirStrainer: Room { 'The Strainer Stage'
    "TODO: Add description. "

    north = "Swimming against the current would only dead-end you in the reservoir. "
    south = "The grate won't budge. "
}

DefineDoorWestTo(lifeSupportBottom, reservoirStrainer, 'the reservoir access door')