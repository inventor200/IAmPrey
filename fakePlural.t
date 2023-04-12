class FakePlural: object {
    ambiguouslyPlural = true
    plural = true

    // The string that refers to a single unit of the plural
    // For example: 'desk'
    fakeSingularPhrase = (name)
    // Make use of the "one of the ____" phrase
    useOneOfThe = true

    // Was the preposition recently polled?
    polledWithPrep = nil

    objInPrep() {
        polledWithPrep = true;
        return inherited();
    }

    objOutOfPrep() {
        polledWithPrep = true;
        return inherited();
    }

    objOutIntoPrep() {
        polledWithPrep = true;
        return inherited();
    }

    setSingularStatus() {
        // Prepositional phrases usually make more sense with singular
        if (polledWithPrep) {
            plural = nil;
        }
        else if (gCommand == nil) {
            plural = true;
        }
        else if (gAction == nil) {
            plural = true;
        }
        else if (gActionIs(Look) || gAction.actionFailed) {
            plural = true;
        }
        else if (gIobj == self || gActionIs(Board) || gActionIs(Enter) || gActionIs(LieOn) || gActionIs(SitOn) || gActionIs(StandOn)) {
            plural = nil;
            polledWithPrep = true;
        }
        else {
            plural = gCommand.verbProd.dobjMatch.grammarTag != 'normal';
        }
        polledWithPrep = nil;
    }

    aNameFrom(str) {
        plural = true;
        polledWithPrep = nil;
        return inherited(str);
    }

    pronoun() {
        setSingularStatus();
        return inherited();
    }

    theNameFrom(str) {
        setSingularStatus();

        local preferredNoun = str;
        if (!plural) preferredNoun = fakeSingularPhrase;

        if (ownerNamed && nominalOwner != nil) {
            return nominalOwner.possAdj + ' ' + preferredNoun;
        }
        
        if (qualified) {
            return preferredNoun;
        }

        if (!plural && useOneOfThe) {
            return 'one of the <<str>>';
        }

        return 'the <<preferredNoun>>';
    }
}

class FakePluralThing: FakePlural, Thing;