//
//  GameOverNode.swift
//  https://github.com/ysoftware
//
//  Created by Ярослав Ерохин on 17.12.16.
//  Copyright © 2016 Yaroslav Erohin. All rights reserved.
//

import Foundation

/// methods for our scene to call
protocol AlertDelegate: class {
    /// this will get called when alert button is clicked
    func alertDidFinish(_ alert:SKShapeNode)
}

// The SKNode class is the fundamental building block of most SpriteKit content.

/// Alert node to show game over message.
class AlertNode:SKShapeNode, SKButtonDelegate {
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // this will be our scene
    weak var delegate:AlertDelegate?

    // nodes
    var label:SKLabelNode!
    var button:SKButton!

    init(delegate:AlertDelegate, text:String) {
        super.init()

        self.strokeColor = .white
        self.fillColor = .black
        self.path = CGPath(rect: CGRect(x: -200, y: -100, width: 400, height: 200), transform: nil)
        self.delegate = delegate
        self.isUserInteractionEnabled = true
        self.zPosition = 100

        // label set up
        label = SKLabelNode(text: text)
        addChild(label)
        label.fontSize = 30
        label.fontColor = .white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .top
        label.position = CGPoint(x: 0, y: 50)

        // button set up
        button = SKButton(offTexture: SKTexture(imageNamed: "button2"), downTexture: SKTexture(imageNamed: "button"), text:"Restart")
    
        addChild(button)
        button.position = CGPoint(x: 0, y: -50)
        button.delegate = self
        button.isUserInteractionEnabled = true
        button.zPosition = 10
    }

    // restart button clicked
    func buttonUp(button: SKButton) {
        delegate?.alertDidFinish(self)
        removeFromParent()
    }

}
