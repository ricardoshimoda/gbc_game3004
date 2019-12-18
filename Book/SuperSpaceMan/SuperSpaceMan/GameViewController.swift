//
//  GameViewController.swift
//  SuperSpaceMan
//
//  Created by Ricardo Shimoda Nakasako on 2019-12-17.
//  Copyright © 2019 Ricardo Shimoda Nakasako. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var scene: GameScene!
    override var prefersStatusBarHidden:Bool { return true }
    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = view as! SKView
        skView.showsFPS = true
        scene = GameScene(size:skView.bounds.size)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }

}
