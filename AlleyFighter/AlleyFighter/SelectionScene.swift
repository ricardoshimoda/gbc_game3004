import SpriteKit
import GameplayKit

/*
 */
class SelectionScene: BaseScene {
    let bgMusic = SKAudioNode(fileNamed: "Sounds/Selection/PlayerSelectTheme.mp3")
    let bgImage = SKSpriteNode(imageNamed: "SelectionScreen")
    
    let defaults = UserDefaults.standard
    /*
     * 0-> nothing's been selected
     * 1-> player 1 has been selected
     * 2-> player2 has been selected
     */
    var state:Int = 0
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
        defaults.set(-1, forKey: "P1")
        defaults.set(-1, forKey: "P2")

        bgMusic.autoplayLooped = true
        addChild(bgMusic)
        bgMusic.run(SKAction.play())
        
        bgImage.size.width = w
        bgImage.size.height = h
        bgImage.anchorPoint = CGPoint(x:0.5, y:0.5)
        bgImage.position = CGPoint(x: 0.5*w, y: 0.5*h)
        addChild(bgImage)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let pos = touches.first!.location(in: bgImage)
        let tPrX = pos.x/w
        let tPrY = pos.y/h
        
        if (tPrX > -0.177 && tPrX < -0.09 &&
            tPrY > -0.296 && tPrY < -0.147){
            if(state == 0){
                defaults.set(0, forKey: "P1")
            }
            else{
                defaults.set(0, forKey: "P2")
            }
            print("Selected Ryu")
        }
        if (tPrX > -0.082 && tPrX < 0.001 &&
            tPrY > -0.472 && tPrY < -0.313){
            print("Selected ChunLi")
            if(state == 0){
                defaults.set(1, forKey: "P1")
            }
            else{
                defaults.set(1, forKey: "P2")
            }
        }
        if (tPrX > 0.011 && tPrX < 0.089 &&
            tPrY > -0.288 && tPrY < -0.151){
            print("Selected Blanka")
            if(state == 0){
                defaults.set(2, forKey: "P1")
            }
            else{
                defaults.set(2, forKey: "P2")
            }
        }
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
