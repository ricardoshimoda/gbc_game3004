//
//  GameScene.swift
//  SuperSpaceMan
//
//  Created by Ricardo Shimoda Nakasako on 2019-12-17.
//  Copyright © 2019 Ricardo Shimoda Nakasako. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene {
    let backgroundNode = SKSpriteNode(imageNamed:"Background")
    let backgroundStarsNode = SKSpriteNode(imageNamed: "Stars")
    let backgroundPlanetNode = SKSpriteNode(imageNamed: "PlanetStart")
    
    let foregroundNode = SKSpriteNode()
    let playerNode = SKSpriteNode(imageNamed:"Player")
    //let orbNode = SKSpriteNode(imageNamed:"PowerUp")
    var impulseCount = 400
    let playerInitialY = CGFloat(180.0)
    
    /* Collision variables */
    let CollisionCategoryPlayer : UInt32 = 0x1 << 1
    let CollisionCategoryPowerUpOrbs : UInt32 = 0x1 << 2
    let CollisionCategoryBlackHoles : UInt32 = 0x01 << 3
    
    // Using the accelerometer
    let coreMotionManager = CMMotionManager()
    
    //var playerSpeed:CGFloat = 200
    //var previousTime:Double = 0
    //var frameCounter = 1
    required init?(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)
    }
    override init(size: CGSize){
        super.init(size:size)
        print("The size is (\(size))")
        //physicsWorld.gravity = CGVector(dx:0.0, dy:-2.0)
        physicsWorld.gravity = CGVector(dx:0.0, dy:-5.0)
        physicsWorld.contactDelegate = self
        isUserInteractionEnabled = true
        backgroundColor = SKColor(red:0.0,green:0.0,blue:0.0,alpha:1.0)
        
        backgroundNode.size.width = frame.size.width
        backgroundNode.anchorPoint = CGPoint(x:0.5,y:0.0)
        backgroundNode.position = CGPoint(x:size.width/2.0,y:0.0)
        addChild(backgroundNode)
        
        backgroundPlanetNode.size.width = frame.size.width
        backgroundPlanetNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundPlanetNode.position = CGPoint(x: size.width/2.0, y: 0.0)
        addChild(backgroundPlanetNode)
        
        backgroundStarsNode.size.width = frame.size.width
        backgroundStarsNode.anchorPoint = CGPoint(x: 0.5, y:0.0)
        backgroundStarsNode.position = CGPoint(x:160.0, y:0.0)
        addChild(backgroundStarsNode)
        
        addChild(foregroundNode)
        
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: playerNode.size.width/2)
        playerNode.physicsBody?.isDynamic = false
        playerNode.physicsBody?.linearDamping = 1.0
        playerNode.physicsBody?.allowsRotation = false
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryPlayer
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryPowerUpOrbs | CollisionCategoryBlackHoles
        playerNode.physicsBody?.collisionBitMask = 0

        playerNode.position = CGPoint(x:size.width/2.0, y:220.0)
        foregroundNode.addChild(playerNode)
        //playerNode.anchorPoint=CGPoint(x:1.0,y:1.0)
        
        /*
        orbNode.physicsBody = SKPhysicsBody(circleOfRadius:orbNode.size.width/2)
        orbNode.physicsBody?.isDynamic = false
        orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs
        orbNode.physicsBody?.collisionBitMask = 0
        
        orbNode.position = CGPoint(x:(size.width/2) - 10, y: size.height-orbNode.size.height-25)
        orbNode.name = "POWER_UP_ORB"
        foregroundNode.addChild(orbNode)
        
        var orbNodePosition = CGPoint(x: playerNode.position.x, y: playerNode.position.y + 100)
        for _ in 0...19{
            let orbNode = SKSpriteNode(imageNamed: "PowerUp")
            orbNodePosition.y += 140
            orbNode.position = orbNodePosition
            orbNode.physicsBody = SKPhysicsBody(circleOfRadius:orbNode.size.width/2)
            orbNode.physicsBody?.isDynamic = false
            orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs
            orbNode.physicsBody?.collisionBitMask = 0
            
            orbNode.name = "POWER_UP_ORB"
            foregroundNode.addChild(orbNode)
            
        }*/
        
        addOrbsToForeground()
        
        addBlackHolesToForeground()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        if !playerNode.physicsBody!.isDynamic {
            
            // Activates the physical body only after first touch
            playerNode.physicsBody?.isDynamic = true
            
            // Activates accelerometer only after first touch
            coreMotionManager.accelerometerUpdateInterval = 0.3
            coreMotionManager.startAccelerometerUpdates()
        }
        
        if impulseCount > 0 {
            playerNode.physicsBody?.applyImpulse(CGVector(dx:0.0,dy:40.0))
            impulseCount -= 1
        }
        //print("Screen Touching happened")
    }
    
    /*
    override func update(_ currentTime:TimeInterval)
    {
        if(previousTime == 0){
            previousTime = currentTime
            return
        }
        
        var newX = playerNode.position.x
        newX = newX + playerSpeed * CGFloat(currentTime - previousTime)
        print("Current position is (\(newX))")
        playerNode.position = CGPoint(x:newX,y:size.height/2.0)
        
        if(playerNode.position.x > size.width-playerNode.size.width ||
            playerNode.position.x < playerNode.size.width){
            playerSpeed = playerSpeed * -1
        }
        previousTime = currentTime
    }*/

    override func update(_ currentTime:TimeInterval)
    {
        if playerNode.position.y >= playerInitialY{
            backgroundNode.position = CGPoint(x: backgroundNode.position.x,
                                              y: -((playerNode.position.y - playerInitialY))/8)
            
            // Different rate of change - to give a "moving parallax" impression
            backgroundStarsNode.position = CGPoint(x: backgroundNode.position.x,
                                                   y: -((playerNode.position.y - playerInitialY))/6)
            
            backgroundPlanetNode.position = CGPoint(x: backgroundNode.position.x,
                                                    y: -((playerNode.position.y - playerInitialY))/8)
            
            // matches the speed of the player so that all other (not BKG) elements are scrolled together
            foregroundNode.position = CGPoint(x: foregroundNode.position.x,
                                              y: -(playerNode.position.y - playerInitialY))
        }
    }

    override func didSimulatePhysics() {
        if let accelerometerData = coreMotionManager.accelerometerData {
            playerNode.physicsBody!.velocity =
                CGVector(dx: CGFloat(accelerometerData.acceleration.x * 380.0),
                         dy: playerNode.physicsBody!.velocity.dy)
        }
        
        if playerNode.position.x < -(playerNode.size.width/2) {
            playerNode.position = CGPoint(x: size.width - playerNode.size.width/2,
                                          y: playerNode.position.y)
        }
        else if playerNode.position.x > self.size.width {
            playerNode.position = CGPoint(x: playerNode.size.width/2,
                                          y: playerNode.position.y )
        }
    }
    
    func addOrbsToForeground(){
        var orbNodePosition = CGPoint(x: playerNode.position.x, y: playerNode.position.y + 100)
        var orbXShift:CGFloat = -1.0
        for _ in 1...50 {
            let orbNode = SKSpriteNode(imageNamed: "PowerUp")
            /*
             * Alternates between creating the orb nodes going to the left and right everytime
             * the screen lateral dimensions are reached
             */
            if orbNodePosition.x - (orbNode.size.width * 2) <= 0 {
                orbXShift = 1.0
            }
            if orbNodePosition.x + orbNode.size.width >= size.width {
                orbXShift = -1.0
            }
            
            orbNodePosition.x += 40.0 * orbXShift
            orbNodePosition.y += 120
            orbNode.position = orbNodePosition
            
            orbNode.physicsBody = SKPhysicsBody(circleOfRadius:orbNode.size.width/2)
            orbNode.physicsBody?.isDynamic = false
            orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs
            orbNode.physicsBody?.collisionBitMask = 0
            
            orbNode.name = "POWER_UP_ORB"
            foregroundNode.addChild(orbNode)
        }
    }
    
    func addBlackHolesToForeground(){
        let textureAtlas = SKTextureAtlas(named: "sprites.atlas")
        
        let frame0 = textureAtlas.textureNamed("BlackHole0")
        let frame1 = textureAtlas.textureNamed("BlackHole1")
        let frame2 = textureAtlas.textureNamed("BlackHole2")
        let frame3 = textureAtlas.textureNamed("BlackHole3")
        let frame4 = textureAtlas.textureNamed("BlackHole4")
        
        let blackHoleTextures = [frame0,frame1,frame2,frame3,frame4]
        
        let animateAction = SKAction.animate(with: blackHoleTextures, timePerFrame: 0.2)
        let rotateAction = SKAction.repeatForever(animateAction)

        let moveLeftAction = SKAction.moveTo(x: 0.0, duration: 2)
        let moveRightAction = SKAction.moveTo(x: size.width, duration: 2)
        let actionSequence = SKAction.sequence([moveLeftAction,moveRightAction])
        let moveAction = SKAction.repeatForever(actionSequence)
        
        for i in 1...10 {
            let blackHoleNode = SKSpriteNode(imageNamed: "BlackHole0")
            blackHoleNode.position = CGPoint(x: size.width - 80.0, y:600.0 * CGFloat(i))
            
            blackHoleNode.physicsBody = SKPhysicsBody(circleOfRadius: blackHoleNode.size.width / 2)
            blackHoleNode.physicsBody?.isDynamic = false
            blackHoleNode.physicsBody?.categoryBitMask = CollisionCategoryBlackHoles
            blackHoleNode.physicsBody?.collisionBitMask = 0
            
            blackHoleNode.run(moveAction)
            blackHoleNode.run(rotateAction)
            
            blackHoleNode.name = "BLACK_HOLE"

            foregroundNode.addChild(blackHoleNode)
        }
    }
    
    deinit{
        coreMotionManager.stopAccelerometerUpdates()
    }
}

extension GameScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact){
        let nodeB = contact.bodyB.node
        if nodeB?.name == "POWER_UP_ORB" {
            impulseCount += 1
            nodeB?.removeFromParent()
        }
        else if nodeB?.name == "BLACK_HOLE" {
            let colorizeAction = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 1)
            playerNode.run(colorizeAction)
            
            // Cannot recover getting power orbs - this disables collision for this
            // physics body
            playerNode.physicsBody?.contactTestBitMask = 0
            
            impulseCount = 0
        }
    }
}
