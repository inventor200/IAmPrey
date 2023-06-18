modify skashek {
    lastSeed = 1
    seedMax = 128
    randPool = static new Vector(128)

    // We are relying on a pool so that undo states have consistent behavior
    // Replugging seeds has weird results and lag with the algorithms available
    initSeed() {
        randomize();
        clearVector(randPool);
        for (local i = 1; i <= seedMax; i++) {
            local frontOrBack = (rand(4096) >= 2048);
            if (frontOrBack && randPool.length > 0) {
                randPool.insertAt(1, i);
            }
            else {
                randPool.append(i);
            }
        }
        lastSeed = 1;
    }

    getRandomResult(min, max?) {
        local root = randPool[lastSeed];
        lastSeed++;
        if (lastSeed >= seedMax) lastSeed -= seedMax;

        if (max == nil) {
            return (root % min) + 1;
        }

        local span = max - min;
        return (root % span) + min;
    }
}