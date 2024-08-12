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
        
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height
        
        
        self.physicsWorld.gravity = .init(dx: 0, dy: -0.2)
        
        leftGround(view: view)
        rightGround(view: view)
        addBoxes(view: view)
        
        let spinner = SKShapeNode(rectOf: .init(width: screenWidth / 2, height: 10))
        spinner.physicsBody = SKPhysicsBody(rectangleOf: .init(width: screenWidth / 2, height: 10))
        spinner.position = .init(x: screenWidth / 2, y: screenHeight / 2)
        spinner.fillColor = .red
        spinner.physicsBody?.angularVelocity = .pi
        spinner.physicsBody?.isDynamic = false
        spinner.physicsBody?.angularDamping = 0.5
        
        let rotateAction = SKAction.rotate(byAngle: .pi, duration: .pi)
        let repeatAction = SKAction.repeatForever(rotateAction)
        
        addChild(spinner)
        spinner.run(repeatAction)
        
        for i in 1 ..< 5 {
            let ball = SKShapeNode(circleOfRadius: 6)
            ball.physicsBody = SKPhysicsBody(circleOfRadius: 6)
            ball.position = .init(x: CGFloat(screenWidth / 2) + CGFloat(i), y: screenHeight * 0.9)
            ball.physicsBody?.restitution = 0.5
            balls.append(ball)
        }
        balls.forEach { addChild($0) }
    }
    
    private func addBall(view: SKView) {
    }
    
    private func rightGround(view: SKView) {
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height

        var points = [CGPoint(x: screenWidth / 1.25, y: 0),
                      CGPoint(x: screenWidth / 8, y: -50),
                      CGPoint(x: screenWidth * 0.02, y: -100)]
        
        let ground = SKShapeNode(splinePoints: &points, count: points.count)
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.position = .init(x: screenWidth / 2, y: 100)
        ground.physicsBody?.restitution = 0.5
        ground.physicsBody?.friction = 0
        
        ground.physicsBody?.collisionBitMask = ballCategory
        ground.physicsBody?.contactTestBitMask = ballCategory
        
        self.addChild(ground)
    }
    
    private func leftGround(view: SKView) {
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height

        var points = [CGPoint(x: -screenWidth / 1.25, y: 0),
                      CGPoint(x: -screenWidth / 8, y: -50),
                      CGPoint(x: -screenWidth * 0.02, y: -100)]
        
        let ground = SKShapeNode(splinePoints: &points, count: points.count)
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.position = .init(x: screenWidth / 2, y: 100)
        ground.physicsBody?.restitution = 0.5
        
        ground.physicsBody?.collisionBitMask = ballCategory
        ground.physicsBody?.contactTestBitMask = ballCategory
        
        self.addChild(ground)
    }
    
    private func addBoxes(view: SKView) {
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height

        for i in -2 ..< 3 {
            let box = SKShapeNode(rectOf: .init(width: 24, height: 2))
            box.physicsBody = SKPhysicsBody(rectangleOf: .init(width: 24, height: 2))
            box.position = .init(x: CGFloat(screenWidth / 2) - CGFloat(i*48), y: screenHeight * 0.8)
            box.fillColor = .red
            box.physicsBody?.angularVelocity = .pi
            box.physicsBody?.isDynamic = false
            
            
            addChild(box)
        }
        
        for i in -2 ..< 3 {
            let box = SKShapeNode(rectOf: .init(width: 24, height: 2))
            box.physicsBody = SKPhysicsBody(rectangleOf: .init(width: 24, height: 2))
            box.position = .init(x: CGFloat(screenWidth / 2) - CGFloat(i*32), y: screenHeight * 0.7)
            box.fillColor = .red
            box.physicsBody?.angularVelocity = .pi
            box.physicsBody?.isDynamic = false

            addChild(box)
        }
    }
}
