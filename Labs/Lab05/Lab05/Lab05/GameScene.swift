//
//  GameScene.swift
//  Lab05
//
//  Created by Ricardo Shimoda Nakasako on 2020-03-13.
//  Copyright © 2020 Ricardo Shimoda Nakasako. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("ouch1")

        if let scene = SKScene(fileNamed: "GameSecondScene") {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            scene.scaleMode = .aspectFill
            view?.presentScene(scene, transition: transition)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
