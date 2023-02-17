serverRoomBottom: Room { 'Server Access'
    "TODO: Add description. "

    up = serverRoomTop
    east = itOffice
}

DefineDoorWestTo(utilityPassage, serverRoomBottom, 'the server access door')

serverRoomTop: Room { 'The Chilled Server Room'
    "TODO: Add description. "

    down = serverRoomBottom
}