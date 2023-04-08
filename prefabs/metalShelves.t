class MetalShelves: FixedPlatform {
    vocab = 'storage shelves;cargo' + adjectivesFromItems + ';rack shelf'
    desc = "Rough, metal shelves for storing various items. "
    plural = true

    adjectivesFromItems = ''
}

class WeaponRack: Fixture {
    vocab = 'weapon racks[weak];weapons[weak] storage;rack[weak] shelf[weak] storage shelves[weak] slot slots'
    desc = "Rough, metal slots for storing firearms. "
    plural = true
    contType = In
    isLikelyContainer() {
        return true;
    }

    matchPhrases = ['weapon', 'weapons']
}