doorSlamCloseNoiseProfile: SoundProfile {
    'the muffled <i>ka-thud</i> of <<theSourceName>> automatically closing'
    'the echoing <i>ka-chunk</i> of <<theSourceName>> automatically closing'
    'the reverberating <i>thud</i> of a door automatically closing'
    strength = 5
    
    muffledSFXObject = doorShutMuffledSnd
    closeEchoSFXObject = doorShutCloseSnd
    distantSFXObject = doorShutDistantSnd

    afterEmission(room) {
        say('<.p>(Emitted door slam in <<room.roomTitle>>.)<.p>');
    }
}

doorSuspiciousCloseNoiseProfile: SoundProfile {
    'the muffled <i>ka-thud</i> of <<theSourceName>> automatically closing. <<lastSuspicionTarget.suspicionMsg>>'
    'the echoing <i>ka-chunk</i> of <<theSourceName>> automatically closing. <<lastSuspicionTarget.suspicionMsg>>'
    'the reverberating <i>thud</i> of a door automatically closing. <<lastSuspicionTarget.suspicionMsg>>'
    strength = 5
    isSuspicious = true
    
    muffledSFXObject = doorShutMuffledSnd
    closeEchoSFXObject = doorShutCloseSnd
    distantSFXObject = doorShutDistantSnd

    afterEmission(room) {
        say('<.p>(Emitted suspicious door slam in <<room.roomTitle>>.)<.p>');
    }
}

doorSuspiciousSilenceProfile: SoundProfile {
    '<<lastSuspicionTarget.suspiciousSilenceMsg>> '
    '<<lastSuspicionTarget.suspiciousSilenceMsg>> '
    '<<lastSuspicionTarget.suspiciousSilenceMsg>> '
    strength = 5
    isSuspicious = true
    absoluteDesc = true

    afterEmission(room) {
        say('<.p>(Emitted suspicious door silence in <<room.roomTitle>>.)<.p>');
    }
}

doorUnlockBuzzProfile: SoundProfile {
    'the muffled, electronic buzz of <<theSourceName>> being unlocked'
    'the echoing, electronic buzz of <<theSourceName>> being unlocked'
    'the reverberating, electronic buzz of a door being unlocked'
    strength = 3
    
    muffledSFXObject = RFIDUnlockMuffledSnd
    closeEchoSFXObject = RFIDUnlockCloseSnd
    distantSFXObject = RFIDUnlockDistantSnd

    afterEmission(room) {
        say('<.p>(Emitted unlock door buzz in <<room.roomTitle>>.)<.p>');
    }
}