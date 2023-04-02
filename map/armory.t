armory: Room { 'The Armory'
    "This must be where the weapons are stored...\b
    ...well, the weapons <i>would</i> be stored on the weapon
    racks, but <<gSkashekName>> has taken them all.\b
    There are some metal shelves, a storage locker,
    and a storage cabinet on the east wall, across from the racks.\b
    To the <<hyperDir('north')>> is the Security Office. "

    north = securityOffice
    
    eastMuffle = westHall

    mapModeDirections = [&north, &south]
    familiar = roomsFamiliarByDefault
}
+WeaponRack;
+armoryShelves: MetalShelves;
++AwkwardFloorHeight;
+armoryLocker: StorageLocker;
++AwkwardFloorHeight;
+armoryCabinet: StorageCabinet;
++AwkwardFloorHeight;

DefineDoorSouthTo(humanQuarters, armory, 'the Armory door')