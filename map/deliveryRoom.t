class WombComponent: Decoration {
    isOwnerNamed = (!owner.isUniqueWomb)
    filterResolveList(np, cmd, mode) {
        if (np.matches.length <= 1) return;

        if (!owner.isUniqueWomb) {
            np.matches = np.matches.subset({m: m.obj != self});
        }
    }
}

class ArtificialWomb: Fixture {
    desc = "TODO: Add description. "
    isUniqueWomb = nil

    matchPhrases = ['womb', 'tank']

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
            shouldTruncate = !isUniqueWomb;
        }

        if (shouldTruncate) {
            np.matches = np.matches.subset({m: m.obj != self});
        }
    }

    contType = On

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

modify VerbRule(Yell)
    'yell'|'scream'|'shout'|'holler'|'cry'|'wail'|'sob' :
;

deliveryRoom: Room { 'The Delivery Room'
    "<<first time>><<happyBirthdayPlayer()>>\b<<only>>
    TODO: Add description. "

    northMuffle = itOffice
    northwestMuffle = serverRoomBottom
    westMuffle = breakroom
    southMuffle = southHall

    happyBirthdayPlayer() { //TODO: Implement catcher's net, and hasLeftTheNet
        if (gPlayerChar == cat) return '';
        local openingLine =
            '<b>Happy birthday!</b>
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
        slightly.<<or>>The sounds of wet dripping echo through the room.<<or
        >>One of the wombs can be heard, quietly digesting something.<<at random>>. '

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

    contType = On

    isLikelyContainer() {
        return true;
    }
}

+Chair { 'stool'
    "A simple stool. "
    chairDesc = "The stool sits in front of the makeup vanity,
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
++/*Smashed*/Mirror;

+deliveryRoomTowelRack: FixedPlatform { 'towel rack;;shelves'
    "A rough set of metal shelves, repurposed for holding towels.
    It sits between the makeup vanity and the southwest artificial womb. "
    ambiguouslyPlural = true

    canBonusReachDuring(obj, action) {
        if (action.ofKind(RunAcross)) {
            return obj == artificialWombs || obj == southwestWomb;
        }
        return nil;
    }
}
++AwkwardFloorHeight;
++AwkwardProviderLink @artificialWombs ->northwestWomb;
++ClimbOverPath ->southwestWomb;

#define createUniqueArtificialWomb(objectName, vocab) \
    +objectName: ArtificialWomb { vocab \
        isUniqueWomb = true \
        isBoardable = true \
        holdsActors \
        doAccident(actor, traveler, path) { \
            "<.p>{I} arrive{s/d} on the northwest womb, and hold onto the \
            nearby cables for stability, as they're the closest thing \
            in reach. "; \
        } \
    } \
    ++DangerousFloorHeight; \
    ++ClimbOverPath ->westWomb;

#define createSimpleArtificialWomb(objectName, vocab) \
    +objectName: ArtificialWomb { vocab \
        doAccident(actor, traveler, path) { \
            traveler.moveInto(deliveryRoom); \
            "{I} {take} a step onto the frame of <<theName>>, and its \
            springy design{dummy} causes {me} to lose {my} balance, and \
            {i} land{s/ed} hard on the floor.\b \
            <i>{I} might need more speed...</i>"; \
        } \
    } \
    ++DangerousFloorHeight;

#define createArtificialWomb(complexity, objectName, vocab) \
    create##complexity##ArtificialWomb(objectName, vocab) \
    +WombComponent { 'component' \
        owner = objectName \
    }

createArtificialWomb(Unique, northwestWomb, 'northwest[weak] artificial[weak] womb;nw[weak] grow birthing iron;tank')
createArtificialWomb(Simple, westWomb, 'west[weak] artificial[weak] womb;w[weak] grow birthing iron;tank')
createArtificialWomb(Simple, southwestWomb, 'southwest[weak] artificial[weak] womb;sw[weak] grow birthing iron;tank')

//TODO: Data bundles parkour exit to upper server room

DefineDoorEastTo(southeastHall, deliveryRoom, 'the delivery room door')