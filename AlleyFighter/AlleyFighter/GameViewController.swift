//
//  GameViewController.swift
//  AlleyFighter
//
//  Created by Ricardo Shimoda Nakasako on 2020-02-21.
//  Copyright © 2020 Ricardo Shimoda Nakasako. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var splashScene: SplashScene!
    var selectionScene: SelectionScene!
    var dialogScene: DialogScene!
    var fightScene: FightScene!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            //dialogScene = DialogScene(size:view.bounds.size)
            //dialogScene.scaleMode = .aspectFill
            //view.presentScene(dialogScene)
            
            //selectionScene = SelectionScene(size:view.bounds.size)
            //selectionScene.scaleMode = .aspectFill
            //view.presentScene(selectionScene)

            splashScene = SplashScene(size: view.bounds.size)
            splashScene.scaleMode = .aspectFill
            view.presentScene(splashScene)
            
            /* Common code for all scenes */
            view.ignoresSiblingOrder = false
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .landscape
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
