//
//  PlayScene.swift
//  pollette
//
//  Created by 김재민 on 8/10/24.
//

import SpriteKit
import GameplayKit

class PlayScene: SKScene, SKPhysicsContactDelegate {
    var balls: [SKShapeNode] = []
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = .init(dx: 0, dy: -0.5)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    override func didMove(to view: SKView) {
        for i in 1 ..< 5 {
            let ball = SKShapeNode(circleOfRadius: 12)
            ball.physicsBody = SKPhysicsBody(circleOfRadius: 12)
            ball.position = .init(x: CGFloat(view.frame.width / 2) + CGFloat(i*48), y: view.frame.height / 2)
            balls.append(ball)
        }
        balls.forEach { addChild($0) }
    }
    
    private func addBall(view: SKView) {
    }
}
