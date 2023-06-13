emergeSnd: GameSFX {
    sfxURL = 'sounds/emerge.ogg'
    volume = 60
}

goodMoveSnd: GameSFX {
    sfxURL = 'sounds/goodmove.ogg'
    volume = 20
}

badMoveSnd: GameSFX {
    sfxURL = 'sounds/badmove.ogg'
    volume = 20
}

doorSlamShutSnd: GameSFX {
    sfxURL = 'sounds/doorslam.ogg'
    volume = 65
    stackingPriority = 50
}

doorShutCarefulSnd: GameSFX {
    sfxURL = 'sounds/doorcareful.ogg'
    volume = 15
}

doorOpenSnd: DistanceSFX {
    sfxURL = 'sounds/dooropen.ogg'
    volume = 30
    stackingPriority = 30

    sourceVersion = (self)
    closeVersion = doorOpenCloseSnd
    distantVersion = doorOpenDistantSnd
    muffledVersion = doorOpenMuffledSnd
}

doorOpenMuffledSnd: DistanceSFX {
    sfxURL = 'sounds/dooropenmuffled.ogg'
    volume = 85
    stackingPriority = 27

    sourceVersion = doorOpenSnd
    closeVersion = doorOpenCloseSnd
    distantVersion = doorOpenDistantSnd
    muffledVersion = (self)
}

doorOpenCloseSnd: DistanceSFX {
    sfxURL = 'sounds/dooropenaway.ogg'
    volume = 20
    stackingPriority = 24

    sourceVersion = doorOpenSnd
    closeVersion = (self)
    distantVersion = doorOpenDistantSnd
    muffledVersion = doorOpenMuffledSnd
}

doorOpenDistantSnd: DistanceSFX {
    sfxURL = 'sounds/dooropendistant.ogg'
    volume = 10
    stackingPriority = 21

    sourceVersion = doorOpenSnd
    closeVersion = doorOpenCloseSnd
    distantVersion = (self)
    muffledVersion = doorOpenMuffledSnd
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
    stackingPriority = 25

    sourceVersion = doorShutSnd
    closeVersion = doorShutCloseSnd
    distantVersion = doorShutDistantSnd
    muffledVersion = (self)
}

doorShutCloseSnd: DistanceSFX {
    sfxURL = 'sounds/dooraway.ogg'
    volume = 50
    stackingPriority = 22

    sourceVersion = doorShutSnd
    closeVersion = (self)
    distantVersion = doorShutDistantSnd
    muffledVersion = doorShutMuffledSnd
}

doorShutDistantSnd: DistanceSFX {
    sfxURL = 'sounds/doordistant.ogg'
    volume = 35
    stackingPriority = 19

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
    stackingPriority = 26

    sourceVersion = RFIDUnlockSnd
    closeVersion = RFIDUnlockCloseSnd
    distantVersion = RFIDUnlockDistantSnd
    muffledVersion = (self)
}

RFIDUnlockCloseSnd: DistanceSFX {
    sfxURL = 'sounds/rfidunlockaway.ogg'
    volume = 40
    stackingPriority = 23

    sourceVersion = RFIDUnlockSnd
    closeVersion = (self)
    distantVersion = RFIDUnlockDistantSnd
    muffledVersion = RFIDUnlockMuffledSnd
}

RFIDUnlockDistantSnd: DistanceSFX {
    sfxURL = 'sounds/rfidunlockdistant.ogg'
    volume = 40
    stackingPriority = 20

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