class StorageLocker: CargoBooth {
    vocab = 'locker;storage cargo personal personnel metal'
    desc = "A plain, metal locker. It's a standard design for storing all sorts
    of things. A person could probably hide in it, too! "

    IncludeDistComponent(ContainerGrate)
}

DefineDistSubComponentFor(StorageLockerRemapIn, StorageLocker, remapIn)
    isOpenable = true
    isEnterable = true
    canSeeOut = true
    canHearOut = true
    betterStorageHeader
;