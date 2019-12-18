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
    //let playerNode = SKSpriteNode(imageNamed:"Player")
    /* For now we're only going to have the initialization functions */
    required init?(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)
    }
    override init(size: CGSize){
        super.init(size:size)
        //backgroundColor = SKColor(red:0.0,green:0.0,blue:0.0,alpha:1.0)
        backgroundNode.size.width = frame.size.width
        backgroundNode.anchorPoint = CGPoint(x:0.5,y:0.0)
        backgroundNode.position = CGPoint(x:size.width/2.0,y:0.0)
        addChild(backgroundNode)
        
        //playerNode.position = CGPoint(x:size.width/2.0,y:80.0)
        //addChild(playerNode)
        let playerNode1 = SKSpriteNode(imageNamed: "Player")
        playerNode1.position = CGPoint(x:size.width/2.0,y:80.0)
        playerNode1.name = "FirstPlayer"
        addChild(playerNode1)

        let playerNode2 = SKSpriteNode(imageNamed: "Player")
        playerNode2.position = CGPoint(x:size.width/2.0,y:100.0)
        playerNode2.name = "SecondPlayer"
        addChild(playerNode2)
        
        let playerNode3 = SKSpriteNode(imageNamed: "Player")
        playerNode3.position = CGPoint(x:size.width/2.0,y:120.0)
        playerNode3.name = "ThirdPlayer"
        addChild(playerNode3)

    }
}
