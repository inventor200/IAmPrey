#define gSkashekName skashek.globalParamName

skashek: Actor { 'Skashek;;predator hunter royal[weak] subject sheki shek' @deliveryRoom
    "A rather terrifying visage! "
    isHim = true
    theName = (globalParamName)
    trueNameKnown = nil

    globalParamName = (gCatMode ? '<b>The Royal Subject</b>' :
        (trueNameKnown ? '<b>Skashek</b>' : '<b>The Predator</b>'))

    doPerception() {
        //TODO: Handle Skashek sound perception
    }
}

+maintenanceKey: Key { 'maintenance keycard;rfid;key chip'
    "A small, white card with thin, silvery strips.
    This must have been used by the original researchers to
    unlocked maintenance areas. "

    owner = [skashek]
}