//
//  GameScene.swift
//  Project11
//
//  Created by Jeffrey Eng on 7/25/16.
//  Copyright (c) 2016 Jeffrey Eng. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        background.zPosition = -1
        addChild(background)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        
        for positionBouncer in 0...4 {
            makeBouncerAt(CGPoint(x: positionBouncer * (Int(frame.width) / 4), y: 0))
        }
        
        for index in 0...3 {
            if index % 2 == 0 {
                makeSlotAt(CGPoint(x: 128 + (index * 256), y: 0), isGood: true)
            } else {
                makeSlotAt(CGPoint(x: 128 + (index * 256), y: 0), isGood: false)
            }
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            let ball = SKSpriteNode(imageNamed: "ballRed")
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            ball.physicsBody!.restitution = 0.4
            ball.position = location
            addChild(ball)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func makeBouncerAt(position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody!.dynamic = false
        addChild(bouncer)
    }
    
    func makeSlotAt(position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
        }
        
        slotBase.position = position
        addChild(slotBase)
    }
    
}
