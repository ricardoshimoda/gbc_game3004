import SpriteKit
import GameplayKit

/*
 */
class SelectionScene: BaseScene {
    let bgMusic = SKAudioNode(fileNamed: "Sounds/Selection/PlayerSelectTheme.mp3")
    let planeSound = SKAudioNode(fileNamed: "Sounds/Selection/Airplane.wav")
    let bgImage = SKSpriteNode(imageNamed: "SelectionScreen")
    
    let P1:[SKSpriteNode] = [
        SKSpriteNode(imageNamed:"Ryu1P"),
        SKSpriteNode(imageNamed:"ChunLi1P"),
        SKSpriteNode(imageNamed:"Blanka1P")
    ]
    let P2:[SKSpriteNode] = [
        SKSpriteNode(imageNamed:"Ryu2P"),
        SKSpriteNode(imageNamed:"ChunLi2P"),
        SKSpriteNode(imageNamed:"Blanka2P")
    ]
    let countryCoord:[CGPoint] = [
        CGPoint(x:0.2151424287856072,  y:0.27066670735677084),
        CGPoint(x:0.10569715142428786, y:0.33866670735677085),
        CGPoint(x:0.36656667088818873, y:0.05600004069010417)
    ]
    
    let plane = SKSpriteNode(imageNamed: "Plane")

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
        bgMusic.run(SKAction.changeVolume(to: 4, duration: 0))
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
        print("you just touched on x:\(tPrX) and y:\(tPrY)")
        // After 2 there really isn't more to choose from
        if(state < 2)
        {
            var selectedPlayer = -1
            if (tPrX > -0.177 && tPrX < -0.09 &&
                tPrY > -0.296 && tPrY < -0.147){
                selectedPlayer = 0
                print("Selected Ryu")
            }
            if (tPrX > -0.082 && tPrX < 0.001 &&
                tPrY > -0.472 && tPrY < -0.313){
                selectedPlayer = 1
                print("Selected ChunLi")
            }
            if (tPrX > 0.011 && tPrX < 0.089 &&
                tPrY > -0.288 && tPrY < -0.151){
                print("Selected Blanka")
                selectedPlayer = 2
            }
            if(selectedPlayer >= 0)
            {
                var selectedNode:SKSpriteNode
                if(state == 0){
                    defaults.set(selectedPlayer, forKey: "P1")
                    selectedNode = P1[selectedPlayer]
                    selectedNode.position = CGPoint(x:0.135*w, y:0.7*h)
                    state += 1
                }
                else{
                    defaults.set(selectedPlayer, forKey: "P2")
                    selectedNode = P2[selectedPlayer]
                    selectedNode.position = CGPoint(x:0.135*w, y:0.23*h)
                    flyMeToTheMoon()
                    state += 1
                }
                let prop = 0.32*h/selectedNode.size.height
                selectedNode.setScale(prop)
                addChild(selectedNode)
            }
        }
    }
    
    func flyMeToTheMoon()
    {
        planeSound.autoplayLooped = false
        addChild(planeSound)
        let planeSoundAction = SKAction.customAction(withDuration: 0, actionBlock:
         {
             node, elapsedTime in
             self.planeSound.run(SKAction.play())
         })
        
        let startingIndex  = defaults.integer(forKey:"P2")
        let finishingIndex = defaults.integer(forKey:"P1")
        
        print("Selected countries are: \(startingIndex) and \(finishingIndex)")
        
        let sp = CGPoint(
            x: countryCoord[startingIndex].x * w,
            y: countryCoord[startingIndex].y * h)
        let fp = CGPoint(
            x: countryCoord[finishingIndex].x * w,
            y: countryCoord[finishingIndex].y * h)

        let planeProp = 0.05 * w / plane.size.width
        plane.setScale(0)
        plane.position = sp
        
        var rotationAction:SKAction = SKAction.wait(forDuration: 0.5)
        if(startingIndex != finishingIndex)
        {
            var planeAngle = atan((fp.y-sp.y)/(fp.x-sp.x))
            if(sp.x > fp.x){
                planeAngle += CGFloat.pi
            }
            let eulerAngle : Float = Float(planeAngle) * 180 / Float.pi
            print("is this the real angle? \(eulerAngle)")
            rotationAction = SKAction.rotate(toAngle: planeAngle, duration: 0.5)
        }
        
        let screenTransitionAction = SKAction.customAction(withDuration: 0, actionBlock:{
            node, elapsedTime in
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let dialogScene = DialogScene(size: self.size)
            self.view?.presentScene(dialogScene, transition: transition)
        })
        
        let planeAction = SKAction.sequence([
            SKAction.scale(to: planeProp, duration: 0.5),
            rotationAction,
            SKAction.group([
                SKAction.move(to: fp, duration: 2),
                planeSoundAction
            ]),
            SKAction.scale(to:0, duration:1),
            SKAction.wait(forDuration: 0.5),
            screenTransitionAction
        ])
        bgImage.addChild(plane)
        plane.run(planeAction)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        super.update(currentTime)
    }

}
