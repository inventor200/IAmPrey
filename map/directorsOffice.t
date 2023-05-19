directorsOffice: Room { 'The Director\'s Office'
    "A single desk dominates the room, and a picture frame hangs on
    the east wall, above a filing cabinet and storage locker.\b
    An exit door is to the <<hyperDir('south')>>, and a broken window
    opens a way to the <<hyperDir('north')>>. "

    eastMuffle = assemblyShop
    southeastMuffle = commonRoom
    westMuffle = northwestHall

    regions = [directorsOfficeSightLine]

    inRoomName(pov) { return 'in the office, seen through the window'; }

    mapModeDirections = [&north, &south]
    familiar = roomsFamiliarByDefault
}

+directorCabinet: FilingCabinet;
++AwkwardFloorHeight;
+StorageLocker;
++AwkwardFloorHeight;
+Desk { 'director\'s desk;directors director big'
    "A grand, black desk. "
}
++catBed: Trinket { 'cat bed'
    "A fluffy, beige cat bed in the shape of a donut. "
    contType = In
    isLikelyContainer() {
        return nil;
    }
    bulk = 2
    isEnterable = (gCatMode)
    isBoardable = (gCatMode)
    canLieOnMe = (gCatMode)
    canSitOnMe = (gCatMode)
    canSitInMe = (gCatMode)
}
+Decoration { 'picture;hanging picture on[prep] wall[n];frame photo'
    "A photo of the last director this facility ever had, except...something is wrong.\b
    Someone has replaced this photo with an altered one. The director in <i>this</i>
    photo is pale as a clone, and his eyes have gouged out, with the lids stapled open,
    leaving only vacant, vigilant pits. His cheeks have also been carved up to the
    jaw hinge, so his corpse is always smiling.<<if gCatMode>>\b
    <i>Meh. {I} never liked him, anyway.</i><<end>> "
}

+brokenGlass: Unthing { 'broken glass;shattered smashed;shards shard'
    'The window might be smashed, but the shards have been cleaned up. '
    ambiguouslyPlural = true
}

DefineBrokenWindowPairLookingAway(north, south, northwestishHall, directorsOffice)
    vocab = 'broken director\'s office window;directors[weak] shattered'
    desc = "A shattered window would have given the former director a great
    view of facility staff, busily going about their task of engineering new clones. "
    travelDesc = "{I} carefully climb{s/ed} through the broken window,
    wary of any lingering shards. "
    breakMsg = 'The window is already broken. '
    remoteHeader = 'through the broken window'
;

DefineDoorSouthTo(administration, directorsOffice, 'the Director\'s Office door')