import SpriteKit
import GameplayKit

class FightScene: BaseScene {
    
    var isOn = true
    
    let bgMusic = SKAudioNode(fileNamed: "Sounds/Fight/BgFight.wav")
    let bgImage:[SKSpriteNode] = [
        SKSpriteNode(imageNamed: "RyuDStage"),
        SKSpriteNode(imageNamed: "ChunLiDStage"),
        SKSpriteNode(imageNamed: "BlankaDStage"),
    ]

    /*
     * Initializes the scene
     */
    let P1:[Fighter] = [
        Fighter(id:0, side:1, block:1, hit:4, idle:4, punch:5, walking:5, pChk:3),
        Fighter(id:1, side:1, block:1, hit:1, idle:4, punch:3, walking:8, pChk:2),
        Fighter(id:2, side:1, block:1, hit:2, idle:4, punch:5, walking:5, pChk:2),
    ]
    let P2:[Fighter] = [
        Fighter(id:0, side:2, block:1, hit:4, idle:4, punch:5, walking:5, pChk:3),
        Fighter(id:1, side:2, block:1, hit:1, idle:4, punch:3, walking:8, pChk:2),
        Fighter(id:2, side:2, block:1, hit:2, idle:4, punch:5, walking:5, pChk:2),
    ]
    
    let P1Logo:[SKSpriteNode] = [
        SKSpriteNode(imageNamed:"Ryu1P"),
        SKSpriteNode(imageNamed:"ChunLi1P"),
        SKSpriteNode(imageNamed:"Blanka1P"),
    ]
    let P2Logo:[SKSpriteNode] = [
        SKSpriteNode(imageNamed:"Ryu2P"),
        SKSpriteNode(imageNamed:"ChunLi2P"),
        SKSpriteNode(imageNamed:"Blanka2P"),
    ]

    let hBar1 = SKSpriteNode(imageNamed: "Lifebar")
    var hBar1OrWidth:CGFloat = 100
    let hBar2 = SKSpriteNode(imageNamed: "Lifebar")
    var hBar2OrWidth:CGFloat = 100

    let defaults = UserDefaults.standard
    var idxP1:Int = -1
    var idxP2:Int = -1
    
    var timer:Int = 180
    var lastTime:TimeInterval = 0
    var dt:TimeInterval = 0
    var second:TimeInterval = 0
    let timerLabel:SKLabelNode = SKLabelNode()

    let dialogBg : SKSpriteNode = SKSpriteNode(imageNamed: "DialogBackground")

    required init?(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)
    }
    override init(size: CGSize){
        super.init(size:size)
    }
    override func didMove(to view:SKView){
        
        isOn = true
        
        // So that things are not... floating?
        physicsWorld.gravity = CGVector(dx:0.0, dy:-1.0)
        physicsWorld.contactDelegate = self
        
        idxP1 = 0//defaults.integer(forKey:"P1")
        idxP2 = defaults.integer(forKey:"P2")

        //bgMusic.autoplayLooped = true
        //addChild(bgMusic)
        //bgMusic.run(SKAction.play())
        
        bgImage[idxP1].size.width = w
        bgImage[idxP1].size.height = h
        bgImage[idxP1].anchorPoint = CGPoint(x:0.5, y:0.5)
        bgImage[idxP1].position = CGPoint(x: 0.5*w, y: 0.65*h)
        addChild(bgImage[idxP1])
    
        createPlayers()
        createHUD()

    }
    func createPlayers(){
        let prop1 = 0.65*h/P1[idxP1].size.height
        P1[idxP1].setScale(prop1)
        P1[idxP1].position = CGPoint(x:0.05*w + 0.5*P1[idxP1].size.width, y:0.55*h)
        addChild(P1[idxP1])
        
        let prop2 = 0.65*h/P2[idxP2].size.height
        P2[idxP2].setScale(prop2)
        P2[idxP2].position = CGPoint(x:0.95*w-0.5*P2[idxP2].size.width, y:0.55*h)
        addChild(P2[idxP2])
    }
    func createHUD(){
        dialogBg.size.width = w
        dialogBg.size.height = 0.5*h
        dialogBg.anchorPoint = CGPoint(x:0.5, y:0)
        dialogBg.position = CGPoint(x:0.5*w, y:0.80*h)
        dialogBg.alpha = 0.8
        addChild(dialogBg)

        timerLabel.horizontalAlignmentMode = .center
        timerLabel.position = CGPoint(x: 0.5*w, y:0.85*h)
        timerLabel.fontName = "01 Digit"
        timerLabel.fontSize = 50
        timerLabel.text = "\(timer)"
        addChild(timerLabel)
        
        let logoProp1 = 0.15*h/P1Logo[idxP1].size.height
        P1Logo[idxP1].position = CGPoint(x:0.05*w, y:0.9*h)
        P1Logo[idxP1].setScale(logoProp1)
        addChild(P1Logo[idxP1])
        
        hBar1.anchorPoint = CGPoint(x:0,y:0.5)
        hBar1.size = CGSize(width: 0.3*w, height: 0.1*h)
        hBar1.position = CGPoint(x:0.05 * w + P1Logo[idxP1].size.width, y:0.9*h)
        hBar1OrWidth = hBar1.size.width
        addChild(hBar1)

        let logoProp2 = 0.15*h/P2Logo[idxP2].size.height
        P2Logo[idxP2].position = CGPoint(x:0.95*w, y:0.9*h)
        P2Logo[idxP2].setScale(logoProp2)
        addChild(P2Logo[idxP2])

        hBar2.anchorPoint = CGPoint(x:1,y:0.5)
        hBar2.size = CGSize(width: 0.3*w, height: 0.1*h)
        hBar2.position = CGPoint(x:0.95 * w - P2Logo[idxP2].size.width, y:0.9*h)
        hBar2OrWidth = hBar2.size.width
        addChild(hBar2)

    }
    func endGame(){
        isOn = false
        print("Game Ended")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        super.update(currentTime)
        if(isOn)
        {
            if(lastTime != 0) {
                dt = (currentTime - lastTime)
                second += dt
            }
            lastTime = currentTime
            if(second > 1)
            {
                timer -= 1
                second -= 1
                timerLabel.text = "\(timer)"
            }
            if(timer < 0)
            {
                endGame()
            }
            // Updates Health Bars
            hBar1.size.width = hBar1OrWidth * P1[idxP1].health/100
            hBar2.size.width = hBar2OrWidth * P2[idxP2].health/100
            
            // Verifies end game condition
            if(P1[idxP1].health <= 0 || P2[idxP2].health <= 0)
            {
                endGame()
            }
        }
    }

}

/*
 * This extension implements the collision between physical bodies
 */
extension FightScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact){
    }
}

