
import SpriteKit
import CoreMotion


/*
 * Bronze: 10-19 points
 * Silver: 20-29 points
 * Gold: 30-39 points
 * Platinun: more than 40 points
 */

class GameScene: BaseScene {
    var playerRatio:CGFloat = 0.045
    var playerImpulse:Double = 20
    let playerAudio = SKAudioNode(fileNamed: "Sounds/Wings.wav")
    let pointAudio = SKAudioNode(fileNamed: "Sounds/Point.wav")
    
    var gamePaused = false
    var playerAlive = true
    
    var scoreNodes:[ScoreNumberNode] = []
    var currentScore:Int = 0
    let scoreProp:CGFloat = 0.035
    let bgAudio = SKAudioNode(fileNamed: "Sounds/Title.wav")
    
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
    var forever:SKAction = SKAction.wait(forDuration: 0.1)
    var delayedForever:SKAction = SKAction.wait(forDuration: 0.1)
    var pipeInterval:TimeInterval = 4
    var pipeWidthProp:CGFloat = 0.2
    
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
    var playBtn : SKSpriteNode = SKSpriteNode()
    var pauseBtn : SKSpriteNode = SKSpriteNode()
    
    let gameOverNode:[SKSpriteNode] = [
        SKSpriteNode(imageNamed: "gameover01"),
        SKSpriteNode(imageNamed: "gameover02")
    ]
    let flash:SKSpriteNode = SKSpriteNode(imageNamed:"whitebg")
    let medals:[SKSpriteNode] = [
        SKSpriteNode(imageNamed: "medalbronze"),
        SKSpriteNode(imageNamed: "medalsilver"),
        SKSpriteNode(imageNamed: "medalgold"),
        SKSpriteNode(imageNamed: "medalplatinum")
    ]
    let newbs:SKSpriteNode = SKSpriteNode(imageNamed:"newbestscore")
    let scoreboard:SKSpriteNode = SKSpriteNode(imageNamed: "scoreboard")
    
    let okTexture:SKTexture = SKTexture(imageNamed: "okbtn")
    let okTextureSelected:SKTexture = SKTexture(imageNamed: "okbtnpressed")
    let shareTexture:SKTexture = SKTexture(imageNamed: "sharebtn")
    let shareTextureSelected:SKTexture = SKTexture(imageNamed: "sharebtnpressed")
    var okBtn : SKSpriteNode = SKSpriteNode()
    var shareBtn : SKSpriteNode = SKSpriteNode()

    required init?(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)
    }
    override init(size: CGSize){
        super.init(size:size)
        
    }
    
    
    override func didMove(to view:SKView){
        physicsWorld.gravity = CGVector(dx:0.0, dy:-5.0)
        physicsWorld.contactDelegate = self

        
        playerAlive = true
        currentScore = 0
        /*
         * Implementing the things that are particular for this interface
         */
        generatePillars()
        super.addGround(pipeInterval/1.2)
        getReady()
        addPlayer()
        updateScore()
        renderButtons()
    }
    
    func configureSounds(){
        bgAudio.autoplayLooped = true
        bgAudio.run(SKAction.play())
        addChild(bgAudio)
        addChild(playerAudio)
        
    }
    
    func renderButtons(){
        playButtonProp = playButtonProp * h/playTexture.size().height
        playBtn = FTButtonNode(
            defaultTexture: playTexture,
            selectedTexture: playTextureSelected,
            disabledTexture: playTexture,
            prop: playButtonProp)
        let pb = playBtn as? FTButtonNode
        pb!.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.playBtnTap))
        playBtn.anchorPoint = CGPoint(x: 0,y: 1)
        playBtn.position = CGPoint(x: 0.04 * h, y: 0.96 * h)
        playBtn.zPosition = 1
        playBtn.name = "playBtn"
        //addChild(playBtn)
        pauseBtn = FTButtonNode(
            defaultTexture: pauseTexture,
            selectedTexture: pauseTextureSelected,
            disabledTexture: pauseTexture, prop: playButtonProp)
        let ps = pauseBtn as? FTButtonNode
        ps!.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.pauseBtnTap))
        pauseBtn.anchorPoint = CGPoint(x: 0,y: 1)
        pauseBtn.position = CGPoint(x: 0.04 * h, y: 0.96 * h)
        pauseBtn.zPosition = 1
        pauseBtn.name = "pauseBtn"
        addChild(pauseBtn)

    }
    @objc func pauseBtnTap(){
        if(playerAlive)
        {
            pauseBtn.removeFromParent()
            addChild(playBtn)
            pauseGround()
            pausePlayer()
            playerNode.physicsBody!.isDynamic = false
            if let action = pipeFirst.action(forKey: "pipe_moving") {
                action.speed = 0
            }
            if let action = pipeSecond.action(forKey: "pipe_moving") {
                action.speed = 0
            }
        }
    }
    @objc func playBtnTap ()
    {
        if(playerAlive){
            playBtn.removeFromParent()
            addChild(pauseBtn)
            unpauseGround()
            unpausePlayer()
            playerNode.physicsBody!.isDynamic = true
            if let action = pipeFirst.action(forKey: "pipe_moving") {
                action.speed = 1
            }
            if let action = pipeSecond.action(forKey: "pipe_moving") {
                action.speed = 1
            }
        }
    }
    func generatePillars(){
        addChild(pipeCollectionNode)
        let movingPillar = SKAction.moveBy(x:-1.2 * w, y:0, duration: pipeInterval)
        //let repositioningPillar = SKAction.moveTo(x: w,  duration: 0)
        let repositioningPillar = SKAction.customAction(withDuration: 0) {
            node, elapsedTime in
            if let node = node as? SKSpriteNode {
                let randomHeight:CGFloat = CGFloat(Float.random(in: 0...0.3))
                node.position = CGPoint(x: self.w, y: randomHeight * self.h)
                node.name = "U"
            }
        }
        forever = SKAction.repeatForever(SKAction.sequence([movingPillar, repositioningPillar]))
        delayedForever = SKAction.sequence([SKAction.wait(forDuration: 0.5 * pipeInterval),forever])
        for pi in 0..<pipes.count{
            pipes[pi].size.width = pipeWidthProp * w
            pipes[pi].size.height = h
            
            // and now for the tricky part
            if(pi % 2 == 0){
                //PipeDown
                pipes[pi].anchorPoint = CGPoint(x:0.5, y: 0.5)
                pipes[pi].position = CGPoint(x: 0.5*pipes[pi].size.width , y: 0.33 * h - 0.5*pipes[pi].size.height)
            }
            else{
                pipes[pi].anchorPoint = CGPoint(x:0.5, y: 0.5)
                pipes[pi].position = CGPoint(x: 0.5*pipes[pi].size.width, y: 0.58 * h + 0.5*pipes[pi].size.height)
                
            }
            pipes[pi].physicsBody = SKPhysicsBody(texture: pipes[pi].texture!, size: pipes[pi].size)
            pipes[pi].physicsBody?.isDynamic = false
            pipes[pi].physicsBody?.linearDamping = 1.0
            pipes[pi].physicsBody?.allowsRotation = false
            pipes[pi].physicsBody?.categoryBitMask = CollisionCategory.Pipe
            pipes[pi].physicsBody?.contactTestBitMask = CollisionCategory.Player
            pipes[pi].physicsBody?.collisionBitMask = CollisionCategory.None

            // Adding physics (how difficult can that be?
            // I just hope anchoring is not going to 

            if pi / 2 > 0 {
                pipeFirst.addChild(pipes[pi])
            }
            else{
                pipeSecond.addChild(pipes[pi])
            }
        }
        pipeFirst.position = CGPoint(x:w, y: 0)
        pipeSecond.position = CGPoint(x:w, y: 0.1*h)
        pipeFirst.name = "U"
        pipeSecond.name = "U"
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
        
        let fadeOut = SKAction.fadeOut(withDuration: 2)
        let braceforImpact = SKAction.wait(forDuration:0.5)
        let goPillars = SKAction.customAction(withDuration: 0) {
            node, elapsedTime in
            self.pipeFirst.run(self.forever, withKey: "pipe_moving")
            self.pipeSecond.run(self.delayedForever, withKey: "pipe_moving")
        }
        let goPlayer = SKAction.customAction(withDuration: 0){
            node, elapsedTime in
            self.playerNode.physicsBody?.isDynamic = true
        }
        
        /* waits for about 1 second before fading out */
        tutorial[0].run(SKAction.sequence([braceforImpact, braceforImpact, fadeOut, braceforImpact, goPillars, goPlayer]))
        for i in 1..<tutorial.count {
            tutorial[i].run(SKAction.sequence([braceforImpact, braceforImpact, fadeOut]))
        }
    }
    func addPlayer(){
        playerRatio = playerRatio * h / playerNode.size.height
        playerNode.size.height *= playerRatio
        playerNode.size.width *= playerRatio
        playerNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playerNode.position = CGPoint(x: 0.3 * w + playerNode.size.width, y: 0.55 * h)
        playerNode.name = "Player"
        
        playerNode.physicsBody = SKPhysicsBody(texture: playerNode.texture!, size: playerNode.size)
        playerNode.physicsBody?.isDynamic = false
        playerNode.physicsBody?.linearDamping = 1.0
        playerNode.physicsBody?.allowsRotation = false
        playerNode.physicsBody?.categoryBitMask = CollisionCategory.Player
        playerNode.physicsBody?.contactTestBitMask = CollisionCategory.Pipe | CollisionCategory.Ground
        playerNode.physicsBody?.collisionBitMask = CollisionCategory.Ground //| CollisionCategory.Pipe// There is no recovering from the ground

        addChild(playerNode)
    }
    func parseScore()
    {
        var scIdx = 0
        var numeral = currentScore % 10
        var left = (currentScore - numeral) / 10
        while left > 0  {
            if scIdx < scoreNodes.count {
                scoreNodes[scIdx].val = numeral
            }
            else {
                let newNumber = ScoreNumberNode(numeral, sc: true, prop: scoreProp * h)
                scoreNodes.append(newNumber)
            }
            numeral = left % 10
            left = (left - numeral) / 10
            scIdx += 1
        }
        // last number
        if scIdx < scoreNodes.count  {
            scoreNodes[scIdx].val = numeral
        }
        else {
            let newNumber = ScoreNumberNode(numeral, sc: true, prop: scoreProp * h)
            scoreNodes.append(newNumber)
        }
    }
    func updateScore(){
        let separator = 0.005 * w
        if scoreNodes.count == 0 || (10^^(scoreNodes.count) <= currentScore) {
            for scIdx in (0..<scoreNodes.count).reversed() {
                scoreNodes[scIdx].removeFromParent()
            }
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
            }
            for scIdx in (0..<scoreNodes.count).reversed() {
                let finalX = scoreNodes[scIdx].position.x - 0.5 * acc
                scoreNodes[scIdx].position.x = finalX
                addChild(scoreNodes[scIdx])
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
        if(playerAlive){
            playerNode.physicsBody?.applyImpulse(CGVector(dx:0.0, dy:playerImpulse))
            playerAudio.run(SKAction.play())
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
        let delta = pipeWidthProp * 0.25 * w
        
        if pipeFirst.name == "U" && pipeFirst.position.x - delta < playerNode.position.x && pipeFirst.position.x + delta > playerNode.position.x {
            pipeFirst.name = "C"
            currentScore += 1
            updateScore()
        }
        if pipeSecond.name == "U" && pipeSecond.position.x - delta < playerNode.position.x && pipeSecond.position.x + delta > playerNode.position.x {
            pipeSecond.name = "C"
            currentScore += 1
            updateScore()
        }
    }
}


/*
 * This extension implements the collision between physical bodies
 */
extension GameScene : SKPhysicsContactDelegate {
    func playerDeath()
    {
        pausePlayer()
        playerNode.physicsBody?.contactTestBitMask = 0
        let bellyUp:SKAction = SKAction.rotate(toAngle: -0.5*CGFloat.pi, duration: 0.5)
        playerNode.run(bellyUp)
    }
    func gameResults(){
        flash.size.width = (1 + bgHDisc) * frame.size.width
        flash.size.height = (1 + bgHDisc) * frame.size.height
        flash.anchorPoint = CGPoint(x:0.5,y:0.0)
        flash.position = CGPoint(x: bgWPos * w, y: bgHPos * h - bgHDisc * h)
        addChild(flash)
        flash.run(SKAction.fadeOut(withDuration: 0.5))
        
    }
    func didBegin(_ contact: SKPhysicsContact){
        if(playerAlive){
            let nodeB = contact.bodyB.node
            if nodeB?.name == "Player" {
                playerAlive = false
                pauseBtn.removeFromParent()
                pauseGround()
                if let action = pipeFirst.action(forKey: "pipe_moving") {
                    action.speed = 0
                }
                if let action = pipeSecond.action(forKey: "pipe_moving") {
                    action.speed = 0
                }
                playerDeath()
                gameResults()
            }
        }
    }
    
}

