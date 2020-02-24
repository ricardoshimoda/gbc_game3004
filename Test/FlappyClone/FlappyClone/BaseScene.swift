
import SpriteKit
import GameplayKit

/*
 */
class BaseScene: SKScene {
    let playerNode = SKSpriteNode(imageNamed: "flappybird01")

    /*
     * Buttons take about 1/4 of the screen, in width
     * Originally all buttons are to be 40px in width and 16px in height
     */
    var buttonHProp:CGFloat = 0.25
    
    let backgroundNode = SKSpriteNode(imageNamed: "background")
    let bgHDisc:CGFloat = 0.15
    let bgHPos:CGFloat = 0
    let bgWPos:CGFloat = 0.5
    
    let ground01 = SKSpriteNode(imageNamed: "ground")
    let ground02 = SKSpriteNode(imageNamed: "ground")
    let gHProp:CGFloat = 0.11
    
    var h:CGFloat = 0
    var w:CGFloat = 0
    /*
     * Initializes the scene
     */
    required init?(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)
    }
    override init(size: CGSize){
        super.init(size:size)
        
        /*
         * Short form for Height and Width
         */
        h = size.height
        w = size.width
        
        /*
         * Implementing the common background and the common "ground" in both screens
         */
        backgroundNode.size.width = (1 + bgHDisc) * frame.size.width
        backgroundNode.size.height = (1 + bgHDisc) * frame.size.height
        backgroundNode.anchorPoint = CGPoint(x:0.5,y:0.0)
        backgroundNode.position = CGPoint(x: bgWPos * w, y: bgHPos * h - bgHDisc * h)
        addChild(backgroundNode)
        
        /*
         * Flappy Animation
         */
        let playerFrames: [SKTexture] = [
            SKTexture(imageNamed: "flappybird01"),
            SKTexture(imageNamed: "flappybird02"),
            SKTexture(imageNamed: "flappybird03"),
            SKTexture(imageNamed: "flappybird04")
        ]
        let playerAnimation =  SKAction.repeatForever(
               SKAction.animate(with: playerFrames, timePerFrame: 0.1))
        playerNode.run(playerAnimation, withKey: "animation")
    }
    /*
     * Adds ground only when it is necessary (the game screen needs
     * to add the pillars before it adds the ground - otherwise this doesn't work properly)
     */
    func addGround(_ gDuration: TimeInterval ){
        ground01.size.width = frame.size.width
        ground01.size.height = gHProp * frame.size.height
        ground01.anchorPoint = CGPoint(x:0.0,y:0.0)
        ground01.position = CGPoint(x:0.0,y:0.0)
        addChild(ground01)

        /*
         * Actions created to move the ground repeatedly
         */
        let moveLeftActionRepeat01 = SKAction.moveTo(x: -size.width, duration: gDuration)
        let moveBackActionRepeat01 = SKAction.moveTo(x: 0, duration: 0)
        let actionRepeatSequence01 = SKAction.sequence([moveLeftActionRepeat01, moveBackActionRepeat01])
        let moveActionRepeatForever01 = SKAction.repeatForever(actionRepeatSequence01)
        ground01.run(moveActionRepeatForever01, withKey: "ground_moving")
        
        ground02.size.width = frame.size.width
        ground02.size.height = gHProp * frame.size.height
        ground02.anchorPoint = CGPoint(x:0.0, y:0.0)
        ground02.position = CGPoint(x:frame.size.width, y:0.0)
        addChild(ground02)
        /*
         * Actions created to move the ground repeatedly
         */
        let moveLeftActionRepeat02 = SKAction.moveTo(x: 0, duration: gDuration)
        let moveBackActionRepeat02 = SKAction.moveTo(x: size.width, duration: 0)
        let actionRepeatSequence02 = SKAction.sequence([moveLeftActionRepeat02, moveBackActionRepeat02])
        let moveActionRepeatForever02 = SKAction.repeatForever(actionRepeatSequence02)
        ground02.run(moveActionRepeatForever02, withKey: "ground_moving")
    }
    
    func stopGround(){
        ground01.removeAction(forKey: "ground_moving")
        ground02.removeAction(forKey: "ground_moving")
    }
    
    func pauseGround(){
        if let action = ground01.action(forKey: "ground_moving") {
            action.speed = 0
        }
        if let action = ground02.action(forKey: "ground_moving") {
            action.speed = 0
        }
    }
    func unpauseGround(){
        if let action = ground01.action(forKey: "ground_moving") {
            action.speed = 1
        }
        if let action = ground02.action(forKey: "ground_moving") {
            action.speed = 1
        }
    }
    func pausePlayer(){
        if let action = playerNode.action(forKey: "animation") {
            action.speed = 0
        }
    }
    func unpausePlayer(){
        if let action = playerNode.action(forKey: "animation") {
            action.speed = 1
        }
    }

    override func update(_ currentTime: TimeInterval) {
    }
}
