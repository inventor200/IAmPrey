class StorageCabinet: BaseCabinet {
    cabinetSubclass = 'wide storage'
    cabinetSubclassInDesc = 'storage'
    adjectivesFromItems = 'cargo '
}

DefineDistSubComponentFor(TopStorageCabinetDrawer, StorageCabinet, topDrawer)
    vocab = 'top drawer;upper first'
    desc = "A metal drawer of a filing cabinet. "
    nameAs(parent) {
        name = 'top drawer';
    }
    CabinetDrawerProperties
    maxSingleBulk = 4
;

DefineDistSubComponentFor(MiddleStorageCabinetDrawer, StorageCabinet, middleDrawer)
    vocab = 'middle drawer;mid second center'
    desc = "A metal drawer of a filing cabinet. "
    nameAs(parent) {
        name = 'middle drawer';
    }
    CabinetDrawerProperties
    maxSingleBulk = 4
;

DefineDistSubComponentFor(BottomStorageCabinetDrawer, StorageCabinet, bottomDrawer)
    vocab = 'bottom drawer;lower lowest third'
    desc = "A metal drawer of a filing cabinet. "
    nameAs(parent) {
        name = 'bottom drawer';
    }
    CabinetDrawerProperties
    maxSingleBulk = 4
;