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
    let foregroundNode = SKSpriteNode()
    let playerNode = SKSpriteNode(imageNamed:"Player")
    //let orbNode = SKSpriteNode(imageNamed:"PowerUp")
    var impulseCount = 4
    let playerInitialY = CGFloat(180.0)
    
    /* Collision variables */
    let CollisionCategoryPlayer : UInt32 = 0x1 << 1
    let CollisionCategoryPowerUpOrbs : UInt32 = 0x1 << 2
    
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
        
        addChild(foregroundNode)
        
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: playerNode.size.width/2)
        playerNode.physicsBody?.isDynamic = false
        playerNode.physicsBody?.linearDamping = 1.0
        playerNode.physicsBody?.allowsRotation = false
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryPlayer
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryPowerUpOrbs
        playerNode.physicsBody?.collisionBitMask = 0

        playerNode.position = CGPoint(x:size.width/2.0,y:playerInitialY)
        foregroundNode.addChild(playerNode)
        //playerNode.anchorPoint=CGPoint(x:1.0,y:1.0)
        
        /*
        orbNode.physicsBody = SKPhysicsBody(circleOfRadius:orbNode.size.width/2)
        orbNode.physicsBody?.isDynamic = false
        orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs
        orbNode.physicsBody?.collisionBitMask = 0
        
        orbNode.position = CGPoint(x:(size.width/2) - 10, y: size.height-orbNode.size.height-25)
        orbNode.name = "POWER_UP_ORB"
        foregroundNode.addChild(orbNode)*/
        
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
            foregroundNode.addChild(orbNode)        }
        
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
        
    }
}
