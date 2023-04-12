class MetalShelves: FakePlural, FixedPlatform {
    vocab = 'storage shelves;cargo' + adjectivesFromItems + ' one[weak] of[prep];rack shelf'
    desc = "Rough, metal shelves for storing various items. "
    fakeSingularPhrase = 'shelf'

    adjectivesFromItems = ''
}

class WeaponRack: FakePlural, Fixture {
    vocab = 'weapon racks[weak];weapons[weak] storage one[weak] of[prep];rack[weak] shelf[weak] storage shelves[weak] slot slots'
    desc = "Rough, metal slots for storing firearms. "
    fakeSingularPhrase = 'weapon storage slot'
    contType = In
    isLikelyContainer() {
        return true;
    }

    matchPhrases = ['weapon', 'weapons']
}