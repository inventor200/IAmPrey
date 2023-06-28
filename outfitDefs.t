modify skashek {
    getWardrobePronounSub(caps?) {
        return getPeekHe(caps);
    }

    getWardrobePronounGen(caps?) {
        return getPeekHis(caps);
    }

    getWardrobePronounObj(caps?) {
        return getPeekHim(caps);
    }
}

modify Outfit {
    desc() {
        if (gCatMode) {
            "Strange garments, which <<gSkashekName>>
            spent a lot of time crafting.
            He{dummy} <i>should</i> have spent that time
            giving {me} scritches and head pats, but
            he provided a throne on his lap, instead. ";
        }
        else {
            inherited();
        }
    }

    dobjFor(Wear) {
        verify() {
            if (gCatMode) {
                illogical('{My} royal clothes are the beautiful
                    patterns of {my} own fur coat. ');
            }
            else if (gActor.wetness > 1) {
                illogical('{I} should probably dry off, first. ');
            }
            else {
                inherited();
            }
        }
    }

    dobjFor(Doff) {
        action() {
            if (skashek.canSee(gActor)) {
                skashek.witnessPreyStripping();
            }
            inherited();
        }
    }
}

class CloneUniform: Outfit {
    vocab = 'uniform;battle;bdu dress'

    aName = 'a uniform'
    headerName = 'combat uniform'
    headerPunctuation = ','

    externalDesc() {
        "<<shirtDesc>> ";
    }

    ambiguouslyPlural = true

    getCloneID() {
        return '3141';
    }

    getCloneRank() {
        return 'corporal';
    }

    camoDesc = 'with a camouflage pattern based on urban night environments'

    shirtDesc = '<<camoDesc>>.
        A shoulder patch marks the wearer as a member of the clone program. Over the
        left breast pocket is a rank pin, and on the right is an ID number tag.'
}

class CloneUniformShirt: ZippableGarment {
    vocab = 'uniform shirt;battle dress bdu;top'
    desc = "A long-sleeve battle dress shirt, <<uniformSource.shirtDesc>>
    The sleeves are extra-long for a human, as they are meant to fit a clone. "

    uniformSource = nil
    owner = (uniformSource.owner)
}

class CloneUniformPants: ZippableGarment {
    vocab = 'uniform pants;battle dress bdu pair[n] of[prep];trousers bottoms'
    desc = "A pair of battle dress pants, <<uniformSource.camoDesc>>. "

    ambiguouslyPlural = true
    uniformSource = nil
    owner = (uniformSource.owner)
}

class CloneUniformProgramPatch: Decoration { 'shoulder patch'
    "A red-green checkerboard pattern, bordered with a black stripe on the
    top and bottom. The red represents the blood to be spilled by the fascist state,
    and the green represents the pastures which are said to belong to the chosen few.
    The black represents the cover of night, which clones would have hunted in. "

    uniformSource = nil
    owner = (uniformSource.owner)
}

class CloneUniformRankPin: Decoration { 'rank pin;left[weak] bdu battle dress uniform shirt;breast[weak] pocket[weak]'
    "A small, golden pin indicates the rank of the uniform's wearer. This pin
    indicates the rank of <<uniformSource.getCloneRank()>>. "

    uniformSource = nil
    owner = (uniformSource.owner)
}

class CloneUniformIDNumberTag: Decoration { 'ID number tag;right[weak] bdu battle dress uniform shirt;breast[weak] pocket[weak] patch[weak] pin[weak]'
    "A small, black rectangle, with white numbers. This tag reads
    <q><<uniformSource.getCloneID()>></q>. "

    uniformSource = nil
    owner = (uniformSource.owner)
}

skashekUniform: CloneUniform {
    location = skashek
    wornBy = skashek
}
+CloneUniformShirt {
    uniformSource = skashekUniform
}
++CloneUniformProgramPatch {
    uniformSource = skashekUniform
}
++CloneUniformRankPin {
    uniformSource = skashekUniform
}
++CloneUniformIDNumberTag {
    uniformSource = skashekUniform
}
+CloneUniformPants {
    uniformSource = skashekUniform
}

preyUniform: CloneUniform {
    owner = prey
    location = dresser
    subLocation = &remapIn

    getCloneID() {
        return '7851';
    }

    getCloneRank() {
        return 'private';
    }
}
+CloneUniformShirt {
    uniformSource = preyUniform
}
++CloneUniformProgramPatch {
    uniformSource = preyUniform
}
++CloneUniformRankPin {
    uniformSource = preyUniform
}
++CloneUniformIDNumberTag {
    uniformSource = preyUniform
}
+CloneUniformPants {
    uniformSource = preyUniform
}