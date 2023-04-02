class Fridge: CargoBooth {
    vocab = 'refrigerator;snack drink drinks;fridge'
    desc = "A normal refrigerator, painted white. "
}

DefineDistSubComponentFor(FridgeRemapIn, Fridge, remapIn)
    isOpenable = true
    bulkCapacity = actorCapacity
    maxSingleBulk = 1
;