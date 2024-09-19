//
//  PlayScene.swift
//  pollette
//
//  Created by 김재민 on 8/10/24.
//

import SpriteKit
import GameplayKit
import GoogleMobileAds

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
    
    var duration: CGFloat {
        switch self {
        case .earth:
            return 1
        case .moon:
            return 2.5
        case .mustafar:
            return 3
        case .uranus:
            return 1.5
        }
    }
    
    var caption: String {
        switch self {
        case .earth:
            "창백한 푸른 점."
        case .moon:
            "FLY ME TO THE MOON."
        case .mustafar:
            "IT'S OVER ANAKIN."
        case .uranus:
            "천왕성, 얼음 거인."
        }
    }
}

class PlayScene: SKScene, SKPhysicsContactDelegate, GADFullScreenContentDelegate {
    private var interstitial: GADInterstitialAd?
    
    let ballCategory: UInt32 = 0x1 << 0
    let groundCategory: UInt32 = 0x1 << 1
    let squareCategory: UInt32 = 0x1 << 2
    let blackholeCatetory: UInt32 = 0x1 << 3
    
    var planet: PlanetType?
    var numberOfBalls: Int?
    var balls: [SKShapeNode] = []
    var ballColors: [UIColor] = [.red, .orange, .green, .purple, .yellow, .systemMint, .magenta, .blue]
    
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.restitution = 0.8
        
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-2415988675881853/9585562277", request: GADRequest()) { ad, error in
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
        }
    }
    
    override func didMove(to view: SKView) {
        
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height
        
        
        self.physicsWorld.gravity = .init(dx: 0, dy: planet!.gravity)
        
        let cameraNode = SKCameraNode()
        
        cameraNode.name = "winnerCameara"
        cameraNode.position = .init(x: screenWidth / 2, y: screenHeight / 2)
        
        scene?.addChild(cameraNode)
        scene?.camera = cameraNode
        
        
        leftGround(view: view)
        rightGround(view: view)
        addBoxes(view: view)
        addBlackhole(view: view)
        createCaption(view: view)
        
        let spinner = SKShapeNode(rectOf: .init(width: screenWidth / 2.5, height: 10))
        spinner.physicsBody = SKPhysicsBody(rectangleOf: .init(width: screenWidth / 2.5, height: 10))
        spinner.position = .init(x: screenWidth / 2, y: 0)
        spinner.fillColor = .clear
        spinner.physicsBody?.isDynamic = false
        //        spinner.physicsBody?.restitution = 0.5
        spinner.physicsBody?.angularDamping = .pi
        spinner.physicsBody?.angularVelocity = .pi
        spinner.physicsBody?.restitution = 0.8
        spinner.physicsBody?.mass = 9
        
        let rotateAction = SKAction.rotate(byAngle: .pi, duration: planet!.duration)
        let repeatAction = SKAction.repeatForever(rotateAction)
        
        addChild(spinner)
        spinner.run(repeatAction)
        
        for i in 0 ..< numberOfBalls! {
            let ball = SKShapeNode(circleOfRadius: 6)
            ball.fillColor = ballColors[i]
            ball.physicsBody = SKPhysicsBody(circleOfRadius: 6)
            ball.position = .init(x: CGFloat(screenWidth / 2) + CGFloat(i), y: screenHeight * 0.9)
            ball.physicsBody?.mass = 0.1
            balls.append(ball)
        }
        balls.shuffle()
        balls.forEach { addChild($0) }
    }
    
    private func rightGround(view: SKView) {
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height
        
        var points = [CGPoint(x: 0, y: screenHeight),
                      CGPoint(x: 0, y: screenHeight * 0.2),
                      CGPoint(x: screenWidth * -0.2, y: screenHeight * 0.1),
                      CGPoint(x: screenWidth * -0.35, y: screenHeight * 0.08),
                      CGPoint(x: screenWidth * -0.46, y: screenHeight * 0.06),
                      CGPoint(x: screenWidth * -0.46, y: -screenHeight * 0.5)]
        
        let ground = SKShapeNode(points: &points, count: points.count)
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.position = .init(x: screenWidth, y: 0)
        ground.physicsBody?.restitution = 0.8
        
        self.addChild(ground)
    }
    
    private func leftGround(view: SKView) {
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height
        
        var points = [CGPoint(x: 0, y: screenHeight),
                      CGPoint(x: 0, y: screenHeight * 0.2),
                      CGPoint(x: screenWidth * 0.2, y: screenHeight * 0.1),
                      CGPoint(x: screenWidth * 0.35, y: screenHeight * 0.08),
                      CGPoint(x: screenWidth * 0.46, y: screenHeight * 0.06),
                      CGPoint(x: screenWidth * 0.46, y: -screenHeight * 0.5)]
        
        let ground = SKShapeNode(points: &points, count: points.count)
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.physicsBody?.restitution = 0.8
        
        self.addChild(ground)
    }
    
    private func addBlackhole(view: SKView) {
        let screenWidth = view.frame.width
        
        let blackholeImage = UIImage(named: "blackhole")
        let blackholeTexture = SKTexture(image: blackholeImage!)
        let blackhole = SKSpriteNode(texture: blackholeTexture)
        blackhole.physicsBody = SKPhysicsBody(texture: blackholeTexture, size: .init(width: 48, height: 48))
        blackhole.physicsBody?.isDynamic = false
        blackhole.position = .init(x: screenWidth / 2, y: 12)
        
        blackhole.physicsBody?.collisionBitMask = ballCategory
        blackhole.physicsBody?.contactTestBitMask = ballCategory
        addChild(blackhole)
        
    }
    
    private func addBoxes(view: SKView) {
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height
        let boxSize = screenWidth / 24
        
        for i in -5 ..< 6 {
            let box = SKShapeNode(rectOf: .init(width: boxSize, height: boxSize))
            box.physicsBody = SKPhysicsBody(rectangleOf: .init(width: boxSize, height: boxSize))
            box.position = .init(x: CGFloat(screenWidth / 2) - CGFloat(i) * boxSize * 1.95 , y: screenHeight * 0.4)
            box.fillColor = .clear
            box.zRotation = CGFloat.random(in: -1 ... 1)
            box.physicsBody?.isDynamic = false
            //            box.physicsBody?.affectedByGravity = false
            box.physicsBody?.angularDamping = .pi
            box.physicsBody?.angularVelocity = .pi
            box.physicsBody?.restitution = 0.2
            
            addChild(box)
        }
        
        for i in -4 ..< 5 {
            let box = SKShapeNode(rectOf: .init(width: boxSize, height: boxSize))
            box.physicsBody = SKPhysicsBody(rectangleOf: .init(width: boxSize, height: boxSize))
            box.position = .init(x: CGFloat(screenWidth / 2) - CGFloat(i) * boxSize * 1.9 , y: screenHeight * 0.3)
            box.fillColor = .clear
            box.zRotation = CGFloat.random(in: -1 ... 1)
            box.physicsBody?.isDynamic = false
            //            box.physicsBody?.affectedByGravity = false
            box.physicsBody?.angularDamping = .pi
            box.physicsBody?.angularVelocity = .pi
            box.physicsBody?.restitution = 0.2
            
            addChild(box)
        }
        
        for i in -5 ..< 6 {
            let radius = CGFloat.random(in: 4 ... 6)
            let box = SKShapeNode(circleOfRadius: radius)
            box.physicsBody = SKPhysicsBody(circleOfRadius: radius)
            box.position = .init(x: CGFloat(screenWidth / 2) - CGFloat(i*i), y: screenHeight * 0.7)
            box.fillColor = .white
            box.physicsBody?.isDynamic = true
            box.physicsBody?.affectedByGravity = true
            box.physicsBody?.mass = CGFloat(i*Int.random(in: 1 ... 10))
            
            addChild(box)
        }
    }
    
    func createCaption(view: SKView) {
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height
        
        let caption = SKLabelNode(text: planet?.caption)
        caption.name = "playLabel"
        caption.fontSize = 24
        caption.fontName = "Galmuri11-Bold"
        caption.position = .init(x: screenWidth / 2, y: screenHeight * 0.8)
        
        addChild(caption)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.collisionBitMask == ballCategory || bodyB.collisionBitMask == blackholeCatetory {
            bodyB.node?.removeFromParent()
            balls.removeAll(where: { $0.physicsBody == bodyB.node?.physicsBody})
            if balls.count == 1 {
                bodyA.node?.removeFromParent()
                balls.first?.physicsBody?.affectedByGravity = false
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        if balls.count == 1 {
            let zoomInAction = SKAction.scale(to: 0.3, duration: 1.5)
            scene?.camera?.position = balls.first!.position
            scene?.camera?.run(zoomInAction)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if balls.count == 1 {
            removeFromParent()
            removeAllChildren()
            removeAllActions()
            if let viewController = self.view?.window?.rootViewController {
                showAd(from: viewController)
            }
        }
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        let scene = GameScene(fileNamed: "GameScene")!
        scene.scaleMode = .aspectFill
        self.view?.presentScene(scene, transition: .fade(withDuration: 1))
        print("Ad did dismiss full screens content.")
    }
    
    func showAd(from viewController: UIViewController) {
        guard let interstitial = interstitial else {
            let scene = GameScene(fileNamed: "GameScene")!
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: .fade(withDuration: 1))
            return print("Ad wasn't ready")
        }
        interstitial.present(fromRootViewController: viewController)
    }
}
