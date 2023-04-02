class CargoBooth: Fixture {
    betterStorageHeader
    IncludeDistComponent(TinyDoorHandle)
}

DefineDistSubComponentFor(CargoBoothRemapOn, CargoBooth, remapOn)
    isBoardable = true
    betterStorageHeader
;