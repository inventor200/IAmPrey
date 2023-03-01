prey: Actor { 'The Prey'
    "You are a neat-looking clone; long arms, sharp teeth and all! "
    person = (gCatMode ? 3 : 2)
    #if __DEBUG
    location = deliveryRoom
    #else
    location = deliveryRoom
    #endif

    scaredByOwnReflection = nil
    hasPonderedShatteredMirror = nil

    seeReflection(mirror) {
        mirror.confirmSmashed();
        if (gPlayerChar.hasSeen(skashek) && !scaredByOwnReflection) {
            scaredByOwnReflection = true;
            return 'Your heart lurches, as you think you spot <i><b>him</b></i>
                in your visual field. Once your reflexes give way to your conscious
                mind, you realize you and he look quite similar. You\'re not
                sure what you feel about that, for just a moment... ';
        }
        if (mirror.isSmashed) {
            return 'Attempts to look into it reveal rather whimsical
                patterns of reflection, but all you can see of yourself
                is that you have pale skin and white hair. <<ponderVanity()>>';
        }
        desc();
        return '';
    }

    hasPonderedVanity = nil

    ponderVanity() {
        if (hasPonderedVanity) return '';
        hasPonderedVanity = true;
        return '<.p>You weigh the idea in your mind. Do you value your appearance?
            Does looking <q>presentable</q> give you a tactical advantage
            during a chase?
            Are you neutral to it, while humans are often concerned?
            Is any vestige of vanity merely a programmed facet of your mind, so you
            would make yourself look nice during auction? ';
    }

    shatteredVanityMsg =
        '<.p>Judging by the damage to the mirror,
        someone in the facility does <i>not</i> enjoy pondering their appearance...<.p>';

    seeShatteredVanity() {
        if (hasPonderedShatteredMirror) return '';
        if (!hasPonderedVanity) return '';
        hasPonderedShatteredMirror = true;
        return shatteredVanityMsg;
    }
}