class StorageChest: CargoBooth {
    vocab = 'large storage chest;communal metal'
    desc = "A large, rectangular chest. It can open and close, and store a
    large number of items. A person could probably fit inside, too, but they
    would not be unable to see the room outside. "
}

DefineDistSubComponentFor(StorageChestRemapIn, StorageChest, remapIn)
    isOpenable = true
    isEnterable = true
    canHearOut = true
    //isLit = true
    litWithin() { return true; }
    roomTitle = 'Inside of <<theName>>'
    interiorDesc = "<<if gCatMode
    >>The inside of <<lexicalParent.theName>> is rather cozy!<<else
    >>The inside of <<lexicalParent.theName>> is claustrophobic,
    and {i} cannot see the rest of <<getOutermostRoom().roomTitle>> from
    in here.<<end>> "
    betterStorageHeader
;

class StorageCloset: StorageChest {
    vocab = 'supply closet;tall storage supplies'
    desc = "A tall storage closet. It can open and close, and store a
    large number of items. A person could probably fit inside, too, but they
    would not be unable to see the room outside. "
}