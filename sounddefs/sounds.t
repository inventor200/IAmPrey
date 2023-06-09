emergeSnd: GameSFX {
    sfxURL = 'sounds/emerge.ogg'
    volume = 60
}

doorOpenSnd: GameSFX {
    sfxURL = 'sounds/dooropen.ogg'
    volume = 30
}

doorSlamShutSnd: GameSFX {
    sfxURL = 'sounds/doorslam.ogg'
    volume = 85
    stackingPriority = 50
}

doorShutCarefulSnd: GameSFX {
    sfxURL = 'sounds/doorcareful.ogg'
    volume = 25
}

doorShutSnd: DistanceSFX {
    sfxURL = 'sounds/doorclose.ogg'
    volume = 80
    stackingPriority = 28

    sourceVersion = (self)
    closeVersion = doorShutCloseSnd
    distantVersion = doorShutDistantSnd
    muffledVersion = doorShutMuffledSnd
}

doorShutMuffledSnd: DistanceSFX {
    sfxURL = 'sounds/doormuffled.ogg'
    volume = 100
    stackingPriority = 26

    sourceVersion = doorShutSnd
    closeVersion = doorShutCloseSnd
    distantVersion = doorShutDistantSnd
    muffledVersion = (self)
}

doorShutCloseSnd: DistanceSFX {
    sfxURL = 'sounds/dooraway.ogg'
    volume = 50
    stackingPriority = 24

    sourceVersion = doorShutSnd
    closeVersion = (self)
    distantVersion = doorShutDistantSnd
    muffledVersion = doorShutMuffledSnd
}

doorShutDistantSnd: DistanceSFX {
    sfxURL = 'sounds/doordistant.ogg'
    volume = 35
    stackingPriority = 22

    sourceVersion = doorShutSnd
    closeVersion = doorShutCloseSnd
    distantVersion = (self)
    muffledVersion = doorShutMuffledSnd
}

RFIDUnlockSnd: DistanceSFX {
    sfxURL = 'sounds/rfidunlock.ogg'
    volume = 40
    stackingPriority = 29

    sourceVersion = (self)
    closeVersion = RFIDUnlockCloseSnd
    distantVersion = RFIDUnlockDistantSnd
    muffledVersion = RFIDUnlockMuffledSnd
}

RFIDUnlockMuffledSnd: DistanceSFX {
    sfxURL = 'sounds/rfidunlockmuffled.ogg'
    volume = 80
    stackingPriority = 27

    sourceVersion = RFIDUnlockSnd
    closeVersion = RFIDUnlockCloseSnd
    distantVersion = RFIDUnlockDistantSnd
    muffledVersion = (self)
}

RFIDUnlockCloseSnd: DistanceSFX {
    sfxURL = 'sounds/rfidunlockaway.ogg'
    volume = 40
    stackingPriority = 25

    sourceVersion = RFIDUnlockSnd
    closeVersion = (self)
    distantVersion = RFIDUnlockDistantSnd
    muffledVersion = RFIDUnlockMuffledSnd
}

RFIDUnlockDistantSnd: DistanceSFX {
    sfxURL = 'sounds/rfidunlockdistant.ogg'
    volume = 40
    stackingPriority = 23

    sourceVersion = RFIDUnlockSnd
    closeVersion = RFIDUnlockCloseSnd
    distantVersion = (self)
    muffledVersion = RFIDUnlockMuffledSnd
}

ventOpenSnd: GameSFX {
    sfxURL = 'sounds/ventopen.ogg'
    volume = 50
}

ventCloseSnd: GameSFX {
    sfxURL = 'sounds/ventclose.ogg'
    volume = 50
}