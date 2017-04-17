//
//  SettingsNode.swift
//  https://github.com/ysoftware
//
//  Created by Ярослав Ерохин on 18.12.16.
//  Copyright © 2016 Yaroslav Erohin. All rights reserved.
//

import Foundation

/// Settings
class SettingsNode:SKShapeNode, SKButtonDelegate {
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // this will be our scene
    weak var delegate:AlertDelegate?

    // nodes
    var label:SKLabelNode!
    var okButton:SKButton!
    var soundButton:SKButton!
    var contactButton:SKButton!
    var webButton:SKButton!

    init(delegate:AlertDelegate) {
        super.init()

        self.strokeColor = .white
        self.fillColor = .black
        self.path = CGPath(rect: CGRect(x: -500, y: -300, width: 1000, height: 600), transform: nil)
        self.delegate = delegate
        self.isUserInteractionEnabled = true
        self.zPosition = 100

        // label set up
        label = SKLabelNode(text: "Made by https://github.com/ysoftware")
        addChild(label)
        label.fontSize = 30
        label.fontColor = .white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .top
        label.position = CGPoint(x: 0, y: 70)

        // buttons set up
        okButton = createButton(x: 0, y: -60, title: "ok")
        soundButton = createButton(x: -100, y: 0, title: "switch sound)")
        contactButton = createButton(x: 100, y: 20, title: "contact us")
        webButton = createButton(x:100, y: -20, title: "web site")
    }

    func createButton(x: CGFloat, y: CGFloat, title:String) -> SKButton {
        let button = SKButton(offTexture: SKTexture(imageNamed: "button2"), downTexture: SKTexture(imageNamed: "button"), text:title)
        addChild(button)
        button.position = CGPoint(x: x, y: y)
        button.delegate = self
        button.isUserInteractionEnabled = true
        return button
    }

    // restart button clicked
    func buttonUp(button: SKButton) {
        if button == soundButton {
            Values.isSoundEnabled = !Values.isSoundEnabled
        }
        else if button == contactButton {
            AppDelegate.instance.viewController.sendEmail()
        }
        else if button == webButton {
            UIApplication.shared.open(URL(string: "http://orderanapp.com")!, options: [:], completionHandler: nil)
        }

        delegate?.alertDidFinish(self)
        removeFromParent()
    }
    
}
