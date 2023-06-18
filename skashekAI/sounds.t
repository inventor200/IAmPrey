skashekTalkingProfile: SoundProfile {
    'the muffled sound of <<skashek.getPeekHis()>> voice'
    'the nearby sound of <<skashek.getPeekHis()>> voice'
    'the distant sound of <<skashek.getPeekHis()>> voice'
    strength = 3
}

ominousClickingProfile: SoundProfile {
    'the muffled sound of <b>ominous clicking</b>'
    'the nearby sound of <b>ominous clicking</b>'
    'the distant sound of <b>ominous clicking</b>'
    strength = 3
}
+SubtleSound 'ominous clicking'
    doAfterPerception() {
        #if __DEBUG_SKASHEK_ACTIONS
        "<.p>
        Player noticed clicking!
        <.p>";
        #endif
        skashekAIControls.currentState.noticeOminousClicking();
    }
;

iKnowYoureInThereProfile: SoundProfile {
    '<<gSkashekName>>\'s muffled voice:\n<<messageStr>>'
    '<<gSkashekName>>\'s nearby voice:\n<<messageStr>>'
    '<<gSkashekName>>\'s distant voice:\n<<messageStr>>'
    strength = 3
    isSuspicious = true

    messageStr = '<q>I know you\'re in there, Prey...</q>'
}