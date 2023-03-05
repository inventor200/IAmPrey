class ArtificialWomb: Fixture {
    desc = "TODO: Add description. "
    isBoardable = true

    matchPhrases = ['womb', 'tank']

    catchNet = nil

    filterResolveList(np, cmd, mode) {
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
}

class WombRemapUnder: SubComponent {
    fakeContents = [genericCatchNet]
}

class WombRemapOn: SubComponent {
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
    TODO: Add description. "

    northMuffle = itOffice
    northwestMuffle = serverRoomBottom
    westMuffle = breakroom
    southMuffle = southHall

    happyBirthdayPlayer() { //TODO: Implement catcher's net, and hasLeftTheNet
        if (gCatMode) return '';
        local openingLine =
            '<.p><b>Happy birthday!</b>
            <i>You are drenched in a mix of embryonic slime and water!</i>';
        if (huntCore.difficulty == hardMode || huntCore.difficulty == nightmareMode) {
            return openingLine;
        }
        return '<<openingLine>>\b
            You cough, but it transforms into vomiting, and most of it lands on
            your own body. You seem to be cradled in some kind of large,
            rubbery fishnet mesh, likely designed to catch newborns like you.\b
            Human newborns are tiny, and cry when entering the world. Clone
            newborns seem to be tall&mdash;if your factory-standard memories are
            reliable in that regard&mdash;and so far you have been a bit too
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
        "<<one of>><<or>><<ceilingFog>><<or>><<wombAmbience>><<at random>>";
        inherited();
    }
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

+Chair { 'stool;;chair seat'
    "A simple stool. "
    homeDesc = "The stool sits in front of the makeup vanity,
        giving a nice viewing angle to the mirror. "
    backHomeMsg =
        '{I} {put} {the dobj} back in front of the makeup vanity, where it belongs. '
}

+makeupVanity: FixedPlatform { 'makeup vanity;;table'
    "A small table with a mirror attached to it; perfect for applying one's
    makeup (or generally correcting one's appearance).<<gPlayerChar.ponderVanity()>>"
}
++LowFloorHeight;
++ClimbUpLink ->deliveryRoomTowelRack;
#if __DEBUG
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
}
++AwkwardFloorHeight;
++AwkwardProviderLink @artificialWombs ->northwestWomb;
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
                "You try to get a hold, but your claw get stuck.
                After a moment of panic, you are free again. ";
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
                "<.p>You run across the wombs, careful to not stay on each one \
                for too long. Upon reaching the northwest one, you dig your claws \
                into the thick insulation of the cables, and put half of your \
                bodyweight on them for support. The womb frame below your \
                back legs gradually halts its infuriating jostling. "; \
            } \
            else { \
                "<.p>You arrive on the northwest womb, and hold onto the \
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
                "<.p>You tentatively step onto the frame of <<theName>>, \
                but its springy design causes it to bounce slightly in \
                response. The instability hurts your joints too much to \
                remain, so you elect to hop down to the safety of the \
                floor below."; \
            } \
            else { \
                traveler.addExhaustion(1); \
                "<.p>You take a step onto the frame of <<theName>>, and its \
                springy design causes you to lose your balance, and \
                you land hard on the floor."; \
            } \
            "\b<i>You might need to cross the wombs with more speed. \
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
    nounSection + ';northwest[weak] nw[weak] west[weak] w[weak] southwest[weak] sw[weak] artificial[weak] womb\'s tank\'s ' + adjSection + ';' + altSection

createArtificialWomb(Unique, northwestWomb, 'northwest[weak] artificial[weak] womb;nw[weak] grow birthing iron;tank')
createArtificialWomb(Simple, westWomb, 'west[weak] artificial[weak] womb;w[weak] grow birthing iron;tank')
createArtificialWomb(Simple, southwestWomb, 'southwest[weak] artificial[weak] womb;sw[weak] grow birthing iron;tank')

+genericCatchNet: Fixture {
    vocab = expandComponentVocab('catch net', 'catcher\'s catchers', 'fishnet fish[weak] net basket catcher')
    desc = "A large, rubbery, fishnet-like mesh, put in place
        to gently catch newborn clones. "
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
                "\bYour soaked form rains strings and droplets of fluid
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
                        you have already chosen adulthood! ');
                }
            }
            else if (gActorIsCat) {
                illogical('You might slip through, and land in the
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
}

+deliveryRoomCableHole: Decoration { 'opening;extra[weak] in[prep] the ceiling[n];hole hatch gap space[weak]'
    "There is an opening or hatch in the ceiling, above the northwest artificial womb.
    From it, data cables spill out.\b
    You notice some extra space around the cables, as if there
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
}

wombFluidTraces: Decoration { 'puddle;wet water;droplet string fluid'
    "You seem to have left a wet trace of yourself here.<<if gPlayerChar.wetness > 0
    >> You might want to dry off, before attempting to run or hide.<<end>> "
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

//TODO: Data bundles parkour exit to upper server room

DefineDoorEastTo(southeastHall, deliveryRoom, 'the delivery room door')