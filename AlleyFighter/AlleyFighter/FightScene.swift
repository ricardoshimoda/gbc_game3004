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
    
    let P1Outcome:[[SKSpriteNode]] = [
        [
            SKSpriteNode(imageNamed:"Ryu1PW"),
            SKSpriteNode(imageNamed:"ChunLi1PW"),
            SKSpriteNode(imageNamed:"Blanka1PW"),
        ],
        [
            SKSpriteNode(imageNamed:"Ryu1PL"),
            SKSpriteNode(imageNamed:"ChunLi1PL"),
            SKSpriteNode(imageNamed:"Blanka1PL"),
        ],
    ]

    let P2Outcome:[[SKSpriteNode]] = [
        [
            SKSpriteNode(imageNamed:"Ryu2PW"),
            SKSpriteNode(imageNamed:"ChunLi2PW"),
            SKSpriteNode(imageNamed:"Blanka2PW"),
        ],
        [
            SKSpriteNode(imageNamed:"Ryu2PL"),
            SKSpriteNode(imageNamed:"ChunLi2PL"),
            SKSpriteNode(imageNamed:"Blanka2PL"),
        ],
    ]

    let playerSpeed:CGFloat = 100;
    var moveRight = false;
    var moveLeft = false;

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
        // So that things are not... floating?
        physicsWorld.gravity = CGVector(dx:0.0, dy:0.0)
        physicsWorld.contactDelegate = self
    }
    override func didMove(to view:SKView){
        
        isOn = true
        
        idxP1 = defaults.integer(forKey:"P1")
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
        P1[idxP1].name = "Player"
        addChild(P1[idxP1])
        
        let prop2 = 0.65*h/P2[idxP2].size.height
        P2[idxP2].setScale(prop2)
        P2[idxP2].position = CGPoint(x:0.95*w-0.5*P2[idxP2].size.width, y:0.55*h)
        P2[idxP2].name = "Bot"
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
        
        let btnLeftTxt = SKTexture(imageNamed:"Left")
        let btnLeftTxtSel = SKTexture(imageNamed:"LeftPressed")
        let roundBtnProp = 0.2 * h / btnLeftTxt.size().height
        let btnLeft = FTButtonNode(defaultTexture: btnLeftTxt, selectedTexture:btnLeftTxtSel, disabledTexture: btnLeftTxt, prop: roundBtnProp)
        btnLeft.position = CGPoint(x: 0.1*w, y:0.15*h)
        btnLeft.setButtonAction(target: self, triggerEvent: .TouchDown, action: #selector(FightScene.leftPressed))
        btnLeft.setButtonAction(target: self, triggerEvent: .TouchUp, action: #selector(FightScene.leftReleased))

        addChild(btnLeft)
        
        let btnRightTxt = SKTexture(imageNamed:"Right")
        let btnRightTxtSel = SKTexture(imageNamed:"RightPressed")
        let btnRight = FTButtonNode(defaultTexture: btnRightTxt, selectedTexture:btnRightTxtSel, disabledTexture: btnRightTxt, prop: roundBtnProp)
        btnRight.position = CGPoint(x: 0.15*w + btnLeft.size.width, y:0.15*h)
        btnRight.setButtonAction(target: self, triggerEvent: .TouchDown, action: #selector(FightScene.rightPressed))
        btnRight.setButtonAction(target: self, triggerEvent: .TouchUp, action: #selector(FightScene.rightReleased))
        addChild(btnRight)

        let btnBlockTxt = SKTexture(imageNamed:"Block")
        let btnBlockTxtSel = SKTexture(imageNamed:"BlockPressed")
        let btnBlock = FTButtonNode(defaultTexture: btnBlockTxt, selectedTexture:btnBlockTxtSel, disabledTexture: btnBlockTxt, prop: roundBtnProp)
        btnBlock.position = CGPoint(x: 0.9*w, y:0.15*h)
        btnBlock.setButtonAction(target: self, triggerEvent: .TouchDown, action: #selector(FightScene.blockPressed))
        btnBlock.setButtonAction(target: self, triggerEvent: .TouchUp, action: #selector(FightScene.blockReleased))
        addChild(btnBlock)

        let btnPunchTxt = SKTexture(imageNamed:"Punch")
        let btnPunchTxtSel = SKTexture(imageNamed:"PunchPressed")
        let btnPunch = FTButtonNode(defaultTexture: btnPunchTxt, selectedTexture:btnPunchTxtSel, disabledTexture: btnPunchTxt, prop: roundBtnProp)
        btnPunch.position = CGPoint(x: 0.85*w - btnBlock.size.width, y:0.15*h)
        btnPunch.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(FightScene.punchPressed))
        addChild(btnPunch)
        
    }
    func endGame(){
        isOn = false
        P1[idxP1].removeAllActions()
        P2[idxP2].removeAllActions()
        
        let endPanel = SKSpriteNode(imageNamed: "GameOver")
        let epProp:CGFloat = 0.9*h/endPanel.size.height
        endPanel.setScale(epProp)
        endPanel.position = CGPoint(x:0.5*w,y:0.5*h)
        

        let btnStartTxt = SKTexture(imageNamed:"Start")
        let btnStartTxtSel = SKTexture(imageNamed:"StartPressed")
        let btnStartProp = 0.1*h/btnStartTxt.size().height
        let btnStart = FTButtonNode(defaultTexture: btnStartTxt, selectedTexture: btnStartTxtSel, disabledTexture: btnStartTxt, prop: btnStartProp)
        btnStart.position = CGPoint(x:0, y:-0.25 * endPanel.size.height)
        btnStart.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(FightScene.startPressed))
        //print("Game Ended")
        endPanel.addChild(btnStart)
        addChild(endPanel)
        
        var idxP1F = 0
        var idxP2F = 1
        var finalSong = SKAudioNode(fileNamed: "Sounds/Fight/Victory.mp3")
        if(P1[idxP1].health < P2[idxP2].health){
            idxP1F = 1
            idxP2F = 0
            finalSong = SKAudioNode(fileNamed: "Sounds/Fight/Defeat.mp3")
        }
        finalSong.autoplayLooped = false
        P1Outcome[idxP1F][idxP1].setScale(0.4*h/(P1Outcome[idxP1F][idxP1].size.height * epProp))
        P1Outcome[idxP1F][idxP1].position = CGPoint(x:-0.22*endPanel.size.width, y:0)
    
        P2Outcome[idxP2F][idxP2].setScale(0.4*h/(P2Outcome[idxP2F][idxP2].size.height * epProp))
        P2Outcome[idxP2F][idxP2].position = CGPoint(x:0.22*endPanel.size.width, y:0)
        
        endPanel.addChild(P1Outcome[idxP1F][idxP1])
        endPanel.addChild(P2Outcome[idxP2F][idxP2])
        endPanel.addChild(finalSong)
        finalSong.run(SKAction.play())
    }
    @objc func startPressed(){
        // Go To Selection
        let transition = SKTransition.crossFade(withDuration: 1.0)
        let selectionScene = SelectionScene(size: self.size)
        self.view?.presentScene(selectionScene, transition: transition)

    }
    @objc func leftPressed(){
        if !isOn {return}
        moveRight = false;
        moveLeft = true;
        P1[idxP1].walk()
    }
    @objc func leftReleased(){
        if !isOn {return}
        moveLeft = false;
        P1[idxP1].stopWalk()
    }
    @objc func rightPressed(){
        if !isOn {return}
        moveLeft = false;
        moveRight = true;
        P1[idxP1].walk()
    }
    @objc func rightReleased(){
        if !isOn {return}
        moveRight = false;
        P1[idxP1].stopWalk()
    }
    @objc func punchPressed(){
        if !isOn {return}
        /* Have to check if this is the best thing to do */
        moveRight = false;
        moveLeft = false;
        P1[idxP1].punch()
    }
    @objc func blockPressed(){
        if !isOn {return}
        /* Have to check if this is the best thing to do */
        moveRight = false;
        moveLeft = false;
        P1[idxP1].block()
    }
    @objc func blockReleased(){
        if !isOn {return}
        /* Have to check if this is the best thing to do */
        moveRight = false;
        moveLeft = false;
        P1[idxP1].stopBlock()
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
            /* Caps player movement */
            if(moveRight){
                P1[idxP1].position.x += playerSpeed * CGFloat(dt)
                if(P1[idxP1].position.x > P2[idxP2].position.x - 0.01 * w){
                    P1[idxP1].position.x = P2[idxP2].position.x - 0.01 * w
                }
            }
            if(moveLeft){
                P1[idxP1].position.x -= playerSpeed * CGFloat(dt)
                if(P1[idxP1].position.x < 0.5 * P1[idxP1].size.width + 0.02 * w){
                    P1[idxP1].position.x = 0.5 * P1[idxP1].size.width + 0.02 * w
                }
            }
        }
    }

}

/*
 * This extension implements the collision between physical bodies
 */
extension FightScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact){
        print("Contact")
        if(isOn){
            P1[idxP1].otherFighter = P2[idxP2]
            P2[idxP2].otherFighter = P1[idxP1]
        }
    }
    func didEnd(_ contact: SKPhysicsContact){
        print("Decontact")
        if(isOn){
            P1[idxP1].otherFighter = nil
            P2[idxP2].otherFighter = nil
        }
    }
}

