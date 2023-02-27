utilityPassage: Room { 'The Utility Corridor'
    "TODO: Add description. "

    northeast = northUtilityPassageExit
    south = southUtilityPassageExit

    northwestMuffle = enrichmentRoom
    southeastMuffle = breakroom
    westMuffle = cloneQuarters
}

+southUtilityPassageExit: MaintenanceDoor { 'the south-end exit door'
    desc = lockedDoorDescription
    otherSide = southUtilityPassageEntry
    soundSourceRepresentative = southUtilityPassageEntry
}

+northUtilityPassageExit: MaintenanceDoor { 'the door to[weak] life support'
    desc = lockedDoorDescription
    otherSide = northUtilityPassageEntry
}

southUtilityPassageEntry: MaintenanceDoor { 'the south-end access door' @southHall
    desc = lockedDoorDescription
    otherSide = southUtilityPassageExit
}

northUtilityPassageEntry: MaintenanceDoor { 'the exit door' @lifeSupportTop
    desc = lockedDoorDescription
    otherSide = northUtilityPassageExit
    soundSourceRepresentative = northUtilityPassageExit
}