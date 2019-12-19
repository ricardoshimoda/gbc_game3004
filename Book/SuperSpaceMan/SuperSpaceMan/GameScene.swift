//
//  GameScene.swift
//  SuperSpaceMan
//
//  Created by Ricardo Shimoda Nakasako on 2019-12-17.
//  Copyright © 2019 Ricardo Shimoda Nakasako. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    let backgroundNode = SKSpriteNode(imageNamed:"Background")
    let playerNode = SKSpriteNode(imageNamed:"Player")
    let orbNode = SKSpriteNode(imageNamed:"PowerUp")
    
    /* Collision variables */
    let CollisionCategoryPlayer : UInt32 = 0x1 << 1
    let CollisionCategoryPowerUpOrbs : UInt32 = 0x1 << 2
    
    //var playerSpeed:CGFloat = 200
    //var previousTime:Double = 0
    //var frameCounter = 1
    required init?(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)
    }
    override init(size: CGSize){
        super.init(size:size)
        print("The size is (\(size))")
        physicsWorld.gravity = CGVector(dx:0.0, dy:-2.0)
        physicsWorld.contactDelegate = self
        isUserInteractionEnabled = true
        backgroundColor = SKColor(red:0.0,green:0.0,blue:0.0,alpha:1.0)
        
        backgroundNode.size.width = frame.size.width
        backgroundNode.anchorPoint = CGPoint(x:0.5,y:0.0)
        backgroundNode.position = CGPoint(x:size.width/2.0,y:0.0)
        addChild(backgroundNode)
        
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: playerNode.size.width/2)
        playerNode.physicsBody?.isDynamic = true
        playerNode.physicsBody?.linearDamping = 1.0
        playerNode.physicsBody?.allowsRotation = false
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryPlayer
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryPowerUpOrbs
        playerNode.physicsBody?.collisionBitMask = 0

        playerNode.position = CGPoint(x:size.width/2.0,y:size.height/2.0)
        addChild(playerNode)
        //playerNode.anchorPoint=CGPoint(x:1.0,y:1.0)
        
        orbNode.physicsBody = SKPhysicsBody(circleOfRadius:orbNode.size.width/2)
        orbNode.physicsBody?.isDynamic = false
        orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs
        orbNode.physicsBody?.collisionBitMask = 0
        
        orbNode.position = CGPoint(x:(size.width/2) - 10, y: size.height-orbNode.size.height-25)
        orbNode.name = "POWER_UP_ORB"
        addChild(orbNode)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        playerNode.physicsBody?.applyImpulse(CGVector(dx:0.0,dy:40.0))
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
}

extension GameScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact){
        let nodeB = contact.bodyB.node
        if nodeB?.name == "POWER_UP_ORB" {
            nodeB?.removeFromParent()
        }
        
    }
}
