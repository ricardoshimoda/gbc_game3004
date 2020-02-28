import SpriteKit
import GameplayKit

/*
 */
class FightScene: SKScene {
    /*
     * Initializes the scene
     */
    required init?(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)
    }
    override init(size: CGSize){
        super.init(size:size)
    }
    override func didMove(to view:SKView){
        physicsWorld.gravity = CGVector(dx:0.0, dy:-5.0)
        physicsWorld.contactDelegate = self
    }
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        super.update(currentTime)
    }

}

/*
 * This extension implements the collision between physical bodies
 */
extension FightScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact){
    }
}

