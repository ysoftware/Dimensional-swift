//
//  GameViewController.swift
//  https://github.com/ysoftware
//
//  Created by Ярослав Ерохин on 16.12.16.
//  Copyright © 2016 Yaroslav Erohin. All rights reserved.
//

import MessageUI
import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            AppDelegate.instance.viewController = self

            // debug information
            #if DEBUG
                view.showsFPS = true
                view.showsNodeCount = true
            #endif

            view.ignoresSiblingOrder = true
            let scene = LevelScene(size: view.frame.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    //email stuff

    func sendEmail() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients(["orderanapp@gmail.com"])
        return mailComposerVC
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
}
