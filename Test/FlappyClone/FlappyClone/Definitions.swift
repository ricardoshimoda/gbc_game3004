
/* Collision variables */
struct CollisionCategory {
    static let None : UInt32 = 0               // Matches nothing
    static let All : UInt32 = UInt32.max       // Matches everything
    static let Player : UInt32 = 0x1 << 1
    static let Ground: UInt32 = 0x1 << 2
    static let Pipe: UInt32 = 0x01 << 3
}

