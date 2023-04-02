class FilingCabinet: BaseCabinet {
    cabinetSubclass = 'filing'
    adjectivesFromItems = 'paper papers '
}

DefineDistSubComponentFor(TopFilingCabinetDrawer, FilingCabinet, topDrawer)
    vocab = 'top drawer;upper first'
    desc = "A metal drawer of a filing cabinet. "
    nameAs(parent) {
        name = 'top drawer';
    }
    CabinetDrawerProperties
    maxSingleBulk = 1
;

DefineDistSubComponentFor(MiddleFilingCabinetDrawer, FilingCabinet, middleDrawer)
    vocab = 'middle drawer;mid second center'
    desc = "A metal drawer of a filing cabinet. "
    nameAs(parent) {
        name = 'middle drawer';
    }
    CabinetDrawerProperties
    maxSingleBulk = 1
;

DefineDistSubComponentFor(BottomFilingCabinetDrawer, FilingCabinet, bottomDrawer)
    vocab = 'bottom drawer;lower lowest third'
    desc = "A metal drawer of a filing cabinet. "
    nameAs(parent) {
        name = 'bottom drawer';
    }
    CabinetDrawerProperties
    maxSingleBulk = 1
;