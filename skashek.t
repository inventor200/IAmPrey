#define handleRecklessAction(targetAction, response) \
    dobjFor(targetAction) { \
        preCond = [touchObj] \
        verify() { } \
        check() { } \
        action() { } \
        report() { \
            "<.p>"; \
            response; \
            "<.p>"; \
            finishGameMsg(ftDeath, gEndingOptionsLoss); \
        } \
    }

VerbRule(Hug)
    ('hug'|'embrace'|'cuddle' ('with'|)) singleDobj
    : VerbProduction
    action = Hug
    verbPhrase = 'hug/hugging (what)'
    missingQ = 'what do you want to hug'
;

DefineTAction(Hug)
;

modify VerbRule(Eat)
    ('eat'|'consume'|'bite') singleDobj :
;

modify Thing {
    dobjFor(Hug) {
        preCond = [touchObj]
        verify() {
            if (gActorIsCat) {
                illogical('How un-regal! ');
            }
            else {
                illogical('Maybe {my} affection should be applied elsewhere. ');
            }
        }
    }
}

skashek: Actor {
    vocab = 'Skashek;royal[weak];predator hunter subject sheki shek'
    desc() {
        "<<gSkashekName>>'s skin is as pale as death herself,
        and his grin reveals two rows of sharp teeth.
        His long, bone-white hair is combed over, but the sides and back
        of his head are shaved.
        His nose is slightly upturned, with a thin bridge, and
        his angular jawline is accentuated by an extended chin.
        His steady gaze glows red with the shine of night vision.
        His long arms end in clawed hands, engineered to grab
        humanoid prey by the throat.\b";
        outfit.wornDesc();
    }
    isHim = true
    theName = (globalParamName)
    trueNameKnown = nil

    globalParamName = (gCatMode ? '<b>The Royal Subject</b>' :
        (trueNameKnown ? '<b>Skashek</b>' : '<b>The Predator</b>'))

    location = dreamWorldSkashek

    outfit = skashekUniform

    hasSeenPreyStrip = nil
    hasSeenPreyOutsideOfDeliveryRoom = nil

    witnessPreyStripping() {
        if (hasSeenPreyStrip) return;
        hasSeenPreyStrip = true;
        reportAfter('<.p><q>Hah!</q> <<gSkashekName>> exclaims.
            <q>You\'ll need to do more than <i>that</i> to distract me,
            Prey!</q><.p>');
    }

    //Reckless actions lol
    getCombatPreface() {
        return '<i>It all happened so fast.</i>\b
            Every tactical instinct{dummy} in {me} said it was a bad idea.
            {I} {was} made for <i>killing</i>, sure, but this felt like
            running headfirst into death.
            Maybe a <i>human</i> would be so reckless, but {i} {was}
            programmed to weigh the costs and benefits before deploying
            violence.\b
            However, despite {my} instincts, {my} conscious mind had decided
            that <i>this</i> was the <i>sensible</i> course of action.\b';
    }

    getMisunderstoodAffectionBeginning(bodyPart, actionStr) {
        return '{I} decide to push the limits of what is thought to be
            possible.\b
            {I} approach, <<bodyPart>> at the ready, and...\b
            <i>...he thought {i} {was} attempting to <<actionStr>> him.</i>\b';
    }

    getMisunderstoodAffectionEnding() {
        return '\b{I} collapse to <<getOutermostRoom().floorObj.theName>>,
        overwhelmed by pain, shock, and <i>rejection</i>.\b
        <q>What the <i>fuck</i>, Prey?</q> he demands, now realizing what
        {i} {was} trying to do. With a deep sigh, he looks over {my} crumpled
        form, deciding what to do next.\b
        He rolls his eyes in disappointment, raises his boot over {my} skull,
        and swiftly ends {my} existence.';
    }

    handleRecklessAction(Kiss,
        "<<getMisunderstoodAffectionBeginning('lips', 'bite')>>
        In the blink of an eye, most of {my} teeth are shattered, and his
        bleeding fist{dummy} pulls away from {me}. {I} think {my} lower jaw has
        suffered multiple fractures, but {i}{'m} too dazed to be sure.
        <<getMisunderstoodAffectionEnding()>>"
    )

    handleRecklessAction(Hug,
        "<<getMisunderstoodAffectionBeginning('arms', 'grapple with')>>
        Faster than comprehension, he grabs both of {my} wrists, and uses
        the longer reach of a clone to find room for a swift kick to {my}
        lower jaw.
        <<getMisunderstoodAffectionEnding()>>"
    )

    handleRecklessAction(Eat,
        "<<getCombatPreface()>>
        {I} lunge at him, arms forward to pin him. However, his combat
        training is still superior to {my} newborn abilities. He grabs {my}
        arms in each hand, digging his claws into {my} flesh.\b
        No matter, {i} pull {my} arms outward, seeing at opening. Something
        is wrong, though: He is <i>allowing</i> this, without resistance.\b
        {I}{'m} almost in bite range, and he shifts his weight, relative to
        {mine}. It's almost like the ground{dummy} shifts beneath {me}; unstoppable.
        With the force of a warhammer, <<gSkashekName>> whips his skull into
        the side of {my} own, near the temple.\b
        The <i>crack</i> is deafening, and {my} sense of balance is suddenly
        non-existent. {I} realize too late that {my} legs had stopped moving.
        In the haze, {i} think he{dummy} throws {me} to the
        <<getOutermostRoom().floorObj.theName>>.\b
        <q>Fuck you, Prey,</q> he shouts. <q>I really thought you would be
        the one to escape! But you have failed me, too!</q>\b
        A boot slams down on {my} skull, and {my} existence comes to an
        abrupt end."
    )

    getCounterAttack() {
        local msg = '';
        if (gActionIs(AttackWith)) {
            if (gIobj.bulk <= 1) {
                msg += '<<gSkashekName>> kicks <<gIobj.theName>> out of {my}
                hand&mdash;hard enough to shatter {my} fingers&mdash;';
            }
            else {
                msg += '<<gSkashekName>> kicks <<gIobj.theName>> out of {my}
                hands&mdash;hard enough to nearly dislocate {my} wrists&mdash;';
            }
            msg += 'and it soars across <<getOutermostRoom().theName>>.\b';
        }
        return msg;
    }

    dobjFor(AttackWith) asDobjFor(Attack)
    dobjFor(ParkourJumpGeneric) asDobjFor(Attack)
    handleRecklessAction(Attack,
        "<<getCombatPreface()>>
        <<getCounterAttack()>>
        In one moment, {i} {was} attempting to recover, and the next moment
        revealed {my} neck vacated of flesh, which now dribbles from his mouth.
        {I} collapse in a pool of {my} own blood, rushing out of
        fresh, gaping wounds.\b
        The last thing {i} see is his expression, just as shocked and
        surprised as {my} own."
    )
}

+maintenanceKey: Key { 'maintenance keycard;rfid;key chip'
    "A small, white card with thin, silvery strips.
    This must have been used by the original researchers to
    unlocked maintenance areas. "

    owner = [skashek]
}