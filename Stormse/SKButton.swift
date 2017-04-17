//
//  SKButton.swift
//  Balance
//
//  Created by CraigGrummitt on 4/09/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//
import SpriteKit

@objc protocol SKButtonDelegate: class {
    @objc optional func buttonDown(button:SKButton)
    @objc optional func buttonUp(button:SKButton)
    @objc optional func buttonDownCancel(button:SKButton)
}

class SKButton: SKSpriteNode {
    var offTexture:SKTexture
    var downTexture:SKTexture
    var text:String
    var delegate:SKButtonDelegate?
    var buttonLabel:SKLabelNode!
    
    var buttonDown:Bool = false {
        didSet {
            buttonLabel.fontColor = buttonDown ? .black : .white
        }
    }

    init(offTexture:SKTexture,downTexture:SKTexture,text:String="",labelPos:CGPoint=CGPoint(x:0,y:-10)) {
        self.offTexture=offTexture
        self.downTexture=downTexture
        self.text=text
        super.init(texture: offTexture, color: .clear, size: offTexture.size())
        if (text != "") {
            buttonLabel = SKLabelNode()
            buttonLabel.text = "\(text)"
            buttonLabel.zPosition=1
            buttonLabel.fontSize = 35
            buttonLabel.fontColor = .white
            buttonLabel.verticalAlignmentMode = .center
            buttonLabel.position = labelPos
            self.addChild(buttonLabel)
        }
        self.isUserInteractionEnabled=true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        self.texture = downTexture
        buttonDown = true
        self.delegate?.buttonDown?(button: self)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        if (buttonDown) {
            super.touchesEnded(touches, with: event)
            self.texture = offTexture
            self.delegate?.buttonUp?(button: self)
            buttonDown=false
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)

        self.texture = offTexture
        self.delegate?.buttonDownCancel?(button: self)
        buttonDown=false
    }


    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        if (buttonDown) {
            let touch = touches.first!
            let positionInScene = touch.location(in: self.parent!)
            if (!self.contains(positionInScene)) {
                touchesCancelled(touches, with: event)
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
