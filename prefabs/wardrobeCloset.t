class Wardrobe: CargoBooth {
    vocab = 'wardrobe closet;wide metal;dresser'
    desc = "<<basicDesc()>><<showHidingStatus()>>"
    basicDesc = "A wide, metal wardrobe closet. "
    showHidingStatus() {
        "It looks large enough to hide in<<
        if !remapIn.isHidingSpot>>, but {i} would need to
        fill it with some clothes (or other large objects), first.
        Right now, it's too empty<<end>>. ";
    }
}

DefineDistSubComponentFor(WardrobeRemapIn, Wardrobe, remapIn)
    isOpenable = nil
    isEnterable = true
    isHidingSpot = (getObstructionStatus())
    betterStorageHeader

    getObstructionStatus() {
        local totalContents = valToList(contents);
        for (local i = 1; i <= totalContents.length; i++) {
            local obj = totalContents[i];
            if (obj.ofKind(Actor)) continue;
            if (obj.bulk >= 2) return true;
        }
        return nil;
    }
;