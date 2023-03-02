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

deliveryRoom: Room { 'The Delivery Room'
    "TODO: Add description. "

    northMuffle = itOffice
    northwestMuffle = serverRoomBottom
    westMuffle = breakroom
    southMuffle = southHall

    roomDaemon() {
        "A <<freezer.coldSynonyms>> <<one of>>mist<<or>>fog<<at random>>
        <<one of>>falls gently<<or>>rolls faintly<<or>>wisps<<at random>>
        <<one of>>down from<<or>>out from<<or>>from<<at random>> between the
        <<one of>>many<<or>>large<<or>>eerie<<or>>dark<<at random>>
        <<one of>>cables<<or>>cords<<at random>><<one of
        >>, which hang from the ceiling<<or>>, hanging
        from the ceiling<<at random>>.<<one of>><<or>>\b
        One of the wombs seems to <<one of>>twitch<<or>>quiver<<at random>>
        slightly.<<or>>\bThe sounds of wet dripping echo through the room.<<or
        >>\bOne of the wombs can be heard, quietly digesting something.<<at random>> ";
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
++Mirror;

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
    /*++AwkwardProviderLink @artificialWombs ->deliveryRoomTowelRack;*/ \
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