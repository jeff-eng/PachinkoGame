//
//  GameScene.swift
//  Project11
//
//  Created by Jeffrey Eng on 7/25/16.
//  Copyright (c) 2016 Jeffrey Eng. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        background.zPosition = -1
        addChild(background)
        // Sets the frame to be the walls of the scene with proper physics
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        // Assign current scene to be the physics world's delegate
        physicsWorld.contactDelegate = self
        
        for positionBouncer in 0...4 {
            makeBouncerAt(CGPoint(x: positionBouncer * (Int(frame.width) / 4), y: 0))
        }
        
        for positionSlot in 0...3 {
            if positionSlot % 2 == 0 {
                makeSlotAt(CGPoint(x: 128 + (positionSlot * 256), y: 0), isGood: true)
            } else {
                makeSlotAt(CGPoint(x: 128 + (positionSlot * 256), y: 0), isGood: false)
            }
        }
        
        // Create instance of SKLabelNode
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        // Set initial default text of label
        scoreLabel.text = "Score: 0"
        // Justify alignment of label to the right
        scoreLabel.horizontalAlignmentMode = .Right
        // Position of the label
        scoreLabel.position = CGPoint(x: 980, y: 700)
        // Add the score label node to the scene
        addChild(scoreLabel)
        
        // Add edit label to the scene
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Create ball "node" at location where user touched
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            
            let objects = nodesAtPoint(location) as [SKNode]
            
            if objects.contains(editLabel) {
                editingMode = !editingMode
            } else {
                if editingMode {
                    let size = CGSize(width: GKRandomDistribution(lowestValue: 16, highestValue: 128).nextInt(), height: 16)
                    let box = SKSpriteNode(color: RandomColor(), size: size)
                    box.zRotation = RandomCGFloat(min: 0, max: 3)
                    box.position = location
                    
                    box.physicsBody = SKPhysicsBody(rectangleOfSize: box.size)
                    box.physicsBody!.dynamic = false
                    
                    addChild(box)
                } else {
                    let ball = SKSpriteNode(imageNamed: "ballRed")
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    ball.physicsBody!.restitution = 0.4
                    ball.position = location
                    ball.name = "ball"
                    addChild(ball)
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func makeBouncerAt(position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody!.contactTestBitMask = bouncer.physicsBody!.collisionBitMask
        bouncer.physicsBody!.dynamic = false
        addChild(bouncer)
    }
    
    func makeSlotAt(position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        // Create instance of SKPhysicBody as rectangle and setting dynamic property to false so it doesn't move when colliding with other objects
        slotBase.physicsBody = SKPhysicsBody(rectangleOfSize: slotBase.size)
        slotBase.physicsBody!.dynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        // Set spinning action for the slotGlow sprites
        let spin = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 10)
        let spinForever = SKAction.repeatActionForever(spin)
        slotGlow.runAction(spinForever)
    }
    
    // When ball collides with something else
    func collisionBetweenBall(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroyBall(ball)
            score += 1
        } else if object.name == "bad" {
            destroyBall(ball)
            score -= 1
        }
    }
    
    // When finished with the ball and want to get rid of it; removeFromParent removes node from the scene
    func destroyBall(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "SparksParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.node!.name == "ball" {
            collisionBetweenBall(contact.bodyA.node!, object: contact.bodyB.node!)
        } else if contact.bodyB.node!.name == "ball" {
            collisionBetweenBall(contact.bodyB.node!, object: contact.bodyA.node!)
        }
    }
}
