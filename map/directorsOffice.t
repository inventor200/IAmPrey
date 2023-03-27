directorsOffice: Room { 'The Director\'s Office'
    "TODO: Add description.\b
    An exit door is to the <<hyperDir('south')>>, and a broken window
    opens a way to the <<hyperDir('north')>>. "

    eastMuffle = assemblyShop
    southeastMuffle = commonRoom
    westMuffle = northwestHall

    regions = [directorsOfficeSightLine]

    inRoomName(pov) { return 'in the office, seen through the window'; }

    descFrom(pov) {
        "TODO: Add remote description. ";
    }

    mapModeDirections = [&north, &south]
    familiar = roomsFamiliarByDefault
}

+brokenGlass: Unthing { 'broken glass;shattered smashed;shards'
    'The window might be smashed, but the shards have been cleaned up. '
    ambiguouslyPlural = true
}

//TODO: Add cat bed

DefineBrokenWindowPairLookingAway(north, south, northwestishHall, directorsOffice)
    vocab = 'broken director\'s office window;directors[weak] shattered'
    desc = "TODO: Add description. "
    travelDesc = "{I} carefully climb{s/ed} through the broken window,
    wary of any lingering shards. "
    breakMsg = 'The window is already broken. '
    remoteHeader = 'through the broken window'
;

DefineDoorSouthTo(administration, directorsOffice, 'the Director\'s Office door')