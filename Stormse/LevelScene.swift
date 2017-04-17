//
//  LevelScene.swift
//  https://github.com/ysoftware
//
//  Created by Ярослав Ерохин on 16.12.16.
//  Copyright © 2016 Yaroslav Erohin. All rights reserved.
//

import SpriteKit

class LevelScene: SKScene, SKPhysicsContactDelegate, AlertDelegate, SKButtonDelegate {
    // setup
    var _dt:CFTimeInterval = 0
    var _lastUpdateTime:CFTimeInterval = 0
    var sinceLastPlayerFire:CFTimeInterval = 0
    var sinceLastSpawn:CFTimeInterval = 0
    var state:GameState = .over

    var livesLeft = 0 {
        didSet {
            livesLabel.text = "\(livesLeft) lives left"
        }
    }

    var points = 0 {
        didSet {
            scoreLabel.text = "\(points) points"
        }
    }

    // joysticks
    var joystickRight:JCJoystick!
    var joystickLeft:JCJoystick!

    // nodes
    var player:Player!
    var panelForCharactersNode:SKNode! // panel for every character in the game
    var scoreLabel:SKLabelNode!
    var livesLabel:SKLabelNode!

    // alerts
    var settingsButton:SKButton!
    var gameoverNode:AlertNode!
    var settingsNode:SettingsNode!

    // add your sounds here
    let fireSoundAction = SKAction.playSoundFileNamed("playerfire.wav", waitForCompletion: false)
    let enemyDeathSoundAction = SKAction.playSoundFileNamed("enemydeath.wav", waitForCompletion: false)
    let playerDeathSoundAction = SKAction.playSoundFileNamed("die.wav", waitForCompletion: false)

    // MARK: - Life cycle

    override func didMove(to view: SKView) {
        super.didMove(to: view)

        // set up scene and pshysics
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        backgroundColor = .black
        anchorPoint = CGPoint(x: 0.5, y: 0.5)

        // joysticks
        let joystickRadius:Float = 80
        joystickRight = JCJoystick(controlRadius: joystickRadius,
                                   baseRadius: joystickRadius,
                                   baseColor: SKColor(red: 1, green: 1, blue: 1, alpha: 0.1),
                                   joystickRadius: joystickRadius/3,
                                   joystickColor: SKColor(red: 1, green: 1, blue: 1, alpha: 0.4))
        joystickLeft = JCJoystick(controlRadius: joystickRadius,
                                  baseRadius: joystickRadius,
                                  baseColor: SKColor(red: 1, green: 1, blue: 1, alpha: 0.1),
                                  joystickRadius: joystickRadius/3,
                                  joystickColor: SKColor(red: 1, green: 1, blue: 1, alpha: 0.4))

        joystickRight.position = CGPoint(x:size.width/4, y:-size.height/4)
        joystickLeft.position = CGPoint(x:-size.width/4, y:-size.height/4)
        self.addChild(joystickRight)
        self.addChild(joystickLeft)

        // score label
        scoreLabel = SKLabelNode(text: "0")
        addChild(scoreLabel)
        scoreLabel.fontSize = 45
        scoreLabel.fontColor = .white
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: size.width/2 - 5, y: size.height/2 - 5)

        // lives left label
        livesLabel = SKLabelNode(text: "0")
        addChild(livesLabel)
        livesLabel.fontSize = 30
        livesLabel.fontColor = .white
        livesLabel.horizontalAlignmentMode = .left
        livesLabel.verticalAlignmentMode = .top
        livesLabel.position = CGPoint(x: -size.width/2 + 5, y: size.height/2 - 5)

        // background
        let backgroundNode = SKSpriteNode(imageNamed: "background")
        addChild(backgroundNode)
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundNode.position = .zero
        backgroundNode.zPosition = -1

        // button settings
        settingsButton = SKButton(offTexture: SKTexture(imageNamed: "settings"), downTexture: SKTexture(imageNamed: "settings"), text:" ")
        addChild(settingsButton)
        settingsButton.position = CGPoint(x: 0, y: -size.height/2 + 25)
        settingsButton.size = CGSize(width: 35, height: 35)
        settingsButton.delegate = self
        settingsButton.isUserInteractionEnabled = true
        settingsButton.zPosition = 10

        // alerts
        gameoverNode = AlertNode(delegate: self, text: "Game over. You got \(points) points!")
        settingsNode = SettingsNode(delegate: self)

        // panel for game entities
        panelForCharactersNode = SKNode()
        addChild(panelForCharactersNode)

        player = Player(addTo: panelForCharactersNode)
        
        newGame()
    }

    // gameplay cycle
    func newGame() {
        state = .playing
        points = 0
        livesLeft = Constants.lives

        player.position = .zero
        player.reset()
    }

    func gameOver() {
        state = .over

        addChild(gameoverNode)
        gameoverNode.position = .zero
    }

    func pause(_ paused:Bool) {
        state = paused ? .pause : .playing
    }

    func alertDidFinish(_ alert:SKShapeNode) {
        alert.removeFromParent()

        if alert == gameoverNode { // game over panel disappeared
            newGame()
        }
        else if alert == settingsNode { // settings node closed
            pause(false)
        }
    }

    func buttonUp(button: SKButton) {
        if button == settingsButton {
            // settings button clicked
            pause(true)
            addChild(settingsNode)
        }
    }

    // update loop
    override func update(_ currentTime: TimeInterval) {
        let _dt = min(1.0/30, currentTime - _lastUpdateTime)
        _lastUpdateTime = currentTime

        guard state == .playing else { return }

        // movement
        if (joystickLeft.x != 0 || joystickLeft.y != 0) {
            let area = CGRect(x: -view!.frame.width/2, y: -view!.frame.height/2, width: view!.frame.width, height: view!.frame.height)
            player.move(direction: CGPoint(x: Double(joystickLeft.x), y: Double(joystickLeft.y)), time: _dt, in: area)
        }

        for node in panelForCharactersNode.children {
            if let enemy = node as? Enemy {
                enemy.move(withPlayerPosition: player.position, time: _dt)
            }
            else if let projectile = node as? Projectile {
                projectile.move(time: _dt)
            }
        }

        // player fire timer
        sinceLastPlayerFire += _dt
        if sinceLastPlayerFire > Speed.fireRate {
            playerFire()
        }

        // spawn timer
        sinceLastSpawn += _dt
        if sinceLastSpawn > Speed.spawnRate {
            spawnEnemy()
        }
    }

    func playerFire() {
        if (joystickRight.x != 0 && joystickRight.y != 0){
            sinceLastPlayerFire = 0
            let joystickPoint = CGPoint(x: CGFloat(joystickRight.x), y: CGFloat(joystickRight.y))
            let angle = joystickPoint.angle
            player.zRotation = angle

            _ = Projectile(at: player.position, angle: angle, addTo: panelForCharactersNode)

            // play sound
            if Values.isSoundEnabled {
                self.run(fireSoundAction)
            }
        }
    }

    // spawn every x seconds
    func spawnEnemy() {
        sinceLastSpawn = 0
        let position = CGPoint.random(around: player.position, distance: 450)

        // for 10 different enemies you can create random number from 0 to 9
        // then switch between this number and create enemy
        // let random = arc4random()9 (not sure)
        // if random == 0 { create enemy 1 }
        // else if random == 1 { create enemy 2 }
        // ...

        let randomNumbersRemainder = arc4random()%3
        if randomNumbersRemainder == 2 {
            _ = Enemy(at: position, addTo: panelForCharactersNode, texture: "rectangle", speed: 100, color: .blue)
        }
        else if randomNumbersRemainder == 1 {
            _ = Enemy(at: position, addTo: panelForCharactersNode, texture: "triangle", speed: 200, color: .green)
        }
        else {
            _ = Enemy(at: position, addTo: panelForCharactersNode, texture: "pentagon", speed: 300, color: .red)
        }
    }

    // collision
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody

        // sort bodies
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        if firstBody.categoryBitMask == Collision.enemy &&
            secondBody.categoryBitMask == Collision.projectile {
            // enemy hit by projectile
            if let enemyNode = firstBody.node as? Enemy,
                let projectileNode = secondBody.node as? Projectile {
                points += 1

                enemyNode.die()
                projectileNode.die()

                if Values.isSoundEnabled {
                    run(enemyDeathSoundAction)
                }
            }
        }
        else if firstBody.categoryBitMask == Collision.player &&
            secondBody.categoryBitMask == Collision.enemy {
            // player hit by enemy
            if let enemyNode = secondBody.node as? Enemy {
                enemyNode.die()
                run(playerDeathSoundAction)

                if livesLeft == 0 {
                    player.die()
                    gameOver()
                }
                else {
                    livesLeft -= 1
                }
            }
        }
    }

}
