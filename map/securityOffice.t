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
++ClimbUpLink -> StorageCabinet;
++ClimbUpLink -> StorageCloset;
++ClimbUpLink -> StorageLocker;
+securityCabinet: StorageCabinet;
++AwkwardFloorHeight;
+securityCloset: StorageCloset;
++AwkwardFloorHeight;
++ClimbOverLink -> StorageCabinet;
++ClimbOverLink -> StorageLocker;
+securityLocker: StorageLocker;
++AwkwardFloorHeight;

DefineDoorEastTo(northwestHall, securityOffice, 'the Security Office door')