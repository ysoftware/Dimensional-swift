//
//  Projectile.swift
//  https://github.com/ysoftware
//
//  Created by Ярослав Ерохин on 16.12.16.
//  Copyright © 2016 Yaroslav Erohin. All rights reserved.
//

import SpriteKit

/// The thing player fires with
class Projectile:SKSpriteNode {

    // direction
    var angle:CGFloat = 0

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    init(at position:CGPoint, angle:CGFloat, addTo node:SKNode) {
        super.init(texture: SKTexture(imageNamed: "projectile"),
                   color: .white,
                   size: CGSize(width: 5, height: 5))

        // setup node
        node.addChild(self)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = position
        self.angle = angle

        setupPhysics()
        expire()
    }

    func setupPhysics() {
        // set up physics for contact
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.contactTestBitMask = Collision.enemy
        self.physicsBody?.categoryBitMask = Collision.projectile
        self.physicsBody?.collisionBitMask = Collision.none
        self.physicsBody?.usesPreciseCollisionDetection = true
    }

    func move(time:TimeInterval) {
        // move in the direction
        let angleMultiplier = pointAroundCircumference(fromCenter: .zero, radius: 1, angle: angle)
        let velocity = CGPoint(x: angleMultiplier.x * Speed.projectile * CGFloat(time),
                               y: angleMultiplier.y * Speed.projectile * CGFloat(time))
        self.position += velocity
    }

    func die() {
        // remove physics
        self.physicsBody = nil

        // death animations
        let fadeout = SKAction.fadeOut(withDuration: 0.3)
        let scale = SKAction.scale(by: 0.1, duration: 0.3)

        // group animation
        let animations = SKAction.group([fadeout, scale])
        animations.timingMode = .easeInEaseOut

        // run
        run(animations) {
            self.removeFromParent()
        }
    }

    // disappear after 5 seconds when off screen
    func expire() {
        run(SKAction.wait(forDuration: 5)) {
            self.die()
        }
    }

}
