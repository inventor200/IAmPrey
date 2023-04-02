class MetalShelves: FixedPlatform {
    vocab = 'storage shelves;cargo' + adjectivesFromItems + ';rack shelf'
    desc = "Rough, metal shelves for storing various items. "
    plural = true

    adjectivesFromItems = ''
}

class WeaponRack: Fixture {
    vocab = 'weapon racks;weapons[weak] storage;rack shelf storage shelves slot slots'
    desc = "Rough, metal slots for storing firearms. "
    plural = true
    contType = In
    isLikelyContainer() {
        return true;
    }
}