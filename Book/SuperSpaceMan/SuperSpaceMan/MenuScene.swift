//
//  MenuScene.swift
//  SuperSpaceMan
//
//  Created by Ricardo Shimoda Nakasako on 2019-12-26.
//  Copyright © 2019 Ricardo Shimoda Nakasako. All rights reserved.
//

import SpriteKit

class MenuScene:SKScene {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(size: CGSize, gameResult: Bool, score: Int) {
        super.init(size:size)
        let backgroundNode = SKSpriteNode(imageNamed:"Background")
        backgroundNode.size.width = frame.size.width
        backgroundNode.anchorPoint = CGPoint(x:0.5,y:0.0)
        backgroundNode.position = CGPoint(x:size.width/2.0,y:0.0)
        addChild(backgroundNode)

        let gameResultTextNode = SKLabelNode(fontNamed: "Copperplate")
        gameResultTextNode.text = "YOU " + (gameResult ? "WON":"LOST")
        gameResultTextNode.horizontalAlignmentMode = .center
        gameResultTextNode.verticalAlignmentMode = .center
        gameResultTextNode.fontColor = .white
        gameResultTextNode.fontSize = 20
        gameResultTextNode.position = CGPoint(x: size.width/2,
                                              y: size.height-200)
        addChild(gameResultTextNode)
        
        let scoreTextNode = SKLabelNode(fontNamed: "Copperplate")
        scoreTextNode.text = "SCORE \(score)"
        scoreTextNode.horizontalAlignmentMode = .center
        scoreTextNode.verticalAlignmentMode = .center
        scoreTextNode.fontColor = .white
        scoreTextNode.fontSize = 20
        scoreTextNode.position = CGPoint(x: size.width/2,
                                         y: size.height-40)
        addChild(scoreTextNode)
        
        let tryAgainL1 = SKLabelNode(fontNamed: "Copperplate")
        tryAgainL1.text = "TAP ANYWHERE"
        tryAgainL1.horizontalAlignmentMode = .center
        tryAgainL1.verticalAlignmentMode = .center
        tryAgainL1.fontColor = .white
        tryAgainL1.fontSize = 20
        tryAgainL1.position = CGPoint(x: size.width/2,
                                      y: 100)
        addChild(tryAgainL1)

        let tryAgainL2 = SKLabelNode(fontNamed: "Copperplate")
        tryAgainL2.text = "TO PLAY AGAIN!"
        tryAgainL2.horizontalAlignmentMode = .center
        tryAgainL2.verticalAlignmentMode = .center
        tryAgainL2.fontColor = .white
        tryAgainL2.fontSize = 20
        tryAgainL2.position = CGPoint(x: size.width/2,
                                      y: tryAgainL1.position.y - 40)
        addChild(tryAgainL2)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 2.0)
        let gameScene = GameScene(size: size)
        view?.presentScene(gameScene, transition: transition)
    }
}
