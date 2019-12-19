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
    var playerSpeed:CGFloat = 200
    var previousTime:Double = 0
    //var frameCounter = 1
    /* For now we're only going to have the initialization functions */
    required init?(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)
        print("The size is (\(size))")
    }
    override init(size: CGSize){
        super.init(size:size)
        //backgroundColor = SKColor(red:0.0,green:0.0,blue:0.0,alpha:1.0)
        backgroundNode.size.width = frame.size.width
        backgroundNode.anchorPoint = CGPoint(x:0.5,y:0.0)
        backgroundNode.position = CGPoint(x:size.width/2.0,y:0.0)
        addChild(backgroundNode)
        
        playerNode.position = CGPoint(x:size.width/2.0,y:size.height/2.0)
        addChild(playerNode)
        //playerNode.anchorPoint=CGPoint(x:1.0,y:1.0)
    }
    
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
    }
}
