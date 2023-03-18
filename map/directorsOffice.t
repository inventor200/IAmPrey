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

//TODO: Broken shards multiloc here and in the north hall, explaining that
// the shards are nowhere to be found

//TODO: Add cat bed

DefineBrokenWindowPairLookingAway(north, southwest, northHall, directorsOffice)
    vocab = 'broken director\'s office window;directors[weak] shattered'
    desc = "TODO: Add description. "
    travelDesc = "{I} carefully climb{s/ed} through the broken window,
    wary of any lingering shards. "
    breakMsg = 'The window is already broken. '
    remoteHeader = 'through the broken window'
;

DefineDoorSouthTo(administration, directorsOffice, 'the director\'s office door')