import SpriteKit
import GameplayKit

class FTButtonNode: SKSpriteNode {

    enum FTButtonActionType: Int {
        case TouchUpInside = 1,
        TouchDown, TouchUp
    }

    var isEnabled: Bool = true {
        didSet {
            if (disabledTexture != nil) {
                texture = isEnabled ? defaultTexture : disabledTexture
            }
        }
    }
    var isSelected: Bool = false {
        didSet {
            texture = isSelected ? selectedTexture : defaultTexture
        }
    }

    var defaultTexture: SKTexture
    var selectedTexture: SKTexture
    var label: SKLabelNode

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    init(defaultTexture: SKTexture!, selectedTexture:SKTexture!, disabledTexture: SKTexture?, prop: CGFloat) {

        self.defaultTexture = defaultTexture
        self.selectedTexture = selectedTexture
        self.disabledTexture = disabledTexture
        self.label = SKLabelNode(fontNamed: "Helvetica");
        let finalSize = CGSize(width: defaultTexture.size().width * prop, height: defaultTexture.size().height * prop)

        super.init(texture: defaultTexture, color: UIColor.white, size: finalSize)
        isUserInteractionEnabled = true

        //Creating and adding a blank label, centered on the button
        self.label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center;
        self.label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center;
        addChild(self.label)

        // Adding this node as an empty layer. Without it the touch functions are not being called
        // The reason for this is unknown when this was implemented...?
        let bugFixLayerNode = SKSpriteNode(texture: nil, color: UIColor.clear, size: finalSize)
        bugFixLayerNode.position = self.position
        addChild(bugFixLayerNode)

    }

    func setButtonAction(target: AnyObject, triggerEvent event:FTButtonActionType, action:Selector) {

        switch (event) {
        case .TouchUpInside:
            targetTouchUpInside = target
            actionTouchUpInside = action
        case .TouchDown:
            targetTouchDown = target
            actionTouchDown = action
        case .TouchUp:
            targetTouchUp = target
            actionTouchUp = action
        }

    }

    var disabledTexture: SKTexture?
    var actionTouchUpInside: Selector?
    var actionTouchUp: Selector?
    var actionTouchDown: Selector?
    weak var targetTouchUpInside: AnyObject?
    weak var targetTouchUp: AnyObject?
    weak var targetTouchDown: AnyObject?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!isEnabled) {
            return
        }
        isSelected = true
        if (targetTouchDown != nil && targetTouchDown!.responds(to: actionTouchDown!)) {
            UIApplication.shared.sendAction(actionTouchDown!, to: targetTouchDown, from: self, for: nil)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        if (!isEnabled) {
            return
        }

        let touch: AnyObject! = touches.first
        let touchLocation = touch.location(in: parent!)

        if (frame.contains(touchLocation)) {
            isSelected = true
        } else {
            isSelected = false
        }

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!isEnabled) {
            return
        }

        isSelected = false

        if (targetTouchUpInside != nil && targetTouchUpInside!.responds(to: actionTouchUpInside!)) {
            let touch: AnyObject! = touches.first
            let touchLocation = touch.location(in: parent!)

            if (frame.contains(touchLocation) ) {
                UIApplication.shared.sendAction(actionTouchUpInside!, to: targetTouchUpInside, from: self, for: nil)
            }

        }

        if (targetTouchUp != nil && targetTouchUp!.responds(to: actionTouchUp!)) {
            UIApplication.shared.sendAction(actionTouchUp!, to: targetTouchUp, from: self, for: nil)
        }
    }

}
