class GameSong: object {
    songURL = ''
    fadein = nil
    fadeout = nil
    allowAmbience = true
}

class GameAmbience: object {
    sfxURL = ''
    volume = 75

    // How much will the ambience silence foreground sounds?
    drownOutFactor = 0

    getDrownedVolume(soundObj) {
        local floatVol = new BigNumber(soundObj.volume);
        local one = new BigNumber(1);
        local cent = new BigNumber(100);
        local floatDrownOut =
            (new BigNumber(drownOutFactor) / cent)
            - (new BigNumber(soundObj.antiDrowningFactor) / cent);
        local mult = one - floatDrownOut;
        if (mult < 0) mult = 0;
        if (mult > 1) mult = one;
        local finalVol = floatVol * mult;
        return toInteger(finalVol);
    }
}

class GameSFX: object {
    sfxURL = ''
    volume = 100

    // How resistant is this sound to dampening?
    antiDrowningFactor = 0
    allowInterrupt = true
    stackingPriority = 0
}

class DecorativeSFX: GameSFX {
    probability = 10
    volume = 75
}