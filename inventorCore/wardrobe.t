modify Actor {
    outfit = nil
    
    isNaked() {
        for (local i = 1; i <= contents.length; i++) {
            local item = contents[i];
            if (item == enviroSuitBag) continue;
            if (!item.isWearable) continue;
            if (item.wornBy != self) continue;
            return nil;
        }

        return true;
    }

    getWardrobePronounSub(caps?) {
        return caps ? '{He}' : '{he}';
    }

    getWardrobePronounGen(caps?) {
        return caps ? '{His}' : '{his}';
    }

    getWardrobePronounObj(caps?) {
        return caps ? '{Him}' : '{him}';
    }
}

class Outfit: Wearable {
    bulk = getClothingBulk()
    externalDesc() { }
    desc() {
        "<<headerDesc(nil)>>";
        externalDesc();
    }

    wornDesc() {
        "<<headerDesc(true)>>";
        externalDesc();
    }

    headerName = 'outfit'
    headerPunctuation = '.'

    headerDesc(wornPerspective) {
        if (wornBy == gPlayerChar) {
            return (wornPerspective ? '{I} wear a ' : '{My} ') +
                headerName + headerPunctuation + ' ';
        }
        if (wornBy != nil) {
            return (wornPerspective ?
                '<<wornBy.getWardrobePronounSub(true)>> wears a '
                :
                '<<wornBy.getWardrobePronounGen(true)>> ') +
                headerName + headerPunctuation + ' ';
        }
        return 'A ' + headerName + headerPunctuation + ' ';
    }

    getClothingBulk() {
        // If we are manipulating this item, show its actual bulk.
        if (gDobj == self) return 2;
        // If we are manipulating something else, then the outfit
        // does not take up inventory space when worn.
        if (wornBy != nil) return 0;
        // Otherwise, its bulk is normal.
        return 2;
    }

    hideFromAll(action) {
        if (wornBy != nil) return true;
        if (action.ofKind(Wear) && gActor.outfit != nil) return true;
        return inherited(action);
    }

    dobjFor(Wear) {
        action() {
            inherited();
            gActor.outfit = self;
        }
    }

    dobjFor(Doff) {
        action() {
            gActor.outfit = nil;
            inherited();
        }
    }
}

class ZippableGarment: FakeZippable {
    isDecoration = true
    decorationActions = [Examine, Zip, Unzip]
}
