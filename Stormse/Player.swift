//
//  Player.swift
//  https://github.com/ysoftware
//
//  Created by Ярослав Ерохин on 16.12.16.
//  Copyright © 2016 Yaroslav Erohin. All rights reserved.
//

import SpriteKit

class Player:SKSpriteNode {
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    init(addTo scene:SKNode) {
        super.init(texture: SKTexture(imageNamed: "player"),
                   color: .white,
                   size: CGSize(width: 30, height: 30))

        scene.addChild(self)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = .zero
        
        setupPhysics()
    }

    func setupPhysics() {
        // set up physics for contact
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.contactTestBitMask = Collision.enemy
        self.physicsBody?.collisionBitMask = Collision.none
        self.physicsBody?.categoryBitMask = Collision.player
        self.physicsBody?.usesPreciseCollisionDetection = true
    }

    func move(direction:CGPoint, time:TimeInterval, in area: CGRect) {
        // move with direction
        let oldPosition = position
        let velocity = CGPoint(x: direction.x * Speed.player * CGFloat(time),
                               y: direction.y * Speed.player * CGFloat(time))
        position += velocity

        if !area.contains(frame) {
            position = oldPosition
        }
    }

    func die() {
        // death animations
        let fadeout = SKAction.fadeOut(withDuration: 0.4)
        let scale = SKAction.scale(by: 3, duration: 0.4)

        // group animation
        let animations = SKAction.group([fadeout, scale])
        animations.timingMode = .easeInEaseOut

        // run
        run(animations)
    }

    func reset() {
        // bring player back to life
        alpha = 1
        setScale(1)
    }

}
