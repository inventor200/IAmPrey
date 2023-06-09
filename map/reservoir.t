fakePumpRoom: Room { 'The Reactor Turbine Room'
    desc = wasteProcessing.desc

    north = southReservoirCorridorEntry
    floorObj = cementFloor
    ceilingObj = industrialCeiling
    ambienceObject = reservoirCorridorAmbience

    eastMuffle = reservoirControlRoom

    mapModeLockedDoors = [southReservoirCorridorEntry]
}
+reactorTurbines: Decoration 'the reactor turbine pumps'
    plural = true
;

reactorNoiseRoom: Room { 'The Reactor Room'
    "How are you reading this right now?! Reactor noise error!!"

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
        #if __DEBUG_IGNORE_FAKE_SOUNDS
        //
        #else
        soundBleedCore.createSound(reactorHumSound, reactor, reactorNoiseRoom, nil);
        soundBleedCore.createSound(turbineSound, reactorTurbines, fakePumpRoom, nil);
        //soundBleedCore.createSound(waterfallSound, reservoirWaterFromAbove, reservoir, nil);
        #endif
    }
}

reservoirCorridor: Room { 'The Reservoir Corridor'
    "A barren, naked corridor, with cement floors, and exposed pipes
    on the ceiling. A rusty crate sits by the west wall, under a small,
    metal door.\b
    To the south, a locked door goes to the Reactor Turbine Room.
    To the north, another locked door leads to the Freezer.
    To the <<hyperDir('east')>> is the Reservoir
    Control Room. "

    north = northReservoirCorridorExit
    east = reservoirControlRoom
    south = southReservoirCorridorExit

    westMuffle = kitchen

    floorObj = cementFloor
    ceilingObj = industrialCeiling
    atmosphereObj = humidAtmosphere
    moistureFactor = 0
    ambienceObject = reservoirCorridorAmbience

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
    roomNavigationType = escapeRoom
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
    "The Control Room boasts the latest in humidity-resistant computer systems.
    A doorway to the <<hyperDir('east')>> (beside a window) provides access to the Reservoir's
    observation catwalk, while a way to the <<hyperDir('west')>> goes back to
    the Corridor. "

    east = reservoirDoorwayOut
    west = reservoirCorridor
    out asExit(east)

    southwestMuffle = fakePumpRoom

    regions = [reservoirControlSightLine]
    floorObj = cementFloor
    ceilingObj = industrialCeiling
    atmosphereObj = humidAtmosphere
    moistureFactor = 0
    ambienceObject = reservoirControlRoomAmbience

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

+Unthing { 'engineer;;engineers'
    'The engineers are long-dead, and were like eaten ages ago. '
}

+Decoration { 'controls;computer;systems displays computers insulation'
    "Well-insulated controls and displays allow engineers to monitor the Reservoir. "
    plural = true
}

+reservoirDoorwayOut: Passage { 'the access doorway;;door'
    "A simple, metal doorway, leading <<hyperDir('out')>> to the catwalk. "
    destination = reservoir
}

DefineWindowPair(reservoirControlRoom, reservoir)
    vocab = 'observation window;reinforced monitoring control room[weak] reactor[weak] reservoir glass;glass pane'
    desc = "Something prevents the window from being obscured by steam and humidity,
    but the method isn't visible. "
    breakMsg = 'The window is reinforced,
        and designed to resist creatures{dummy} like {me}. '
    remoteHeader = 'through the window'
;

reservoir: Room { 'The Reactor Reservoir'
    "{I} stand on a catwalk, which is all that{dummy} stops {me} from falling.
    Gargantuan sprays of steaming water fire from outlets in the wall.
    However, they fail to meet the north wall before impacting the water
    below. The sheer scale of the Reservoir could fit the entire core group
    of facility rooms, and still have room for more.\b
    To the north, a giant section of wall acts as a region of perpetual rainfall,
    seemingly forming from nothing. The air is saturated with humidity and moisture,
    and plenty of droplets{dummy} pelt {me} from all the sprays.\b
    The sheer height of the Reservoir makes all depth perceptions of the eye fail
    spectacularly. An unbelievably-massive ceiling fan{dummy} works industriously above {me}.\b
    All of this, to act as an incredible heat exchanger for the facility's
    reactor, without ever interfacing with the outside world. "

    west = reservoirDoorwayIn
    down = diveIntoWaterConnector
    in asExit(west)

    regions = [reservoirControlSightLine]
    ceilingObj = reservoirCeilingFan
    floorObj = reservoirCatwalk
    atmosphereObj = humidAtmosphere
    moistureFactor = 1
    ambienceObject = reservoirTopAmbience

    descFrom(pov) {
        "Of what's visible, most of it is great sprays of water.
        It might be worth seeing in person! ";
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
    roomNavigationType = escapeRoom
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
            finishGameMsgSong(ftVictory, gEndingOptionsWin);
        }
        else if (checkNoDivesLeft()) {
            "{I} leap from the catwalk,
            but I feel a powerful hand{dummy} grab {me} from behind.
            <<skashek.getPeekHe(true)>> uses his furious
            strength{dummy} to violently throw {me} back into the Control Room.\b
            He's shouting something, but {I} don't catch enough before
            {my} head slams into the hard floor.\b
            {I} don't wake back up. ";
            finishGameMsgSong(ftDeath, gEndingOptionsLoss);
        }
        else if (checkBeingChased()) {
            "{I} dive from the catwalk, and plummet into the hot reservoir
            water below. The last thing {I} see before the water takes me
            is the silhouette of <<gSkashekName>>, watching me fall.\b";
            if (huntCore.spendTrick(&diveOffReservoirCount) == oneTrickRemaining) {
                "<b>He seems <i>very</i> angry{dummy} with {me}.
                {I} don't expect him{dummy} to allow {me} to try this again.</b>\b";
            }
            printTunnelExperience();
            "{I} can expect <<gSkashekName>> to be heading for Life Support
            to intercept me, though. {I} should waste no time getting finding
            a way out of this killzone. ";
            playSFX(emergeSnd);
        }
        else {
            "{I} dive from the catwalk, and plummet into the hot reservoir
            water below.\b";
            printTunnelExperience();
            "{I} need to be careful in the nearby Life Support area,
            as it can be a bit of a narrow killzone, if <i>he</i> is
            patrolling the area. ";
            playSFX(emergeSnd);
        }
        inherited();
    }

    tunnelExperience = 1

    printTunnelExperience() {
        if (tunnelExperience == 1) {
            "The hot, steaming water{dummy} carries {me} like rapids.
            The walls of the tunnel are smooth enough to not
            pose much of a danger, however.\b
            {I} slam into the metal grate of the Strainer Stage,
            but&mdash;other than mild bruising&mdash;{i} seem to be okay.\b";
        }
        else if (tunnelExperience == 2) {
            "{I} {am}, once again, carried by the hot,
            steaming waters of the reservoir tunnel.
            This time, {i} make sure to push {myself} off of the tunnel
            walls.\b
            Once {i} see the imminent Strainer Stage grate, {i} hold {my}
            arms forward to catch {myself}, and {my} hands protest with impact
            pains. {I}{'m} less injured this time around, though.\b";
        }
        else {
            "{I} {am}, once again, carried by the hot,
            steaming waters of the reservoir tunnel.
            At this point, {i}{'m} able to almost remain feet-forward for
            the entire trip, using {my} hands to maintain orientation.\b
            Once {i} see the imminent Strainer Stage grate, {i} cushion
            the impact with my legs, as if {i} had landed on a sideways floor.\b";
        }
        if (tunnelExperience < 3) tunnelExperience++;
    }

    checkBeingChased() {
        // Is Skashek chasing?
        if (!skashek.isChasing()) return nil;
        local om = skashek.getOutermostRoom();
        // Is he right behind the player?
        if (om != reservoirControlRoom && om != reservoir) return nil;
        return true;
    }

    checkNoDivesLeft() {
        if (!checkBeingChased()) return nil;
        return huntCore.pollTrick(&diveOffReservoirCount) == noTricksRemaining;
    }
}

+reservoirDoorwayIn: Passage { 'the control room doorway;;door'
    "A metal doorway, leading <<hyperDir('in')>> to the Control Room. "
    destination = reservoirControlRoom
}

+reservoirWaterFromAbove: Decoration { 'the water;;reservoir pit below down'
    "The water below seems deep to be <<if gCatMode>>knee-deep, though it's really
    hard to tell from way up here<<else
    >>quite deep, should {i} decide to dive<<end>>. It seems to flow out,
    <<if !gCatMode>>though, <<end>>probably
    through an unseen drainage tunnel.<<revealSkashekFishing()>> "

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

+reactorKelp: Decoration { 'kelp;mutated subspecies[weak] leafy glowing white pale reactor[weak];plant leaf leaves'
    "They're hard to see from up here, but they vaguely look like pale leaves.
    It might be an illusion, but they seem to glow slightly, too. Maybe it's a
    mutated subspecies of kelp...? "
    ambiguouslyPlural = true
    notImportantMsg = '{The subj cobj} {is} too far away. '
}

+Decoration { 'waterfall;;rainfall condenser'
    "The condenser along the north wall acts as some strange hybrid
    of a waterfall and localized rainfall. "
    notImportantMsg = '{The subj cobj} {is} too far away. '
}

+Decoration { 'spray;;outlet outlets sprays'
    "The outlets could fit a car, and the force and volume of piping-hot
    water spraying out could probably be misunderstood as some kind of
    weapon or demolition method. However, across the great expanse of
    the Reservoir, the spray turns to mist, and feeds into to rainfall
    by the north wall. "
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
    "The colossal ceiling fan has blades as wide as Lab A, and as
    long as the Storage Bay and Hangar, <i>combined</i>, and they move with
    the unimaginable force of a god. "
}

humidAtmosphere: Atmosphere { 'air;humid moist wet;mist fog steam humidity moisture atmosphere breeze wind'
    "The air is thick with warm humidity. It's like a sauna here. "
    feelDesc = "{I} can feel the humidity{dummy} stick to {me}. "
    smellDesc = "The hot, wet air{dummy} fills {my} lungs. "
}

reservoirCatwalk: Floor { 'catwalk;;platform floor ground deck ledge edge'
    "A reinforced, grated, metal catwalk allows
    for safe observation of the Reservoir. "

    dobjFor(PeekAround) asDobjFor(LookUnder)
    dobjFor(LookUnder) {
        verify() { }
        action() {
            doNested(Examine, reservoirWaterFromAbove);
        }
        report() { }
    }
}

reservoirStrainer: Room {
    vocab = 'The Strainer[weak] Stage;;tunnel'
    roomTitle = 'The Strainer Stage'
    desc = "The concrete tunnel ends here, at a massive grate. Water flows through
    in a current, which borders on hazardous. "

    north = "Swimming against the current would only dead-end{dummy}
        {me} in the reservoir. "
    south = "The grate won't budge. "

    mapModeDirections = [&west]
    familiar = roomsFamiliarByDefault
    ambienceObject = strainerStageAmbience
    decorativeSFX = [
        drip1Decor,
        drip2Decor,
        drip3Decor,
        drip4Decor,
        drip5Decor,
        drip6Decor,
        drip7Decor,
        drip8Decor,
        drip9Decor
    ]

    roomDaemon() {
        checkRoomDaemonTurns;
        "<<one of
        >>The current rushes <<one of>>past<<or>><<one of>>by<<or>>under<<or>>past<<at random>> me<<or>>noisily by<<at random>>.<<
        or>>The echoey tunnel is full of noise from the rushing waters.<<at random>> ";
        inherited();
    }
}

+Decoration { 'water;;current'
    "The water here is actually quite chilly, and flows past with an uneasy amount of force. "
}

+Decoration { 'strainer;;grate'
    "The metal strainer is littered in bits of pale kelp from the Reservoir floor. "
}
++Decoration { 'pale kelp'
    "Pale kelp from the Reservoir. It probably tastes horrific. "
}

DefineDoorWestTo(lifeSupportBottom, reservoirStrainer, 'the Reservoir Access door')