import SpriteKit
import GameplayKit

/*
 */
class BaseScene: SKScene {
    /*
     * Initializes the scene
     */
    var h:CGFloat = 0
    var w:CGFloat = 0
    required init?(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)
    }
    override init(size: CGSize){
        super.init(size:size)
        h = size.height
        w = size.width
    }

}
