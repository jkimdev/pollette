//
//  PlayScene.swift
//  pollette
//
//  Created by 김재민 on 8/10/24.
//

import SpriteKit
import GameplayKit

public enum PlanetType: String, CaseIterable {
    case earth = "earth"
    case moon = "moon"
    case mustafar = "mustafar"
    case uranus = "uranus"
    
    var gravity: Double {
        switch self {
        case .earth:
            return -9.81
        case .moon:
            return -1.62
        case .mustafar:
            return -0.4
        case .uranus:
            return -8.69
        }
    }
}

class PlayScene: SKScene, SKPhysicsContactDelegate {
    let ballCategory: UInt32 = 0x1 << 0
    let groundCategory: UInt32 = 0x1 << 1
    let squareCategory: UInt32 = 0x1 << 2
    
    var planet: PlanetType?
    var balls: [SKShapeNode] = []
    
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self
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
