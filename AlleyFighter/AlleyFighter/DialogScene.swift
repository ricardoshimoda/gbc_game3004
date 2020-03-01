import SpriteKit
import GameplayKit

/*
 */
class DialogScene: BaseScene {
    let bgMusic:[SKAudioNode] = [
        SKAudioNode(fileNamed: "Sounds/Dialog/RyuMusic.mp3"),
        SKAudioNode(fileNamed: "Sounds/Dialog/ChunLiMusic.mp3"),
        SKAudioNode(fileNamed: "Sounds/Dialog/BlankaMusic.mp3"),
    ]
    let bgImage:[SKSpriteNode] = [
        SKSpriteNode(imageNamed: "RyuDStage"),
        SKSpriteNode(imageNamed: "ChunLiDStage"),
        SKSpriteNode(imageNamed: "BlankaDStage"),
    ]
    let P1:[SKSpriteNode] = [
        SKSpriteNode(imageNamed: "RyuD1P"),
        SKSpriteNode(imageNamed: "ChunLiD1P"),
        SKSpriteNode(imageNamed: "BlankaD1P"),
    ]
    let P2:[SKSpriteNode] = [
        SKSpriteNode(imageNamed: "RyuD2P"),
        SKSpriteNode(imageNamed: "ChunLiD2P"),
        SKSpriteNode(imageNamed: "BlankaD2P"),
    ]
    let dialogBg : SKSpriteNode = SKSpriteNode(imageNamed: "DialogBackground")
    
    let names:[String] = [
        "Ryu", "ChunLi", "Blanka"
    ]
    
    let dialogLabelFont:[String] = [
        "Electroharmonix",
        "Great Vibes",
        "a dripping marker",
    ]
    let dialogLabelFontSize:[CGFloat] = [
        25,
        35,
        45,
    ]
    let dialogLabelP1:SKLabelNode = SKLabelNode()
    let dialogLabelP2:SKLabelNode = SKLabelNode()

    let dialog:[[String]] = [
        [
            "Shadowloo has to be extinguished",
            "You are on my way to make them pay",
            "Prepare to be defeated",
        ],
        [
            "Shadowloo is the root of all evil",
            "I will not stop at anything to defeat them",
            "Step aside to let me solve this",
        ],
        [
            "GRaahrhhhah greaugh arrgghhh",
            "Groof Grump Graaaaaaaa",
            "Would you kindly be defeated?",
        ],
    ]
    
    var idxP1:Int = -1
    var idxP2:Int = -1
    var idxDialog = 1
    
    
    let talkingHead = SKAction.repeatForever(
        SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.5),
            SKAction.scale(to: 1, duration: 0.5),
            SKAction.scale(to: 0.8, duration: 0.5),
            SKAction.scale(to: 1, duration: 0.5),
        ]))

    let defaults = UserDefaults.standard

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
        /*
        idxP1 = defaults.integer(forKey:"P1")
        idxP2 = defaults.integer(forKey:"P2")
        */

        idxP1 = 2
        idxP2 = 2

        bgMusic[idxP1].autoplayLooped = true
        addChild(bgMusic[idxP1])
        bgMusic[idxP1].run(SKAction.play())
        
        bgImage[idxP1].size.width = w
        bgImage[idxP1].size.height = h
        bgImage[idxP1].anchorPoint = CGPoint(x:0.5, y:0.5)
        bgImage[idxP1].position = CGPoint(x: 0.5*w, y: 0.5*h)
        addChild(bgImage[idxP1])
        
        dialogBg.size.width = w
        dialogBg.size.height = 0.5*h
        dialogBg.anchorPoint = CGPoint(x:0.5, y:0)
        dialogBg.position = CGPoint(x:0.5*w, y:0.7*h)
        dialogBg.alpha = 0.8
        addChild(dialogBg)
        
        dialogLabelP1.horizontalAlignmentMode = .left
        dialogLabelP1.position = CGPoint(x: 0.01*w, y:0.9*h)
        dialogLabelP1.fontName = dialogLabelFont[idxP1]
        dialogLabelP1.fontSize = dialogLabelFontSize[idxP1]/* testing values */
        dialogLabelP1.text = "[\(names[idxP1])]: \(dialog[idxP1][0])"
        addChild(dialogLabelP1)
        
        dialogLabelP2.horizontalAlignmentMode = .left
        dialogLabelP2.position = CGPoint(x: 0.01*w, y:0.9*h)
        dialogLabelP2.fontName = dialogLabelFont[idxP2]
        dialogLabelP2.fontSize = dialogLabelFontSize[idxP2]/* testing values */
        dialogLabelP2.text = "" /* testing values */
        addChild(dialogLabelP2)
        
        let prop = 0.6*h/P1[idxP1].size.height
        P1[idxP1].setScale(prop)
        P1[idxP1].position = CGPoint(x: 0.1*w, y: 0.3*h)
        addChild(P1[idxP1])
        P1[idxP1].run(talkingHead, withKey: "Talking")
        
        let prop2 = 0.6*h/P2[idxP2].size.height
        P2[idxP2].setScale(prop2)
        P2[idxP2].position = CGPoint(x: 0.9*w, y: 0.3*h)
        P2[idxP2].run(talkingHead, withKey: "Talking")
        P2[idxP2].action(forKey: "Talking")?.speed = 0
        addChild(P2[idxP2])
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(idxDialog < 6)
        {
            var convoIndex = -1
            if(idxDialog % 2 == 1){
                convoIndex = (idxDialog - 1) / 2
                dialogLabelP1.text = ""
                P1[idxP1].action(forKey: "Talking")?.speed = 0
                P1[idxP1].setScale(0)
                dialogLabelP2.text = "[\(names[idxP2])]: \(dialog[idxP2][convoIndex])"
                P2[idxP2].action(forKey: "Talking")?.speed = 1

            } else {
                convoIndex = (idxDialog) / 2
                dialogLabelP2.text = ""
                P2[idxP2].action(forKey: "Talking")?.speed = 0
                P2[idxP2].setScale(1)
                dialogLabelP1.text = "[\(names[idxP1])]: \(dialog[idxP1][convoIndex])"
                P1[idxP1].action(forKey: "Talking")?.speed = 1
            }
            idxDialog += 1
        }
        else{
            // Go To FIGHT!
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let fightScene = FightScene(size: self.size)
            self.view?.presentScene(fightScene, transition: transition)
        }
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        super.update(currentTime)
    }

}
