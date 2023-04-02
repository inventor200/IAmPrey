//#include "reflect.t"

class ArtificialWomb: Fixture {
    desc = "A half-pipe of metal frame is suspended above a catch net.
    The inner surface of this frame must be coated in some kind of substrate,
    because the fleshy parts of the giant, artificial womb cling to it.
    There is some springiness to the design, in case a developing clone
    twitches as it grows. "
    isBoardable = true

    matchPhrases = ['womb', 'tank']

    catchNet = nil

    filterResolveList(np, cmd, mode) {
        //"<.p><<reflectionServices.valToSymbol(mode)>><.p>";

        if (np.matches.length <= 1) return;

        local shouldTruncate = nil;

        local pluralWasMatched = nil;
        for (local i = 1; i <= np.matches.length; i++) {
            if (np.matches[i].obj == artificialWombs) {
                pluralWasMatched = true;
                break;
            }
        }

        if (pluralWasMatched) {
            shouldTruncate = gActionIs(RunAcross);
        }

        if (!shouldTruncate && mode == Indefinite) return;

        if (!shouldTruncate) {
            if (gActor.isDirectlyIn(deliveryRoomTowelRack)) {
                shouldTruncate = self != southwestWomb;
            }
            else {
                shouldTruncate = self != northwestWomb;
            }
        }

        if (shouldTruncate) {
            np.matches = np.matches.subset({m: m.obj != self});
        }
    }

    //contType = On
    isLikelyContainer() {
        return true;
    }

    canRunAcrossMe = true
    dobjFor(RunAcross) {
        remap = artificialWombs
    }

    canBonusReachDuring(obj, action) {
        return obj == artificialWombs;
    }

    doParkourSearch() {
        local doRunAcrossSearch = nil;
        local extraReconTarget = nil;
        if (gActor.isIn(northwestWomb.remapOn)) {
            extraReconTarget = deliveryRoomTowelRack;
            doRunAcrossSearch = self == southwestWomb;
        }
        else if (gActor.isIn(deliveryRoomTowelRack)) {
            extraReconTarget = northwestWomb;
            doRunAcrossSearch = self == northwestWomb || self == westWomb;
        }

        if (doRunAcrossSearch) {
            artificialWombs.doRecon();
            extraReconTarget.doRecon();
        }

        inherited();
    }
}

class WombRemapUnder: SubComponent {
    fakeContents = [genericCatchNet]
}

class WombRemapOn: SubComponent {
    isSafeParkourPlatform = true
    canBonusReachDuring(obj, action) {
        return obj == artificialWombs;
    }
}

class WombRemapIn: WombRemapOn {
    isInReachOfParkourSurface = true
}

modify VerbRule(Yell)
    'yell'|'scream'|'shout'|'holler'|'cry'|'wail'|'sob' :
;

VerbRule(DryOffWith)
    'dry' ('off'|) singleDobj ('with'|'using'|'on') singleIobj |
    'wipe' ('down'|) singleDobj ('with'|'using'|'on') singleIobj |
    ('wipe'|'soak'|'dry') ('up'|) singleDobj ('with'|'using'|'on') singleIobj |
    'dry' singleDobj ('off'|) ('with'|'using'|'on') singleIobj |
    'wipe' singleDobj ('down'|) ('with'|'using'|'on') singleIobj |
    ('wipe'|'soak'|'dry') singleDobj ('up'|) ('with'|'using'|'on') singleIobj
    : VerbProduction
    action = DryOffWith
    verbPhrase = 'dry/drying off (what) (with what)'
    missingQ = 'what do you want to dry off; what do you want to dry it off with'
;

DefineTIAction(DryOffWith)
    resolveIobjFirst = nil
    allowAll = nil
;

VerbRule(DrySelfWith)
    ('dry' 'off'|'wipe' 'down') ('with'|'using'|'on') singleDobj
    : VerbProduction
    action = DrySelfWith
    verbPhrase = 'dry/drying off (with what)'
    missingQ = 'what do you want to dry it off with'
;

DefineTAction(DrySelfWith)
    allowAll = nil
    execAction(cmd) {
        doNested(DryOffWith, gActor, gDobj);
    }
;

modify Thing {
    canDryWithMe = nil
    canDryMe = nil
    dryVerb = '{aac} dr{ies/ied} {the dobj} off'

    cannotDryWithMeMsg = '{I} {cannot} dry anything with {that iobj}. '
    cannotDryMeMsg = '{The subj dobj} does not need drying. '

    iobjFor(DryOffWith) {
        preCond = [touchObj]
        verify() {
            if (!canDryWithMe) {
                illogical(cannotDryWithMeMsg);
            }
            verifyDobjTake();
        }
        report() {
            if (gDobj == gActor) {
                "{I} dr{ies/ied} {myself} off with {the iobj}. ";
            }
            else {
                "{I}<<gDobj.dryVerb>> with {the iobj}. ";
            }
        }
    }

    dobjFor(DrySelfWith) asIobjFor(DryOffWith)

    dobjFor(DryOffWith) {
        preCond = [touchObj]
        verify() {
            if (!canDryMe) {
                illogicalNow(cannotDryMeMsg);
            }
        }
    }
}

modify Actor {
    cannotDryMeMsg = '{The subj dobj} {am} already dry. '

    canDryMe = (wetness > 0)

    dobjFor(DryOffWith) {
        verify() {
            if (gActor != self) {
                illogical('{The subj dobj} would not appreciate that. ');
            }
            inherited();
        }
        action() {
            dryOff();
        }
    }
}

deliveryRoom: Room { 'The Delivery Room'
    "<<first time>><<happyBirthdayPlayer()>>\b<<only>>
    The ceiling tiles have been removed here, to make the room taller. On the west
    wall, three artificial wombs hang on suspended metal frames. Each has dark
    cables running into them from an opening in the northwest corner of the ceiling.
    In the southwest corner, a towel rack, makeup vanity, and wardrobe closet
    have been provided for newborns. "

    northMuffle = library
    northwestMuffle = serverRoomBottom
    westMuffle = breakroom
    southMuffle = southHall

    ceilingObj = industrialCeiling

    happyBirthdayPlayer() {
        if (gCatMode) return '';
        local openingLine =
            '<.p><b>Happy birthday!</b>
            <i>{I} {am} drenched in a mix of embryonic slime and water!</i>';
        if (huntCore.difficulty == hardMode || huntCore.difficulty == nightmareMode) {
            return openingLine;
        }
        return '<<openingLine>>\b
            {I} cough, but it transforms into vomiting, and most of it lands on
            {my} own body. {I} seem to be cradled in some kind of large,
            rubbery fishnet mesh,
            likely{dummy} designed to catch newborns like {me}.\b
            Human newborns are tiny, and cry when entering the world.
            Clone newborns seem to arrive fully-grown&mdash;if
            {my} factory-standard memories are
            reliable in that regard&mdash;and so far {i} have been a bit too
            delirious to do much of anything.';
    }

    ceilingFog =
        'A <<freezer.coldSynonyms>> <<one of>>mist<<or>>fog<<at random>>
        <<one of>>falls gently<<or>>rolls faintly<<or>>wisps<<at random>>
        <<one of>>down from<<or>>out from<<or>>from<<at random>> between the
        <<one of>>many<<or>>large<<or>>eerie<<or>>dark<<at random>>
        <<one of>>cables<<or>>cords<<at random>><<one of
        >>, which hang from the ceiling<<or>>, hanging
        from the ceiling<<at random>>. '

    wombAmbience =
        '<<one of>>One of the wombs seems to <<one of>>twitch<<or>>quiver<<at random>>
        slightly<<or>>The sounds of wet dripping echo through the room<<or
        >>One of the wombs can be heard, quietly digesting something<<at random>>. '

    roomDaemon() {
        checkRoomDaemonTurns;
        "<<one of>><<or>><<ceilingFog>><<or>><<wombAmbience>><<at random>>";
        inherited();
    }

    mapModeDirections = [&east]
    familiar = roomsFamiliarByDefault
    roomNavigationType = escapeRoom
}

+deliveryRoomFog: ColdFog;

+artificialWombs: Fixture { 'artificial[weak] wombs;grow birthing iron;tanks'
    "The northwest, west, and southwest wombs hang distended from the wall,
    making that entire side of the room look like a bloody, fleshy,
    biomechanical nightmare. "

    matchPhrases = ['wombs', 'tanks']

    plural = true
    canRunAcrossMe = true
    hasParkourRecon = true

    getParkourProvider(fromParent, fromChild) {
        return self;
    }

    dobjFor(Feel) {
        preCond = nil
        remap = northwestWomb
    }

    dobjFor(Smell) {
        preCond = nil
        remap = northwestWomb
    }

    dobjFor(Taste) {
        preCond = nil
        remap = northwestWomb
    }

    dobjFor(Search) {
        preCond = nil
        remap = northwestWomb
    }

    dobjFor(Board) {
        remap = southwestWomb.parkourModule
    }

    dobjFor(GetOff) {
        remap = northwestWomb.parkourModule
    }

    dobjFor(ParkourJumpOffOf) {
        remap = northwestWomb.parkourModule
    }

    dobjFor(JumpOff) {
        remap = northwestWomb.parkourModule
    }

    dobjFor(LookIn) {
        remap = northwestWomb.remapIn
    }

    dobjFor(LookUnder) {
        remap = northwestWomb.remapUnder
    }

    contType = On

    isLikelyContainer() {
        return true;
    }
}

+Stool {
    homeDesc = "The stool sits in front of the makeup vanity,
        giving a nice viewing angle to the mirror. "
    homePhrase = 'in front of the makeup vanity'
}

+dresser: Wardrobe;
++AwkwardFloorHeight;

+makeupVanity: FixedPlatform { 'makeup vanity;;table'
    "A small table with a mirror attached to it; perfect for applying one's
    makeup (or generally correcting one's appearance).
    It sits between the towel rack and wardrobe closet.<<gPlayerChar.ponderVanity()>>"
}
++LowFloorHeight;
++ClimbUpLink ->deliveryRoomTowelRack;
++ClimbUpLink ->dresser;
#ifdef __DEBUG
++SmashedMirror;
#else
++SmashedMirror;
#endif

+deliveryRoomTowelRack: FixedPlatform { 'towel rack;;shelves'
    "A rough set of metal shelves, repurposed for holding towels.
    It sits between the makeup vanity and the southwest artificial womb. "
    ambiguouslyPlural = true

    contType = On

    canBonusReachDuring(obj, action) {
        if (action.ofKind(RunAcross)) {
            return obj == artificialWombs || obj == southwestWomb;
        }
        if (action.ofKind(Take) || action.ofKind(DryOffWith) || action.ofKind(DrySelfWith)) {
            return obj == deliveryRoom || obj == makeupVanity;
        }
        return nil;
    }

    doParkourSearch() {
        if (gActor.isIn(northwestWomb.remapOn)) {
            artificialWombs.doRecon();
        }
        inherited();
    }
}
++AwkwardFloorHeight;
++ProviderLink @artificialWombs ->northwestWomb;
++ClimbOverPath ->southwestWomb;
++Thing { 'towel;shower;rag'
    "Plain, white towels, like what someone might find in a shower room. "
    ambiguouslyPlural = true
    canDryWithMe = true
    bulk = 0
    isListed = nil

    dobjFor(Take) {
        action() {
            if (gActorIsPrey) {
                doInstead(DrySelfWith, self);
            }
        }
    }
    iobjFor(DryOffWith) {
        report() {
            if (gActorIsCat) {
                "{I} try to get a hold, but {my} claw get stuck.
                After a moment of panic, {i} {am} free again. ";
            }
            else {
                inherited();
                "\b({I} also return{s/ed} the towel to the rack.) ";
            }
        }
    }
}

#define createUniqueArtificialWomb(objectName, vocab) \
    +objectName: ArtificialWomb { vocab \
        doAccident(actor, traveler, path) { \
            if (gCatMode) { \
                "<.p>{I} run across the wombs, careful to not stay on each one \
                for too long. Upon reaching the northwest one, {i} dig {my} claws \
                into the thick insulation of the cables, and put half of {my} \
                bodyweight on them for support. The womb frame below {my} \
                back legs gradually halts its infuriating jostling. "; \
            } \
            else { \
                "<.p>{I} arrive on the northwest womb, and hold onto the \
                nearby cables for stability, as they're the closest thing \
                in reach. "; \
            } \
        } \
        remapOn: WombRemapOn { } \
        remapIn: WombRemapIn { } \
        remapUnder: WombRemapUnder { } \
    } \
    ++DangerousFloorHeight; \
    ++ClimbOverPath ->westWomb;

#define createSimpleArtificialWomb(objectName, vocab) \
    +objectName: ArtificialWomb { vocab \
        doAccident(actor, traveler, path) { \
            traveler.moveInto(deliveryRoom); \
            if (gCatMode) { \
                "<.p>{I} tentatively step onto the frame of <<theName>>, \
                but its springy design causes it to bounce slightly in \
                response. The instability hurts {my} joints too much to \
                remain, so {i} elect to hop down to the safety of the \
                floor below."; \
            } \
            else { \
                traveler.addExhaustion(1); \
                "<.p>{I} take a step onto the frame of <<theName>>, and its \
                springy design{dummy} causes {me} to lose {my} balance. \
                {I} land hard on the floor."; \
            } \
            "\b<i>{I} might need to cross the wombs with more speed. \
            The cables above the northwest womb looks like a source of \
            stability...</i> "; \
        } \
        remapOn: WombRemapOn { } \
        remapIn: WombRemapIn { } \
        remapUnder: WombRemapUnder { } \
    } \
    ++DangerousFloorHeight;

#define createArtificialWomb(complexity, objectName, vocab) \
    create##complexity##ArtificialWomb(objectName, vocab)

// Disrupts the player's ability to specify which component
#define expandComponentVocab(nounSection, adjSection, altSection) \
    nounSection + ';northwest nw west w southwest sw artificial[weak] womb\'s tank\'s ' + adjSection + ';' + altSection

createArtificialWomb(Unique, northwestWomb, 'northwest artificial[weak] womb;nw grow birthing iron;tank')
createArtificialWomb(Simple, westWomb, 'west artificial[weak] womb;w grow birthing iron;tank')
createArtificialWomb(Simple, southwestWomb, 'southwest artificial[weak] womb;sw grow birthing iron;tank')

+genericCatchNet: Fixture {
    vocab = expandComponentVocab('catch net', 'catcher\'s catchers', 'fishnet fish[weak] net basket catcher')
    desc = "A large, rubbery, fishnet-like mesh, put in place
    to gently catch newborn clones. It sits above a trough drain in the floor."
    contType = In

    isEnterable = true

    dobjFor(ParkourClimbOffOf) asDobjFor(GetOutOf)
    dobjFor(GetOutOf) {
        action() {
            if (gActorIsPrey) {
                prey.hasLeftTheNet = true;
                if (prey.wetness > 0) {
                    wombFluidTraces.moveInto(deliveryRoom);
                }
            }
            inherited();
        }
        report() {
            inherited();
            if (gActorIsPrey && prey.wetness > 0) {
                "\b{My} soaked form rains strings and droplets of fluid
                across the floor. ";
            }
        }
    }

    dobjFor(ParkourClimbGeneric) asDobjFor(Enter)
    dobjFor(ParkourClimbOverInto) asDobjFor(Enter)
    dobjFor(Enter) {
        verify() {
            if (gActorIsPrey) {
                if (prey.hasLeftTheNet) {
                    illogical('It\'s too late;
                        {i} have already chosen adulthood! ');
                }
            }
            else if (gActorIsCat) {
                illogical('{I} might slip through, and land in the
                    trough of goo underneath. ');
            }
            inherited();
        }
    }

    iobjFor(PutIn) {
        verify() {
            illogical('That is meant to catch human-sized bodies,
                and nothing else. ');
        }
    }

    dobjFor(LookUnder) {
        verify() { }
        check() { }
        action() {
            doInstead(Examine, genericTroughDrain);
        }
        report() { }
    }
}

+Decoration {
    vocab = expandComponentVocab('substrate', 'womb fleshy', 'parts[weak]')
    desc = "Closer to the metal of the frame, the substrate is a solid, pink mass.
    As {i} look closer to the womb (in the heart of the frame), the pink deepens to red,
    as it transitions to bubbly, and then to stringy and veiny. "

    isLikelyContainer() {
        return true;
    }
}

+Decoration {
    vocab = expandComponentVocab('frame', 'springy metal half[weak]', 'half-pipe pipe[weak] nanomaterial springs joints')
    desc = "A sheet metal with a thick layer of nanomaterial. It conforms to a semicircle
    curve, with the nanomaterial on the inside, which the biological part of the womb
    fuses to.\b
    The whole sheet is suspended from the ground by a complex system of springs and joints. "

    isLikelyContainer() {
        return true;
    }
}

+genericTroughDrain: Decoration {
    vocab = expandComponentVocab('drain', 'trough grated', 'trough grate')
    desc = "A grated drain divides the floor, like a dark line under the wombs.
    When embryonic fluid falls out, it passes through the net, and is collected in the
    drain. "
}

deliveryRoomCableHole: Decoration { 'opening;extra[weak] in[prep] the ceiling[n];hole hatch gap space[weak]'
    "There is a wide opening or hatch in the ceiling, above the northwest artificial womb.
    From it, data cables spill out.\b
    {I} notice some extra space around the cables, as if there
    are too few of them being threaded through. This also explains the cold air
    spilling out from the room beyond. "
    location = northwestWomb
    subLocation = &remapOn

    notImportantMsg = 'The opening is on the ceiling, and is too far away to safely reach. '
}

deliveryRoomCables: ClimbUpPlatform { 'cables;server black dark insulated data three[weak] hanging[weak] from[prep] ceiling[n];bundles[weak] wires cords connections'
    "Thick, dark, data cables, spilling out from an opening in the ceiling,
    above the northwest artificial womb. They split off into three bundles, each going
    into one of the three wombs on the west wall. "
    location = northwestWomb
    subLocation = &remapOn
    secretLocalPlatform = true
    plural = true

    destination = serverRoomTop
    oppositeLocalPlatform = dataCableServerExit

    dobjFor(SqueezeThrough) asDobjFor(TravelVia)
}

wombFluidTraces: Decoration { 'puddle;wet water;droplet string fluid'
    "{I} seem to have left a wet trace of {myself} here.<<if gPlayerChar.wetness > 0
    >> {I} might want to dry off, before attempting to run or hide.<<end>> "
    ambiguouslyPlural = true
    isListed = true
    canDryMe = true
    dryVerb = '{aac} soak{s/ed} up {the dobj}'

    decorationActions = [Examine, DryOffWith]

    dobjFor(DryOffWith) {
        action() {
            moveInto(nil);
        }
    }

    specialDesc = "Traces and puddles of embryonic fluid coat the floor
        in front of the northwest artificial womb. "
}

DefineDoorEastTo(southeastHall, deliveryRoom, 'the Delivery Room door')