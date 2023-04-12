class Chair: HomeHaver, Platform {
    vocab = 'chair;;stool seat'
    simplestDescMsg = 'A simple chair. '
    homeDesc = "<<simplestDescMsg>>It rests <<homePhrase>>. "
    basicDesc = "<<simplestDescMsg>>"
    bulk = 2
    canSitOnMe = true
    homePhrase = 'on the floor'
    backHomeMsg =
        '{I} {put} {the dobj} back <<homePhrase>>, where it belongs. '

    dobjFor(SitIn) asDobjFor(SitOn)
}

class Stool: Chair {
    vocab = 'stool;;chair seat'
    simplestDescMsg = 'A simple stool. '
}

class PluralChair: FakePlural, Platform {
    vocab = 'chairs;one[weak] of[prep];stools seats chair stool seat'
    desc = "A collection of chairs, each made to factory standard. "
    fakeSingularPhrase = 'chair'
    isTakeable = nil
    bulk = 2
    canSitOnMe = true

    cannotTakeMsg = 'There are too many to choose, and {i} cannot take them all. '
}

class PluralStool: PluralChair {
    vocab = 'stools;one[weak] of[prep];chairs seats chair stool seat'
    desc = "A collection of stools, each made to factory standard. "
    fakeSingularPhrase = 'stool'
}