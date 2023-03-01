class WombComponent: Decoration {
    owner = (location)
    isOwnerNamed = (!location.isUniqueWomb)
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
        >> in the ceiling<<or>>, which hang from the ceiling<<or>>, hanging
        from the ceiling<<at random>>.<<one of>><<or>>\b
        One of the wombs seems to <<one of>>twitch<<or>>quiver<<at random>>
        slightly.<<or>>\bThe sounds of wet dripping echo through the room.<<or
        >>\bOne of the wombs can be heard, quietly digesting something.<<at random>> ";
        inherited();
    }
}

+deliveryRoomFog: ColdFog;

+artificialWombs: Decoration { 'artificial[weak] wombs;grow birthing iron;tanks'
    "The northwest, west, and southwest wombs hang distended from the wall,
    making that entire side of the room look like a bloody, fleshy,
    biomechanical nightmare. "

    plural = true

    decorationActions = [Examine, RunAcross]

    specialDesc() {
        "Three artificial wombs line the west wall. ";
    }

    dobjFor(Default) {
        remap = northwestWomb
        verify() { logical; }
    }
    iobjFor(Default) {
        remap = northwestWomb
        verify() { logical; }
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
++Mirror;

+northwestWomb: ArtificialWomb { 'northwest[weak] artificial[weak] womb;nw[weak] grow birthing iron;tank'
    isUniqueWomb = true
    isBoardable = true
    holdsActors
}
++DangerousFloorHeight;
++WombComponent { 'component'
    //
}

+westWomb: ArtificialWomb { 'west[weak] artificial[weak] womb;w[weak] grow birthing iron;tank'
    isLikelyContainer() {
        return true;
    }
}
++WombComponent { 'component'
    //
}

+southwestWomb: ArtificialWomb { 'southwest[weak] artificial[weak] womb;sw[weak] grow birthing iron;tank'
    isLikelyContainer() {
        return true;
    }
}
++WombComponent { 'component'
    //
}

//TODO: Data bundles parkour exit to upper server room

DefineDoorEastTo(southeastHall, deliveryRoom, 'the delivery room door')