import SpriteKit
import GameplayKit

class Fighter: SKSpriteNode {
    
    var blockFrames:[SKTexture] = []
    var blockAnim:SKAction
    
    var hitFrames:[SKTexture] = []
    var hitAnim:SKAction
    
    var idleFrames:[SKTexture] = []
    var idleAnim:SKAction
    
    var punchFrames1:[SKTexture] = []
    var punchFrames2:[SKTexture] = []
    var punchAnim:SKAction

    var walkingFrames:[SKTexture] = []
    var walkingAnim:SKAction
    
    var blocking:Bool = false
    var health:CGFloat = 100
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(id:Int, side:Int, block:Int, hit:Int, idle:Int, punch:Int, walking:Int, pChk:Int) {
        for i in 0..<block {
            blockFrames.append(SKTexture(imageNamed: "\(id)\(side)B\(i)"))
        }
        blockAnim = SKAction.repeatForever(SKAction.animate(with: blockFrames, timePerFrame:0.1))
        
        for i in 0..<hit {
            hitFrames.append(SKTexture(imageNamed: "\(id)\(side)H\(i)"))
        }
        hitAnim = SKAction.animate(with: hitFrames, timePerFrame:0.1)
        
        for i in 0..<idle {
            idleFrames.append(SKTexture(imageNamed: "\(id)\(side)I\(i)"))
        }
        idleAnim = SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame:0.1))

        for i in 0..<punch {
            if(i < pChk){
                punchFrames1.append(SKTexture(imageNamed: "\(id)\(side)P\(i)"))
            }
            else{
                punchFrames2.append(SKTexture(imageNamed: "\(id)\(side)P\(i)"))
            }
        }
        punchAnim = SKAction.sequence([
            SKAction.animate(with: punchFrames1, timePerFrame:0.1),
            SKAction.animate(with: punchFrames2, timePerFrame:0.1),
            ])

        for i in 0..<walking {
            walkingFrames.append(SKTexture(imageNamed: "\(id)\(side)W\(i)"))
        }
        walkingAnim = SKAction.repeatForever(SKAction.animate(with: walkingFrames, timePerFrame:0.1))
        
        super.init(texture: idleFrames[0], color: UIColor.white, size: idleFrames[0].size())
    }
    
    
}

