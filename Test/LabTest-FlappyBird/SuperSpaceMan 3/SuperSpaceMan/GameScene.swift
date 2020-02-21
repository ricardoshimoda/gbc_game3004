//
//  GameScene.swift
//  SuperSpaceMan
//
//  Created by Mark Meritt on 2019-02-04.
//  Copyright © 2019 Mark Meritt. All rights reserved.
//

import SpriteKit
import GameplayKit

let wallCategory: UInt32 = 0x1 << 0
let playerCategory: UInt32 = 0x1 << 1

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    //KRILLIN
   /*
    var krillinSprite: SKSpriteNode! //Sprite

    //IDLE
    var krillinIdleAtlas: SKTextureAtlas! //Spritesheet
    var krillinIdleFrames: [SKTexture]! //Frames
    var krillinIdle: SKAction! //Animation
    */
    //GOKU
    
    var gokuSprite:SKSpriteNode! //Sprite

    //IDLE
    var gokuIdleAtlas: SKTextureAtlas! //Spritesheet
    var gokuIdleFrames: [SKTexture]! //frames
    var gokuIdle: SKAction! //Animation
    
    //PUNCH
    var gokuPunchAtlas: SKTextureAtlas! //Spritesheet
    var gokuPunchFrames: [SKTexture]! //frames
    var gokuPunch: SKAction! //animation
 

    var idleToPunch: SKAction!
 
    override init(size: CGSize) {
        super.init(size: size)
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        
        self.physicsWorld.contactDelegate = self
        /*
        //KRILLIN
        krillinIdleAtlas = SKTextureAtlas(named: "krillinAtlas.1") //loaded our spritesheet
        krillinIdleFrames = [] //empty array of frames
        let numImages = krillinIdleAtlas.textureNames.count - 1 //retreive number of images in spritesheet
        for i in 1...numImages { //for loop to iterate through atlas
            let texture = "krillin_0\(i)"
            krillinIdleFrames.append(krillinIdleAtlas.textureNamed(texture))
        }
        krillinSprite = SKSpriteNode(texture: SKTexture(imageNamed: "krillin_01"))
        addChild(krillinSprite)
        krillinSprite.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        krillinSprite.setScale(4.0)
        krillinIdle = SKAction.animate(with: krillinIdleFrames, timePerFrame: 0.3, resize: true, restore: true)
        krillinSprite.run(SKAction.repeatForever(krillinIdle))
        krillinSprite.physicsBody = SKPhysicsBody(rectangleOf: krillinSprite.size)
        */
        
        //WALL
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = wallCategory
        self.physicsBody?.contactTestBitMask = playerCategory
      //  self.physicsBody?.collisionBitMask = 0
        
        //GOKU
        gokuIdleAtlas = SKTextureAtlas(named: "gokuAtlas.1") // 1. loading spritesheet
        gokuIdleFrames = [] //2. Initialize empty texture array
        
        let gokuIdleImages = gokuIdleAtlas.textureNames.count - 1 //3. count how many frames inside atlas
        
        //4. for loop
        for i in 1...gokuIdleImages {
            let texture = "idle_\(i)" //grab each frame in atlas
            gokuIdleFrames.append(gokuIdleAtlas.textureNamed(texture)) //add frame to texture array
        }
        
        gokuPunchAtlas = SKTextureAtlas(named: "gokuPunchAtlas.1")
        
        gokuPunchFrames = []
        
        let gokuPunchImages = gokuPunchAtlas.textureNames.count - 1
        
        for i in 0...gokuPunchImages  {
            let texture = "punch_\(i)"
            gokuPunchFrames.append(gokuPunchAtlas.textureNamed(texture))
        }
        
        gokuPunch = SKAction.animate(with: gokuPunchFrames, timePerFrame: 0.3, resize: true, restore: true)
        
        
        gokuSprite = SKSpriteNode(texture: SKTexture(imageNamed: "idle_1.png"))
        addChild(gokuSprite)
        
        gokuSprite.position = CGPoint(x: UIScreen.main.bounds.width / 3, y: UIScreen.main.bounds.height / 2)
        gokuSprite.setScale(2.0)
        
        gokuSprite.physicsBody = SKPhysicsBody(texture: gokuSprite.texture!, size: gokuSprite.size)

        gokuSprite.physicsBody?.categoryBitMask = playerCategory
        gokuSprite.physicsBody?.contactTestBitMask = wallCategory
 //       gokuSprite.physicsBody?.collisionBitMask = 0
        
        gokuIdle = SKAction.animate(with: gokuIdleFrames, timePerFrame: 0.3, resize: true, restore: true)
        //gokuIdle = SKAction.animate(with: gokuIdleFrames, timePerFrame: 0.2, resize: true, restore: true)
        idleToPunch = SKAction.sequence([gokuIdle, gokuPunch])
        gokuSprite.run(SKAction.repeatForever(idleToPunch))

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
    
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            

     //       powerUp?.physicsBody?.applyImpulse(CGVector(dx: 100, dy: 500))
       //     superSpaceMan?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
         //   print("The position of space man is \(superSpaceMan?.position)")
            if t.tapCount >= 2 {
         //       gokuSprite?.run(SKAction.sequence([punchAnimation!, idleAnimation!]))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
        //    powerUp?.physicsBody?.applyForce(CGVector(dx: 0, dy: 10))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
     
        if contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == wallCategory {
            print("player was bodyA")
            
       //     gokuSprite.run(idleToPunch)
        }
        
        if contact.bodyA.categoryBitMask == wallCategory && contact.bodyB.categoryBitMask == playerCategory {
            print("wall was bodyA")
           
       //     gokuSprite.run(idleToPunch)

        }
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
