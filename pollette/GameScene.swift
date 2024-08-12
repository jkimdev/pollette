//
//  GameScene.swift
//  pollette
//
//  Created by 김재민 on 7/31/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let planets = ["earth", "moon", "mustafar", "uranus"]
    let imageNode = SKSpriteNode()
    let numberNode = SKLabelNode(text: "2")
    let ballLabel = SKLabelNode()
    var planetIdx: Int = 0
    var numberOfPlayer = 2
    var balls: [UIColor] = [.red, .orange]
    var colorSet: [UIColor] = [.green, .purple]
    override func sceneDidLoad() {
        guard let screenWidth = self.scene?.frame.width else { return }
        guard let screenHeight = self.scene?.frame.height else { return }
        

        
        imageNode.size = .init(width: 96, height: 96)
        imageNode.position.y = screenHeight / 4
        addChild(imageNode)
        
        let gravityLabel = SKLabelNode(text: "Gravity")
        gravityLabel.fontName = "Galmuri11-Bold"
        gravityLabel.fontSize = 48
        let gravityLabelConstraint = SKConstraint.positionY(SKRange(constantValue: imageNode.position.y + 100))
        gravityLabel.constraints = [gravityLabelConstraint]
        addChild(gravityLabel)

        let earthNode = SKSpriteNode(imageNamed: "earth")
        earthNode.name = "earth"
        earthNode.size = .init(width: 120, height: 120)
        imageNode.addChild(earthNode)
        
        let chevronLeft = UIImage(named: "arrowtriangle.left")
        let leftTexture = SKTexture(image: chevronLeft!)
        
        let leftNode = SKSpriteNode(texture: leftTexture)
        leftNode.name = "left"
        let leftButtonConstraint = SKConstraint.positionX(SKRange(constantValue: imageNode.position.x - 200))
        let leftYConstraint = SKConstraint.positionY(SKRange(constantValue: imageNode.position.y))
        leftNode.constraints = [leftButtonConstraint, leftYConstraint]
        addChild(leftNode)
        
        let chevronRight = UIImage(named: "arrowtriangle.right")
        let rightTexture = SKTexture(image: chevronRight!)
        
        let rightNode = SKSpriteNode(texture: rightTexture)
        rightNode.name = "right"
        let rightButtonConstraint = SKConstraint.positionX(SKRange(constantValue: imageNode.position.x + 200))
        let rightYConstraint = SKConstraint.positionY(SKRange(constantValue: imageNode.position.y))
        rightNode.constraints = [rightButtonConstraint, rightYConstraint]
        addChild(rightNode)
        
        numberNode.text = String(numberOfPlayer)
        numberNode.fontSize = 48
        numberNode.verticalAlignmentMode = .center
        let numberNodeConstraint = SKConstraint.positionY(SKRange(constantValue: imageNode.position.y - 300))
        numberNode.constraints = [numberNodeConstraint]
        addChild(numberNode)
        
        let playerLabel = SKLabelNode(text: "Players")
        playerLabel.fontName = "Galmuri11-Bold"
        playerLabel.fontSize = 48
        let gplayerLabelConstraint = SKConstraint.positionY(SKRange(constantValue: numberNode.position.y + 100))
        playerLabel.constraints = [gplayerLabelConstraint]
        addChild(playerLabel)

        let decreaseImage = UIImage(named: "minus.circle")
        let decreaseTexture = SKTexture(image: decreaseImage!)
        let decreaseNode = SKSpriteNode(texture: decreaseTexture)
        decreaseNode.name = "decrease"
        let decreaseNodeConstraint = SKConstraint.positionX(SKRange(constantValue: numberNode.position.x - 200))
        let decreaseNodeYConstraint = SKConstraint.positionY(SKRange(constantValue: imageNode.position.y - 300))
        decreaseNode.constraints = [decreaseNodeConstraint, decreaseNodeYConstraint]
        addChild(decreaseNode)

        let increaseImage = UIImage(named: "plus.circle")
        let increaseNodeTexture = SKTexture(image: increaseImage!)
        let increaseNode = SKSpriteNode(texture: increaseNodeTexture)
        increaseNode.name = "increase"
        let increaseNodeNodeConstraint = SKConstraint.positionX(SKRange(constantValue: numberNode.position.x + 200))
        let increaseNodeYConstraint = SKConstraint.positionY(SKRange(constantValue: imageNode.position.y - 300))
        increaseNode.constraints = [increaseNodeNodeConstraint, increaseNodeYConstraint]
        addChild(increaseNode)
        
        numberNode.addChild(ballLabel)
        for i in 0 ..< balls.count {
            let ball = SKShapeNode(circleOfRadius: 12)
            ball.fillColor = balls[i]
            ball.position.x = CGFloat(i * 48)
            ballLabel.addChild(ball)
        }
        
        let ballLabelYConstraint = SKConstraint.positionY(SKRange(constantValue: numberNode.position.y - 100))
        ballLabel.constraints = [ballLabelYConstraint]
        ballLabel.position.x = -24
        
        let playButton = SKShapeNode(rectOf: .init(width: 450, height: 96), cornerRadius: 16)
        playButton.name = "playButton"
        playButton.fillColor = .systemMint
        playButton.strokeColor = .white

        let playLabel = SKLabelNode(text: "START")
        playLabel.fontSize = 48
        playLabel.fontName = "Galmuri11-Bold"
        playLabel.verticalAlignmentMode = .center
        
        addChild(playButton)
        playButton.addChild(playLabel)
        
        let playButtonConstraint = SKConstraint.positionY(SKRange(constantValue: ballLabel.position.y - 300))
        playButton.constraints = [playButtonConstraint]
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        if touchedNode.name == "right" {
            rightButtonAction()
            return
        }
        if touchedNode.name == "left" {
            leftButtonAction()
            return
        }
        if touchedNode.name == "increase" {
            increaseButtonAction()
            return
        }
        if touchedNode.name == "decrease" {
            decreaseButtonAction()
            return
        }
        if touchedNode.name == "playButton" {
            print("playButton")
            guard let skView = self.view else { return }
            let newScene = PlayScene(size: skView.frame.size)
            newScene.scaleMode = .aspectFill
            self.view?.presentScene(newScene)
        }
    }
    
    private func rightButtonAction() {
        imageNode.removeAllChildren()
        planetIdx += 1
        let planetName = planets[planetIdx % planets.count]
        let planetNode = SKSpriteNode(imageNamed: planetName)
        planetNode.name = planetName
        planetNode.size = .init(width: 120, height: 120)
        imageNode.addChild(planetNode)
    }
    
    private func leftButtonAction() {
        imageNode.removeAllChildren()
        planetIdx -= 1
        let planetName = planets[abs(planetIdx % planets.count)]
        let planetNode = SKSpriteNode(imageNamed: planetName)
        planetNode.name = planetName
        planetNode.size = .init(width: 96, height: 96)
        imageNode.addChild(planetNode)
    }
    
    private func increaseButtonAction() {
        numberOfPlayer += 1
        if numberOfPlayer >= 5 {
            numberOfPlayer -= 1
            return
        }
        numberNode.text = String(numberOfPlayer)
        addBall(index: numberOfPlayer - 3)
    }
    
    private func decreaseButtonAction() {
        numberOfPlayer -= 1
        if numberOfPlayer < 2 {
            numberOfPlayer += 1
            return
        }
        numberNode.text = String(numberOfPlayer)
        removeBall()
    }
    
    private func addBall(index: Int) {
        balls.append(colorSet[index])
        let ball = SKShapeNode(circleOfRadius: 12)
        ball.fillColor = colorSet[index]
        ball.position.x = CGFloat((balls.count - 1) * 48)
        ballLabel.addChild(ball)
        ballLabel.position.x -= 24
    }
    
    private func removeBall() {
        balls.removeLast()
        ballLabel.children.last?.removeFromParent()
        ballLabel.position.x += 24
    }
}
