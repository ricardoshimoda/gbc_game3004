import SpriteKit
import GameplayKit

/*
 */
class SplashScene: BaseScene {
    
    
    let slap = SKAudioNode(fileNamed: "Sounds/Splash/Slap.wav")
    let bgMusic = SKAudioNode(fileNamed: "Sounds/Splash/TitleSoundtrack.wav")
    let bgImage = SKSpriteNode(imageNamed: "TitleScreen")
    let flash = SKSpriteNode(imageNamed: "Splash")
    /*
     * Initializes the scene
     */
    required init?(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)
    }
    override init(size: CGSize){
        super.init(size:size)
    }
    override func didMove(to view:SKView){
        slap.autoplayLooped = false
        addChild(slap)
        slap.run(SKAction.play())
        
        bgMusic.autoplayLooped = true
        addChild(bgMusic)
        bgMusic.run(SKAction.play())
        
        let bgProp = w/bgImage.size.width
        bgImage.setScale(bgProp)
        bgImage.anchorPoint = CGPoint(x:0.5, y:0.5)
        bgImage.position = CGPoint(x: 0.5*w, y:0.5*h)
        addChild(bgImage)
        
        flash.size.width = w
        flash.size.height = h
        flash.anchorPoint = CGPoint(x:0.5, y:0.5)
        flash.position = CGPoint(x: 0.5*w, y:0.5*h)
        flash.alpha = 0
        let flashAction = SKAction.sequence([
            SKAction.fadeOut(withDuration: 0),
            SKAction.wait(forDuration: 0.2),
            SKAction.fadeIn(withDuration: 0.2),
            SKAction.fadeOut(withDuration: 0.2)
        ])
        flash.run(flashAction)
        addChild(flash)

    }
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        super.update(currentTime)
    }

}
