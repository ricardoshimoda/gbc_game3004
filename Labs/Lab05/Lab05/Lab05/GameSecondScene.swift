//
//  GameScene.swift
//  Lab05
//
//  Created by Ricardo Shimoda Nakasako on 2020-03-13.
//  Copyright © 2020 Ricardo Shimoda Nakasako. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameSecondScene: SKScene {
    
    override func didMove(to view: SKView) {
        //let particle = SKEmitterNode(
        // Create shape node to use during mouse interaction
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("ouch2")
        if let scene = SKScene(fileNamed: "GameScene") {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            scene.scaleMode = .aspectFill
            view?.presentScene(scene, transition: transition)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
