//
//  Enemy.swift
//  https://github.com/ysoftware
//
//  Created by Ярослав Ерохин on 16.12.16.
//  Copyright © 2016 Yaroslav Erohin. All rights reserved.
//

import SpriteKit

class Enemy:SKSpriteNode {
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    var enemySpeed:CGFloat = 0

    init(at position:CGPoint, addTo node:SKNode, texture:String = "triangle", speed:CGFloat = 250, color:UIColor = .green) {
        super.init(texture: SKTexture(imageNamed: texture),
                   color: color,
                   size: CGSize(width: 30, height: 30))

        // setup node
        colorBlendFactor = 1
        node.addChild(self)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = position
        enemySpeed = speed
        
        setupPhysics()
    }

    func setupPhysics() {
        // set up physics for contact
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.contactTestBitMask = Collision.projectile | Collision.player
        self.physicsBody?.collisionBitMask = Collision.none
        self.physicsBody?.categoryBitMask = Collision.enemy
        self.physicsBody?.usesPreciseCollisionDetection = true
    }

    func move(withPlayerPosition playerPosition:CGPoint, time:TimeInterval) {
        // calculate angle to player position
        let dY = Float(playerPosition.y-self.position.y)
        let dX = Float(playerPosition.x-self.position.x)
        let angle = CGFloat(atan2f(dY, dX))

        // calculate velocity
        let angleMultiplier = pointAroundCircumference(fromCenter: .zero, radius:1, angle: angle)
        let velocity = CGPoint(x: angleMultiplier.x * enemySpeed * CGFloat(time),
                               y: angleMultiplier.y * enemySpeed * CGFloat(time))

        // update position and rotation
        self.position += velocity
        self.zRotation = angle
    }

    func die() {
        // remove physics
        self.physicsBody = nil

        // death animations
        let fadeout = SKAction.fadeOut(withDuration: 0.4)
        let scale = SKAction.scale(by: 3, duration: 0.4)
        let color = SKAction.colorize(with: .white, colorBlendFactor: 1, duration: 0.4)

        // group animation
        let animations = SKAction.group([fadeout, scale, color])
        animations.timingMode = .easeInEaseOut

        // run
        run(animations) { 
            self.removeFromParent()
        }
    }

}
