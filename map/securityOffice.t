securityOffice: Room { 'The Security Office'
    "A room where the guards used to spend a lot of time<<if !gCatMode>>, probably<<end>>.\b
    The north wall is covered in busted-up security monitors,
    while the west wall is lined by a storage cabinet, closet, and locker.
    A single desk sits near the middle of the north wall, dividing the half
    with monitors from the half without.\b
    A way <<hyperDir('south')>> leads to the Armory. "

    south = armory

    mapModeDirections = [&south, &east]
    familiar = roomsFamiliarByDefault
}
+Desk;
++LowFloorHeight;
++ClimbUpLink -> securityCabinet;
++ClimbUpLink -> securityCloset;
++ClimbUpLink -> securityLocker;
+securityCabinet: StorageCabinet;
++AwkwardFloorHeight;
+securityCloset: StorageCloset;
++AwkwardFloorHeight;
++ClimbOverLink -> securityCabinet;
++ClimbOverLink -> securityLocker;
+securityLocker: StorageLocker;
++AwkwardFloorHeight;
+Decoration { 'security monitors;;monitor screens screen'
    "The security monitors seem damaged, and do not function. "
}

DefineDoorEastTo(northwestHall, securityOffice, 'the Security Office door')