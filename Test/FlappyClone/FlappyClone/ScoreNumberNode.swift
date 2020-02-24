import SpriteKit
import GameplayKit

class ScoreNumberNode: SKSpriteNode {
    let scoreTexture:[SKTexture] = [
        SKTexture(imageNamed: "score_0"),
        SKTexture(imageNamed: "score_1"),
        SKTexture(imageNamed: "score_2"),
        SKTexture(imageNamed: "score_3"),
        SKTexture(imageNamed: "score_4"),
        SKTexture(imageNamed: "score_5"),
        SKTexture(imageNamed: "score_6"),
        SKTexture(imageNamed: "score_7"),
        SKTexture(imageNamed: "score_8"),
        SKTexture(imageNamed: "score_9")
    ]
    let textTexture:[SKTexture] = [
        SKTexture(imageNamed: "text_0"),
        SKTexture(imageNamed: "text_1"),
        SKTexture(imageNamed: "text_2"),
        SKTexture(imageNamed: "text_3"),
        SKTexture(imageNamed: "text_4"),
        SKTexture(imageNamed: "text_5"),
        SKTexture(imageNamed: "text_6"),
        SKTexture(imageNamed: "text_7"),
        SKTexture(imageNamed: "text_8"),
        SKTexture(imageNamed: "text_9")
    ]
    var isScore:Bool = true {
        didSet {
            texture = isScore ? scoreTexture[val] : textTexture[val]
        }
    }
    var val:Int = 0 {
        didSet {
            val = val % 10
            texture = isScore ? scoreTexture[val] : textTexture[val]
        }
    }
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    init(_ numericValue:Int, sc:Bool, prop: CGFloat) {
        self.val = numericValue
        self.isScore = sc
        let finalTexture = isScore ? scoreTexture[val] : textTexture[val]
        let finalProp = prop/finalTexture.size().height
        let finalSize = CGSize(width: finalTexture.size().width * finalProp, height: finalTexture.size().height * finalProp)
        super.init(texture: finalTexture, color: UIColor.white, size: finalSize)
        self.anchorPoint=CGPoint(x:0,y:0.5)
    }
}

