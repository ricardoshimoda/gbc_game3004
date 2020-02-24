//
//  GameViewController.swift
//  FlappyClone
//
//  Created by graphic on 2020-02-21.
//  Copyright © 2020 Shimoda Corp. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

/*
 
 */
precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}


class GameViewController: UIViewController {
    
    var titleScene: TitleScene!
    var gameScene: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            
            //titleScene = TitleScene(size:view.bounds.size)
            //titleScene.scaleMode = .aspectFill
            //view.presentScene(titleScene)
            gameScene = GameScene(size: view.bounds.size)
            gameScene.scaleMode = .aspectFill
            view.presentScene(gameScene)
            
            /* Common code for all scenes */
            view.ignoresSiblingOrder = false
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // We'll support only portrait for this flappy clone
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .portrait
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
