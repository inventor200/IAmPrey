// Provider paths
ProviderPath template @provider ->destination;
class ProviderPath: ParkourPathMaker {
    direction = parkourOverDir
}

AwkwardProviderPath template @provider ->destination;
class AwkwardProviderPath: ParkourPathMaker {
    direction = parkourOverDir
    requiresJump = true
}

DangerousProviderPath template @provider ->destination;
class DangerousProviderPath: ParkourPathMaker {
    direction = parkourOverDir
    requiresJump = true
    isHarmful = true
}

// Climb paths
ClimbUpPath template ->destination;
class ClimbUpPath: ParkourPathMaker {
    direction = parkourUpDir
}

ClimbOverPath template ->destination;
class ClimbOverPath: ParkourPathMaker {
    direction = parkourOverDir
}

ClimbDownPath template ->destination;
class ClimbDownPath: ParkourPathMaker {
    direction = parkourDownDir
}

// Jump paths
JumpUpPath template ->destination;
class JumpUpPath: ParkourPathMaker {
    direction = parkourUpDir
    requiresJump = true
}

JumpOverPath template ->destination;
class JumpOverPath: ParkourPathMaker {
    direction = parkourOverDir
    requiresJump = true
}

JumpDownPath template ->destination;
class JumpDownPath: ParkourPathMaker {
    direction = parkourDownDir
    requiresJump = true
}

FallDownPath template ->destination;
class FallDownPath: ParkourPathMaker {
    direction = parkourDownDir
    requiresJump = true
    isHarmful = true
}

// Two-way provider paths
ProviderLink template @provider ->destination;
class ProviderLink: ParkourLinkMaker {
    direction = parkourOverDir
}

AwkwardProviderLink template @provider ->destination;
class AwkwardProviderLink: ParkourLinkMaker {
    direction = parkourOverDir
    requiresJump = true
}

DangerousProviderLink template @provider ->destination;
class DangerousProviderLink: ParkourLinkMaker {
    direction = parkourOverDir
    requiresJump = true
    isHarmful = true
}

// Two-way climb paths
ClimbUpLink template ->destination;
class ClimbUpLink: ParkourLinkMaker {
    direction = parkourUpDir
}

ClimbOverLink template ->destination;
class ClimbOverLink: ParkourLinkMaker {
    direction = parkourOverDir
}

ClimbDownLink template ->destination;
class ClimbDownLink: ParkourLinkMaker {
    direction = parkourDownDir
}

// Two-way jump paths
JumpUpLink template ->destination;
class JumpUpLink: ParkourLinkMaker {
    direction = parkourUpDir
    requiresJump = true
    requiresJumpBack = nil
}

JumpOverLink template ->destination;
class JumpOverLink: ParkourLinkMaker {
    direction = parkourOverDir
    requiresJump = true
}

AwkwardClimbDownLink template ->destination;
class AwkwardClimbDownLink: ParkourLinkMaker {
    direction = parkourDownDir
    requiresJump = nil
    requiresJumpBack = true
}

// Floor heights
class LowFloorHeight: FloorHeight {
    startKnown = true; // Maintain functional parity with standard platforms
}

class AwkwardFloorHeight: FloorHeight {
    requiresJumpBack = true
}

class HighFloorHeight: FloorHeight {
    requiresJump = true

    createBackwardPath() { } // No way up
}

class DangerousFloorHeight: FloorHeight {
    requiresJump = true
    isHarmful = true

    createBackwardPath() { } // No way up
}