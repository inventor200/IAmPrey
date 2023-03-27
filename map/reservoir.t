fakePumpRoom: Room { 'The Reactor Turbine Room'
    desc = wasteProcessing.desc

    north = southReservoirCorridorEntry
    floorObj = cementFloor
    ceilingObj = industrialCeiling

    eastMuffle = reservoirControlRoom

    mapModeLockedDoors = [southReservoirCorridorEntry]
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
    'the distant, <<standardString>>'
    strength = 2
    immediateFalloff = true

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

    subWaterfallString =
        '<<one of>>hiss<<or>>noise<<or
        >>rush<<at random>> of
        <<one of>>waterfalls<<or>><<one of
        >>falling<<or>>plummeting<<or>>surging<<at random>> water<<at random>>'

    fullWaterfallString =
        '<<one of>>all-consuming<<or>>reality-filling<<or
        >><<one of>>awesome<<or>>grand<<or>>colossal<<at random>>,
        <<one of>>steady<<or>>gushing<<or>>constant<<at random
        >><<at random>>
        <<subWaterfallString>>'
    
    mildWaterfall =
        '<<one of>>steady<<or>>gushing<<or>>constant<<at random>>
        <<subWaterfallString>>'

    hearWaterfall(directionStr) {
        "<<directionStr>><<mildWaterfall>>. ";
    }

    execute() {
        if (noiseDaemon == nil) {
            noiseDaemon = new Daemon(self, &playNoise, 0);
        }
    }

    playNoise() {
        soundBleedCore.createSound(reactorHumSound, reactor, reactorNoiseRoom, nil);
        soundBleedCore.createSound(turbineSound, reactorTurbines, fakePumpRoom, nil);
        //soundBleedCore.createSound(waterfallSound, reservoirWaterFromAbove, reservoir, nil);
    }
}

reservoirCorridor: Room { 'The Reservoir Corridor'
    "A barren, naked corridor, with cement floors, and exposed pipes
    on the ceiling. A rusty crate sits by the west wall, under a small,
    metal door.\b
    To the south, a locked door goes to the Reactor Turbine Room.
    To the north, another locked door leads to the Freezer.
    To the <<hyperDir('east')>>, a doorway leads to the Reservoir
    Control Room. "

    north = northReservoirCorridorExit
    east = reservoirControlRoom
    south = southReservoirCorridorExit

    westMuffle = kitchen

    floorObj = cementFloor
    ceilingObj = industrialCeiling
    atmosphereObj = humidAtmosphere
    moistureFactor = 0

    roomDaemon() {
        checkRoomDaemonTurns;
        ambientReactorNoiseRunner.hearWaterfall(
            'From the east, {i} hear the distant, '
        );
        inherited();
    }

    mapModeDirections = [&east]
    mapModeLockedDoors = [northReservoirCorridorExit, southReservoirCorridorExit]
    familiar = roomsFamiliarByDefault
}

+reservoirCorridorCrate: FixedPlatform { 'rusty crate;metal;box'
    "A rusty, metal crate. "
}
++LowFloorHeight;

+northReservoirCorridorExit: MaintenanceDoor { 'the freezer door;exit'
    desc = lockedDoorDescription
    otherSide = northReservoirCorridorEntry
    soundSourceRepresentative = northReservoirCorridorEntry
    pullHandleSide = true
}

+southReservoirCorridorExit: MaintenanceDoor { 'the reactor access door'
    desc = lockedDoorDescription
    otherSide = southReservoirCorridorEntry
    travelBarriers = [wasteProcessingBarrier]
    pullHandleSide = true
}

northReservoirCorridorEntry: MaintenanceDoor { 'the reservoir access door' @freezer
    desc = lockedDoorDescription
    otherSide = northReservoirCorridorExit
    pullHandleSide = nil
}

southReservoirCorridorEntry: MaintenanceDoor { 'the reservoir access south door' @fakePumpRoom
    desc = lockedDoorDescription
    otherSide = southReservoirCorridorExit
    soundSourceRepresentative = southReservoirCorridorExit
    pullHandleSide = nil
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

    roomDaemon() {
        checkRoomDaemonTurns;
        ambientReactorNoiseRunner.hearWaterfall(
            'From the east, {i} hear the '
        );
        inherited();
    }

    mapModeDirections = [&east, &west]
    familiar = roomsFamiliarByDefault
}

+reservoirDoorwayOut: Passage { 'the access doorway;;door'
    "TODO: Add description. "
    destination = reservoir
}

DefineWindowPair(reservoirControlRoom, reservoir)
    vocab = 'observation window;reinforced monitoring control room[weak] reactor[weak] reservoir glass;glass pane'
    desc = "TODO: Add description. "
    breakMsg = 'The window is reinforced,
        and designed to resist creatures{dummy} like {me}. '
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

//TODO: Add ambient stuff for all the water going everywhere
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

    roomDaemon() {
        checkRoomDaemonTurns;
        "From all around, {i} hear the
        <<ambientReactorNoiseRunner.fullWaterfallString>>. ";
        inherited();
    }

    mapModeDirections = [&west]
    familiar = roomsFamiliarByDefault
}

+diveIntoWaterConnector: TravelConnector {
    isConnectorListed = nil
    destination = reservoirStrainer

    travelDesc() {
        gActor.soak();
        if (gCatMode) {
            "{My} regal confidence might have been a little <i>too</i> high this time,
            but {i} only wonder this for a few moments before {i} {am}
            swallowed by the hot reactor water.<<
            if !skashekFishing.skashekRevealedFishing>>
            In a split second, {i} think {i} see
            <<gSkashekName>>, searching the water for something.<<end>>\b
            <i><q><<gCatName>>?!</q></i>
            <<if skashekFishing.skashekRevealedFishing>><<gSkashekName>><<else
            >>he<<end>>
            screams, already sputtering through the water{dummy} after {me},
            and ditching an armful of harvested kelp.\b
            {I} thrash and reach the steamy surface, as the channel{dummy}
            carries {me} and {my} echoing, panicked meows. Everything{dummy} in {me}
            is devoted to a singular purpose: <i>Stay above water!</i>\b
            {I} hit the grate wall of the strainer stage, where the water
            becomes colder. {I} wrap {my} limbs around the its metal structure,
            desperate to not be swept away further.\b
            Running along the wall of the channel&mdash;like a
            <i>giant spider</i>&mdash;is
            <<gSkashekName>>. He{dummy} sweeps {me} up in his arms and
            holds{dummy} {me} close.\b
            <q>Bloody <i>hell</i>, <<gCatNickname>>, there are <i>other</i> ways to
            get my attention! </q>\b
            <i><q>I demand cancellation of Bath Time, peasant!!</q></i> {i} shout,
            but all that seems to come out is: <i><q>Mraow!!</q></i> ";
            finishGameMsg(ftVictory, gEndingOptionsWin);
        }
        else { //TODO: Write this better
            "{I} dive into the water, and the channel{dummy} carries {me}. ";
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
    
    remappingSearch = true
    remappingLookIn = true

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

    revealSkashekFishing() {
        if (!gCatMode) return '';
        if (skashekFishing.skashekRevealedFishing &&
            skashekFishing.suggestedAttack) return '';
        return skashekFishing.suggestAttackInObservation();
    }
}

+reactorKelp: Decoration { 'plant;mutated subspecies[weak] leafy glowing white pale reactor[weak];kelp leaf{leaves}'
    "They're hard to see from up here, but they vaguely look like pale leaves.
    It might be an illusion, but they seem to glow slightly, too. Maybe it's a
    mutated subspecies of kelp...? "
    ambiguouslyPlural = true
    notImportantMsg = '{The subj cobj} {is} too far away. '
}

skashekFishing: Decoration {
    vocab = skashek.vocab
    desc = "<<suggestAttackInObservation()>>"

    decorationActions = [
        Examine,
        ParkourJumpGeneric, ParkourJumpOverTo, ParkourJumpDownTo,
        ParkourJumpOverInto, ParkourJumpDownInto, Attack
    ]
    notImportantMsg = 'He\'s a little too far down for that. '

    specialDesc = "<<gSkashekName>> is down in the water, gathering strange
        plants again. "

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

    suggestedAttack = nil
    skashekRevealedFishing = nil

    strikeSuggestionMsg = 
        '\b{I} could probably strike him from up here.
        Sure, it\'s a long way down, but there\'s plenty of warm water
        to break {my} fall. Element of surprise, and all that. ';

    revealFishing() {
        if (skashekRevealedFishing) return;
        skashekRevealedFishing = true;
        skashekFishing.moveInto(reservoir);
    }

    suggestAttackInObservation() {
        if (suggestedAttack) return
            'He seems to be collecting some kind of leafy plant, growing
            in the reservoir water. He already has a collection, and seems
            distracted. He has no idea {i}{\'m} up here. ';
        suggestedAttack = true;
        local extraMsg = skashekRevealedFishing ?
            '\b<i>There he is, the scoundrel!</i>
            <<gSkashekName>> is in the reservoir water,
            just as {i} <i>brilliantly</i> suspected!'
            :
            '\bIn the water below, {i} see <<gSkashekName>>.
            It looks like he\'s collecting plants of some kind.';
        extraMsg += strikeSuggestionMsg;
        revealFishing();
        return extraMsg;
    }

    suggestAttackInSuspicion() {
        if (skashekRevealedFishing) return '';
        revealFishing();
        return '\b<i>Hmmm... He should be in the reservoir,
            gathering strange plants again...</i>';
    }
}

reservoirCeilingFan: Ceiling { 'large ceiling[n] fan'
    "TODO: Add description."
}

humidAtmosphere: Atmosphere { 'air;humid moist wet;mist fog steam humidity moisture atmosphere breeze wind'
    "The air is thick with warm humidity. It's like a sauna here. "
    feelDesc = "{I} can feel the humidity{dummy} stick to {me}. "
    smellDesc = "The hot, wet air{dummy} fills {my} lungs. "
}

reservoirCatwalk: Floor { 'catwalk;;platform floor ground deck ledge edge'
    "TODO: Add description. "

    dobjFor(PeekAround) asDobjFor(LookUnder)
    dobjFor(LookUnder) {
        verify() { }
        action() {
            doNested(Examine, reservoirWaterFromAbove);
        }
        report() { }
    }
}

//TODO: Sounds of rushing water
reservoirStrainer: Room { 'The Strainer Stage'
    "TODO: Add description. "

    north = "Swimming against the current would only dead-end{dummy}
        {me} in the reservoir. "
    south = "The grate won't budge. "

    mapModeDirections = [&west]
    familiar = roomsFamiliarByDefault
}

DefineDoorWestTo(lifeSupportBottom, reservoirStrainer, 'the Reservoir Access door')