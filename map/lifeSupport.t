lifeSupportTop: Room { 'Life Support (Upper Level)'
    "TODO: Add description. "

    southwest = northUtilityPassageEntry
    down = lifeSupportBottom

    northwestMuffle = assemblyShop
    eastMuffle = labA
    westMuffle = commonRoom
    southeastMuffle = itOffice
    southMuffle = serverRoomBottom
}

lifeSupportBottom: Room { 'Life Support (Lower Level)'
    "TODO: Add description. "

    up = lifeSupportTop
}