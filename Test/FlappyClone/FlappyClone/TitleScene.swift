
import SpriteKit
import GameplayKit

/*
 */
class TitleScene: BaseScene {
    var playerRatio:CGFloat = 0.035

    let copyrightNode: [SKSpriteNode] = [
        SKSpriteNode(imageNamed: "gears01"),
        SKSpriteNode(imageNamed: "gears02"),
        SKSpriteNode(imageNamed: "gears03"),
        SKSpriteNode(imageNamed: "gears04")
    ]
    var copyrightRatio:CGFloat = 0.02
    
    let titleNode: [SKSpriteNode] = [
        SKSpriteNode(imageNamed: "title01"),
        SKSpriteNode(imageNamed: "title02")
    ]
    var titleRatio:CGFloat = 0.065
    let titleHPos:CGFloat = 0.7
    let titleVMov:CGFloat = 0.03
    let titleDMov:TimeInterval = 0.5

    let startTexture: SKTexture! = SKTexture(imageNamed:"startbtn")
    let startTextureSelected: SKTexture! = SKTexture(imageNamed:"startbtnpressed")
    let scoreTexture: SKTexture! = SKTexture(imageNamed:"scorebtn")
    let scoreTextureSelected: SKTexture! = SKTexture(imageNamed:"scorebtnpressed")
    
    let bgAudio = SKAudioNode(fileNamed: "Sounds/Title.wav")

    required init?(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)
    }
    override init(size: CGSize){
        super.init(size:size)
        //super.backgroundNode
        /*
         * Implementing the things which are particular for this intrerface
         */
    }
    
    override func didMove(to view:SKView){
        super.addGround(2)
        bgAudio.autoplayLooped = true
        bgAudio.run(SKAction.play())
        addChild(bgAudio)
        
        addCopyright()
        addTitle()
        addButtons()
    }

    
    func addCopyright(){
        var acc:CGFloat = 0
        let separator:CGFloat = 0.01 * w
        //var total
        copyrightRatio = copyrightRatio * h / copyrightNode[0].size.height
        
        for copyItem in 0..<copyrightNode.count {
            copyrightNode[copyItem].setScale(copyrightRatio)
            copyrightNode[copyItem].anchorPoint = CGPoint(x:0.0,y:0.0)
            if(copyItem > 1){
                copyrightNode[copyItem].position = CGPoint(x: 0.5 * w + acc + separator, y: 0.05 * h)
                acc += copyrightNode[copyItem].size.width + separator
            }
            else{
                copyrightNode[copyItem].position = CGPoint(x: 0.5 * w + acc, y: 0.05 * h)
                acc += copyrightNode[copyItem].size.width
            }
        }
        for copyItem in 0..<copyrightNode.count {
            let finalX = copyrightNode[copyItem].position.x - 0.5 * acc
            copyrightNode[copyItem].position = CGPoint(x: finalX, y: 0.05 * h)
            addChild(copyrightNode[copyItem])
        }
    }
    
    func addTitle(){
        
        var acc:CGFloat = 0
        let separator:CGFloat = 0.03 * w
        //var total
        playerRatio = playerRatio * h / playerNode.size.height
        titleRatio = titleRatio * h / titleNode[0].size.height
                
        for copyItem in 0..<titleNode.count {
            titleNode[copyItem].setScale(titleRatio)
            titleNode[copyItem].anchorPoint = CGPoint(x:0.0,y:0.0)
            titleNode[copyItem].position = CGPoint(x: 0.5 * w + acc, y: titleHPos * h)
            acc += titleNode[copyItem].size.width
        }
        playerNode.setScale(playerRatio)
        playerNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        playerNode.position = CGPoint(x: 0.5 * w + acc + separator, y: titleHPos * h)
        acc += playerNode.size.width + separator
        for copyItem in 0..<titleNode.count {
            let finalX = titleNode[copyItem].position.x - 0.5 * acc
            titleNode[copyItem].position = CGPoint(x: finalX, y: titleHPos * h)
            addChild(titleNode[copyItem])
        }
        
        let titleZeroX = titleNode[0].position.x
        let titleZeroY = titleNode[0].position.y - 0.15 * titleNode[0].size.height
        titleNode[0].position = CGPoint(x: titleZeroX, y: titleZeroY)
        let finalPlayerX = playerNode.position.x - 0.5 * acc
        let finalPlayerY = titleHPos * h + 0.5 * titleNode[0].size.height
        playerNode.position = CGPoint(x: finalPlayerX, y: finalPlayerY)
        addChild(playerNode)
        
        /*
         * Extra animations
         */
        let moveDown = SKAction.moveBy(x: 0, y: -titleVMov * h, duration: titleDMov)
        let moveUp = SKAction.moveBy(x: 0, y: titleVMov * h, duration: titleDMov)
        let moveForever = SKAction.repeatForever(SKAction.sequence([moveDown,moveUp]))
        titleNode[0].run(moveForever)
        titleNode[1].run(moveForever)
        playerNode.run(moveForever)

    }
    
    func addButtons(){
        buttonHProp = buttonHProp * w / startTexture.size().width
        let startBtn = FTButtonNode(
            defaultTexture: startTexture,
            selectedTexture: startTextureSelected,
            disabledTexture: startTexture,
            prop: buttonHProp)
        startBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(TitleScene.startBtnTap))
        startBtn.position = CGPoint(x: 0.30*w, y: btnVPos * h)
        startBtn.zPosition = 1
        startBtn.name = "startBtn"
        self.addChild(startBtn)
        let scoreBtn = FTButtonNode(
            defaultTexture: scoreTexture,
            selectedTexture: scoreTextureSelected,
            disabledTexture: scoreTexture, prop: buttonHProp)
        scoreBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(TitleScene.scoreBtnTap))
        scoreBtn.position = CGPoint(x: 0.70*w, y: btnVPos * h)
        scoreBtn.zPosition = 1
        scoreBtn.name = "scoreBtn"
        self.addChild(scoreBtn)
    }

    @objc func scoreBtnTap() {
        print("scoreBtnTap tapped")
    }
    @objc func startBtnTap() {
        print("startBtnTap tapped")
        // Goes to game screen
        let transition = SKTransition.crossFade(withDuration: 3.0)
        let gameScene = GameScene(size: size)
        view?.presentScene(gameScene, transition: transition)
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
