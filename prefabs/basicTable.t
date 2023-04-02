class FurniturePlatform: FixedPlatform {
    vocab = cabinetSubclass + ';' +
        stndAdjectivesFromItems +
        adjectivesFromItems +
        altNouns
    desc = "A <<cabinetSubclassInDesc>> with a fake wood grain surface. "

    cabinetSubclass = 'platform'
    cabinetSubclassInDesc = (cabinetSubclass)
    adjectivesFromItems = ''
    altNouns = ''
    stndAdjectivesFromItems = ''
}

class Table: FurniturePlatform {
    cabinetSubclass = 'table'
}

class CounterTop: FurniturePlatform {
    cabinetSubclass = 'counter'
    stndAdjectivesFromItems = 'counter[weak] '
    altNouns = ';top[weak] countertop'
}

class Desk: FurniturePlatform {
    cabinetSubclass = 'desk'
    stndAdjectivesFromItems = 'desk[weak] '
    altNouns = ';top[weak] desktop'
}

class PluralDesk: FurniturePlatform {
    desc = "A collection of <<cabinetSubclassInDesc>> with a fake wood grain surfaces.
    All are made to factory standard. "
    theName = 'one of the ' + cabinetSubclass
    cabinetSubclass = 'desks'
    stndAdjectivesFromItems = 'desk[weak] one[weak] of[prep] '
    altNouns = ';desk top[weak] tops[weak] desktop desktops'
    plural = true
}