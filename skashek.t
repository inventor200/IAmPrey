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
                illogical('Maybe your affection should be applied elsewhere. ');
            }
        }
    }
}

skashek: Actor { 'Skashek;royal[weak];predator hunter subject sheki shek'
    "A rather terrifying visage! " //TODO: Describe
    isHim = true
    theName = (globalParamName)
    trueNameKnown = nil

    globalParamName = (gCatMode ? '<b>The Royal Subject</b>' :
        (trueNameKnown ? '<b>Skashek</b>' : '<b>The Predator</b>'))

    location = dreamWorldSkashek

    doPerception() {
        //TODO: Handle Skashek sound perception
    }

    doPlayerPeek() {
        //TODO: Player peeks in while he is in the room
    }

    doPlayerCaughtLooking() {
        //TODO: The player sees Skashek through a grate or cat flap,
        // but Skashek was ready!
        //TODO: Do not accept this if it happened last turn
    }

    describePeekedAction() {
        //TODO: Allow for him to be described according to his current action
        "<.p><i>\^<<gSkashekName>> is in there!</i> ";
    }

    //Reckless actions lol
    getCombatPreface() {
        return '<i>It all happened so fast.</i>\b
            Every tactical instinct in you said it was a bad idea. You were made
            for <i>killing</i>, sure, but this felt like running headfirst into
            death. Maybe a <i>human</i> would be so reckless, but you were
            programmed to weigh the costs and benefits before deploying
            violence.\b
            However, despite your instincts, your conscious mind had decided
            that <i>this</i> was the <i>sensible</i> course of action.\b';
    }

    getMisunderstoodAffectionBeginning(bodyPart, actionStr) {
        return 'You decide to push the limits of what is thought to be
            possible.\b
            You approach, <<bodyPart>> at the ready, and...\b
            <i>...he thought you were attempting to <<actionStr>> him.</i>\b';
    }

    getMisunderstoodAffectionEnding() {
        return '\bYou collapse to <<getOutermostRoom().floorObj.theName>>,
        overwhelmed by pain, shock, and <i>rejection</i>.\b
        <q>What the <i>fuck</i>, Prey?</q> he demands, now realizing what
        you were trying to do. With a deep sigh, he looks over your crumpled
        form, deciding what to do next.\b
        He rolls his eyes in disappointment, raises his boot over your skull,
        and swiftly ends your existence.';
    }

    handleRecklessAction(Kiss,
        "<<getMisunderstoodAffectionBeginning('lips', 'bite')>>
        In the blink of an eye, most of your teeth are shattered, and his
        bleeding fist pulls away from you. You think your lower jaw has
        suffered multiple fractures, but you're too dazed to be sure.
        <<getMisunderstoodAffectionEnding()>>"
    )

    handleRecklessAction(Hug,
        "<<getMisunderstoodAffectionBeginning('arms', 'grapple with')>>
        Faster than comprehension, he grabs both of your wrists, and uses
        the longer reach of a clone to find room for a swift kick to your
        lower jaw.
        <<getMisunderstoodAffectionEnding()>>"
    )

    handleRecklessAction(Eat,
        "<<getCombatPreface()>>
        You lunge at him, arms forward to pin him. However, his combat
        training is still superior to your newborn abilities. He grabs your
        arms in each hand, digging his claws into your flesh.\b
        No matter, you pull your arms outward, seeing at opening. Something
        is wrong, though: He is <i>allowing</i> this, without resistance.\b
        You're almost in bite range, and he shifts his weight, relative to
        yours. It's almost like the ground shifts beneath you; unstoppable.
        With the force of a warhammer, <<gSkashekName>> whips his skull into
        the side of your own, near the temple.\b
        The <i>crack</i> is deafening, and your sense of balance is suddenly
        non-existent. You realize too late that your legs had stopped moving.
        In the haze, you think he throws you to the
        <<getOutermostRoom().floorObj.theName>>.\b
        <q>Fuck you, Prey,</q> he shouts. <q>I really thought you would be
        the one to escape! But you have failed me, too!</q>\b
        A boot slams down on your skull, and your existence comes to an
        abrupt end."
    )

    getCounterAttack() {
        local msg = '';
        if (gActionIs(AttackWith)) {
            if (gIobj.bulk <= 1) {
                msg += '<<gSkashekName>> kicks <<gIobj.theName>> out of your
                hand&mdash;hard enough to shatter your fingers&mdash;';
            }
            else {
                msg += '<<gSkashekName>> kicks <<gIobj.theName>> out of your
                hands&mdash;hard enough to nearly dislocate your wrists&mdash;';
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
        In one moment, you were attempting to recover, and the next moment
        revealed your neck vacated of flesh, which now dribbles from his mouth.
        You collapse in a pool of your own blood, rushing out of
        fresh, gaping wounds.\b
        The last thing you see is his expression, just as shocked and
        surprised as your own."
    )
}

+maintenanceKey: Key { 'maintenance keycard;rfid;key chip'
    "A small, white card with thin, silvery strips.
    This must have been used by the original researchers to
    unlocked maintenance areas. "

    owner = [skashek]
}