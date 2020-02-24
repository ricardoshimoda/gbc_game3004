
import SpriteKit
import GameplayKit

/*
 */

class GameScene: BaseScene {
    var playerRatio:CGFloat = 0.045
    var gamePaused = false
    
    var scoreNodes:[ScoreNumberNode] = []
    var currentScore:Int = 0
    let scoreProp:CGFloat = 0.035
    
    let getReadyNode:[SKSpriteNode] = [
        SKSpriteNode(imageNamed: "getready01"),
        SKSpriteNode(imageNamed: "getready02")
    ]
    let getReadyHPos:CGFloat = 0.7
    var getReadyRatio:CGFloat = 0.065
    
    let pipeCollectionNode = SKSpriteNode()
    var pipeFirst:SKSpriteNode = SKSpriteNode()
    var pipeSecond:SKSpriteNode = SKSpriteNode()
    let pipes:[SKSpriteNode] = [
        SKSpriteNode(imageNamed: "pipedown"),
        SKSpriteNode(imageNamed: "pipeup"),
        SKSpriteNode(imageNamed: "pipedown"),
        SKSpriteNode(imageNamed: "pipeup")
    ]
    
    let bw:SKSpriteNode = SKSpriteNode(imageNamed: "blackwhite")
    let upArrow:SKSpriteNode = SKSpriteNode(imageNamed: "uparrow")
    let handUp:SKSpriteNode = SKSpriteNode(imageNamed: "handup")
    let tap:SKSpriteNode = SKSpriteNode(imageNamed: "tap")
    let tapEffect:SKSpriteNode = SKSpriteNode(imageNamed: "tapeffect")
    var tutorial:[SKSpriteNode] = []
    
    var playButtonProp:CGFloat = 0.06
    let playTexture:SKTexture = SKTexture(imageNamed: "playbtn")
    let playTextureSelected:SKTexture = SKTexture(imageNamed: "playbtnpressed")
    let pauseTexture:SKTexture = SKTexture(imageNamed: "pausebtn")
    let pauseTextureSelected:SKTexture = SKTexture(imageNamed: "pausebtnpressed")

    required init?(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)
    }
    override init(size: CGSize){
        super.init(size:size)
        currentScore = 0
        /*
         * Implementing the things that are particular for this interface
         */
        generatePillars()
        super.addGround(4)
        getReady()
        addPlayer()
        updateScore()
        renderButtons()
    }
    func renderButtons(){
        playButtonProp = playButtonProp * h/playTexture.size().height
        let playBtn = FTButtonNode(
            defaultTexture: playTexture,
            selectedTexture: playTextureSelected,
            disabledTexture: playTexture,
            prop: playButtonProp)
        playBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.playBtnTap))
        playBtn.anchorPoint = CGPoint(x: 0,y: 1)
        playBtn.position = CGPoint(x: 0.04 * h, y: 0.96 * h)
        playBtn.zPosition = 1
        playBtn.name = "playBtn"
        addChild(playBtn)
        let pauseBtn = FTButtonNode(
            defaultTexture: pauseTexture,
            selectedTexture: pauseTextureSelected,
            disabledTexture: pauseTexture, prop: playButtonProp)
        pauseBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(TitleScene.scoreBtnTap))
        pauseBtn.position = CGPoint(x: 0.05 * h, y: 0.95 * h)
        pauseBtn.zPosition = 1
        pauseBtn.name = "pauseBtn"
        //self.addChild(pauseBtn)

    }
    @objc func pauseBtnTap(){
        print("Pause button has been pressed")
    }
    @objc func playBtnTap ()
    {
        print("Play button has been pressed")
    }
    func generatePillars(){
        addChild(pipeCollectionNode)
        let movingPillar = SKAction.moveBy(x:-1.2 * w, y:0, duration: 2)
        //let repositioningPillar = SKAction.moveTo(x: w,  duration: 0)
        let repositioningPillar = SKAction.customAction(withDuration: 0) {
            node, elapsedTime in
            if let node = node as? SKSpriteNode {
                let randomHeight:CGFloat = CGFloat(Float.random(in: 0...0.3))
                node.position = CGPoint(x: self.w, y: randomHeight * self.h)
            }
        }
        let forever = SKAction.repeatForever(SKAction.sequence([movingPillar, repositioningPillar]))
        let delayedForever = SKAction.sequence([SKAction.wait(forDuration:1),forever])
        for pi in 0..<pipes.count{
            pipes[pi].size.width = 0.2 * w
            pipes[pi].size.height = h
            
            // and now for the tricky part
            if(pi % 2 == 0){
                //PipeDown
                pipes[pi].anchorPoint = CGPoint(x:0, y: 1)
                pipes[pi].position = CGPoint(x:0 , y: 0.33 * h)
                pipes[pi].name = "down"
            }
            else{
                pipes[pi].anchorPoint = CGPoint(x:0, y: 0)
                pipes[pi].position = CGPoint(x:0, y: 0.53 * h)
                pipes[pi].name = "up"
            }
            
            if pi / 2 > 0 {
                pipeFirst.addChild(pipes[pi])
            }
            else{
                pipeSecond.addChild(pipes[pi])
            }
        }
        pipeFirst.position = CGPoint(x:w, y: 0)
        pipeSecond.position = CGPoint(x:w, y: 0.1*h)
        /*
        pipeFirst.run(forever)
        pipeSecond.run(delayedForever)
        */
        pipeCollectionNode.addChild(pipeFirst)
        pipeCollectionNode.addChild(pipeSecond)
    }
    func getReady(){
        var acc:CGFloat = 0
        let separator:CGFloat = 0.03 * w
        getReadyRatio = getReadyRatio * h / getReadyNode[0].size.height
        for copyItem in 0...1 {
            getReadyNode[copyItem].size.height *= getReadyRatio
            getReadyNode[copyItem].size.width *= getReadyRatio
            getReadyNode[copyItem].anchorPoint = CGPoint(x:0.0,y:0.0)
            getReadyNode[copyItem].position = CGPoint(x: 0.5 * w + acc + separator, y: getReadyHPos * h)
            acc += getReadyNode[copyItem].size.width + separator
        }
        for copyItem in 0...1 {
            let finalX = getReadyNode[copyItem].position.x - 0.5 * acc
            getReadyNode[copyItem].position = CGPoint(x: finalX, y: getReadyHPos * h)
            addChild(getReadyNode[copyItem])
        }
        /* adjusting the height of "Get" - yeah, I know this is bizarre */
        let getReadyZeroX = getReadyNode[0].position.x
        let getReadyZeroY = getReadyNode[0].position.y + 0.15 * getReadyNode[0].size.height
        getReadyNode[0].position = CGPoint(x: getReadyZeroX, y: getReadyZeroY)
        tutorial.append(contentsOf: getReadyNode)
        
        let bwRatio = playerRatio * h / bw.size.height;
        bw.setScale(bwRatio)
        bw.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bw.position = CGPoint(x: 0.55 * w, y: 0.6 * h)
        addChild(bw)
        tutorial.append(bw)
        upArrow.setScale(bwRatio)
        upArrow.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        upArrow.position = CGPoint(x: 0.55 * w, y: 0.54 * h)
        addChild(upArrow)
        tutorial.append(upArrow)
        handUp.setScale(bwRatio)
        handUp.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        handUp.position = CGPoint(x: 0.55 * w, y: 0.48*h)
        addChild(handUp)
        tutorial.append(handUp)
        tap.setScale(bwRatio)
        tap.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        tap.position = CGPoint(x: 0.7 * w,y: 0.50*h)
        addChild(tap)
        tutorial.append(tap)
        /*
        let fadeOut = SKAction.fadeOut(withDuration: 2)
        for i in 0...tutorial.count-1 {
            tutorial[i].run(fadeOut)
        }*/
    }
    func addPlayer(){
        playerRatio = playerRatio * h / playerNode.size.height
        playerNode.size.height *= playerRatio
        playerNode.size.width *= playerRatio
        playerNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        playerNode.position = CGPoint(x: 0.3 * w , y: 0.55 * h)
        addChild(playerNode)
    }
    func parseScore()
    {
        var scIdx = 0
        var numeral = currentScore % 10
        var left = (currentScore - numeral) / 10
        while left > 0  {
            if scIdx < scoreNodes.count - 1 {
                scoreNodes[scIdx].val = numeral
            }
            else {
                scoreNodes.append(ScoreNumberNode(numeral, sc: true, prop: scoreProp * h))
            }
            numeral = left % 10
            left = (left - numeral) / 10
            scIdx += 1
        }
        // last number
        if scIdx < scoreNodes.count - 1 {
            scoreNodes[scIdx].val = numeral
        }
        else {
            scoreNodes.append(ScoreNumberNode(numeral, sc: true, prop: scoreProp * h))
        }
    }
    func updateScore(){
        let separator = 0.005 * w
        if scoreNodes.count == 0 || (10^^scoreNodes.count) < currentScore {
            if currentScore == 0{
                scoreNodes.append(ScoreNumberNode(0, sc: true, prop: scoreProp * h))
            }
            else {
                parseScore()
            }
            /* Repositions numbers with the new ensemble */
            var acc:CGFloat = 0
            for scIdx in (0..<scoreNodes.count).reversed() {
                scoreNodes[scIdx].position = CGPoint(x: 0.5 * w + acc + separator, y: 0.9 * h)
                acc += scoreNodes[scIdx].size.width + separator
                addChild(scoreNodes[scIdx])
            }
            for scIdx in (0..<scoreNodes.count).reversed() {
                let finalX = scoreNodes[scIdx].position.x - 0.5 * acc
                scoreNodes[scIdx].position.x = finalX
            }
        }
        else {
            parseScore()
        }
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
