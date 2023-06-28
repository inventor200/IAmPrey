freeAction() {
    if (gFormatForScreenReader) return 'free action';
    return '<b><i>FREE</i> action</b>';
}

freeActions() {
    if (gFormatForScreenReader) return 'free actions';
    return '<b><i>FREE</i> actions</b>';
}

instructionsCore: InGameBook {
    chapters = [
        newPlayerChapter,
        shorthandChapter,
        travelChapter,
        inventoryChapter,
        turnsAndUndoChapter,
        utilityCommandsChapter,
        experiencedWarningChapter,
        suitPartsChapter,
        lifeOfPreyChapter,
        parkourEvasionChapter,
        mapChapter,
        screenReaderChapter,
        missingContinueChapter,
        catModeChapter,
        autoSneakChapter,
        nightmareModeChapter,
        awarenessChapter,
        doorsChapter,
        tricksChapter,
        chasesChapter,
        exitControlChapter,
        verbsChapter
    ]

    showVerbs() {
        open();
        verbsChapter.play();
    }
}