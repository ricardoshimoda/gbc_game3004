import SpriteKit
import GameplayKit

class Fighter: SKSpriteNode {
    
    let physicsCenter:[CGFloat] = [
        0.18,0.18,-0.05
    ]
    
    let punchSound = SKAudioNode(fileNamed: "Sounds/Fight/Hit.wav")
    let missSound = SKAudioNode(fileNamed: "Sounds/Fight/Miss.wav")
    
    var blockFrames:[SKTexture] = []
    var blockAnim:SKAction
    
    var hitFrames:[SKTexture] = []
    var hitAnim:SKAction
    
    var idleFrames:[SKTexture] = []
    var idleAnim:SKAction
    
    var punchFrames1:[SKTexture] = []
    var punchFrames2:[SKTexture] = []
    var punchAnim:SKAction = SKAction.wait(forDuration: 0) // Dummy action

    var walkingFrames:[SKTexture] = []
    var walkingAnim:SKAction
    
    var blocking:Bool = false
    var health:CGFloat = 100
    
    var otherFighter:Fighter?
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(id:Int, side:Int, block:Int, hit:Int, idle:Int, punch:Int, walking:Int, pChk:Int) {
        for i in 0..<block {
            blockFrames.append(SKTexture(imageNamed: "\(id)\(side)B\(i)"))
        }
        blockAnim = SKAction.repeatForever(SKAction.animate(with: blockFrames, timePerFrame:0.1))
        
        for i in 0..<idle {
            idleFrames.append(SKTexture(imageNamed: "\(id)\(side)I\(i)"))
        }
        idleAnim = SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame:0.2))

        for i in 0..<hit {
            hitFrames.append(SKTexture(imageNamed: "\(id)\(side)H\(i)"))
        }
        hitAnim = SKAction.sequence([
            SKAction.animate(with: hitFrames, timePerFrame:0.1),
            idleAnim
        ])
        
        for i in 0..<walking {
            walkingFrames.append(SKTexture(imageNamed: "\(id)\(side)W\(i)"))
        }
        walkingAnim = SKAction.repeatForever(SKAction.animate(with: walkingFrames, timePerFrame:0.1))
        
        super.init(texture: idleFrames[0], color: UIColor.white, size: idleFrames[0].size())
                
        punchSound.autoplayLooped = false;
        punchSound.run(SKAction.changeVolume(to: 4, duration: 0))
        addChild(punchSound)

        missSound.autoplayLooped = false;
        missSound.run(SKAction.changeVolume(to:4, duration:0))
        addChild(missSound)
        
        for i in 0..<punch {
            if(i < pChk){
                punchFrames1.append(SKTexture(imageNamed: "\(id)\(side)P\(i)"))
            }
            else{
                punchFrames2.append(SKTexture(imageNamed: "\(id)\(side)P\(i)"))
            }
        }
        let punchOther = SKAction.customAction(withDuration: 0, actionBlock: {
            node, elapsedTime in
            if(self.otherFighter != nil && !self.otherFighter!.blocking){
                self.punchSound.run(SKAction.play())
                self.otherFighter?.hurt()
            }
            else{
                self.missSound.run(SKAction.play())
            }
        })
        punchAnim = SKAction.sequence([
            SKAction.animate(with: punchFrames1, timePerFrame:0.1),
            punchOther,
            SKAction.animate(with: punchFrames2, timePerFrame:0.1),
            idleAnim
        ])

        run(idleAnim, withKey: "animation")
        
        let bodySize = CGSize(width: 0.5 * size.width, height: size.height)
        let bodyCenter = side == 1 ?
            CGPoint(x:-physicsCenter[id]*size.width,y:0) :
            CGPoint(x: physicsCenter[id]*size.width,y:0)
        
        physicsBody = SKPhysicsBody(rectangleOf: bodySize, center: bodyCenter)
        physicsBody?.isDynamic = true
        physicsBody?.linearDamping = 1.0
        physicsBody?.allowsRotation = false
        if(side==1){
            physicsBody?.categoryBitMask = CollisionCategory.Player
            physicsBody?.contactTestBitMask = CollisionCategory.Robot
            physicsBody?.collisionBitMask = CollisionCategory.None
        } else {
            physicsBody?.categoryBitMask = CollisionCategory.Robot
            physicsBody?.contactTestBitMask = CollisionCategory.Player
            physicsBody?.collisionBitMask = CollisionCategory.None
        }
    }
    func walk(){
        removeAction(forKey: "animation")
        run(walkingAnim, withKey: "animation")
    }
    func stopWalk(){
        removeAction(forKey: "animation")
        run(idleAnim, withKey: "animation")
    }
    func punch(){
        removeAction(forKey: "animation")
        run(punchAnim, withKey: "animation")
    }
    func block(){
        blocking = true
        removeAction(forKey: "animation")
        run(blockAnim, withKey: "animation")
    }
    func stopBlock(){
        blocking = false
        removeAction(forKey: "animation")
        run(idleAnim, withKey: "animation")
    }
    func hurt(){
        removeAction(forKey: "animation")
        run(hitAnim, withKey: "animation")
        health -= 10
    }
    func assignFighter(contact:Fighter){
        otherFighter = contact
    }
    func deassignFighter(){
        otherFighter = nil
    }
    
}

