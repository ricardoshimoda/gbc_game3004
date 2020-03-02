/* Collision variables */
struct CollisionCategory {
    static let None : UInt32 = 0               // Matches nothing
    static let All : UInt32 = UInt32.max       // Matches everything
    static let Player : UInt32 = 0x1 << 1
    static let Robot : UInt32 = 0x1 << 1
}

