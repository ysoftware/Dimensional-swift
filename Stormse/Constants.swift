//
//  Constants.swift
//  https://github.com/ysoftware
//
//  Created by Ярослав Ерохин on 16.12.16.
//  Copyright © 2016 Yaroslav Erohin. All rights reserved.
//

import Foundation

struct Speed {
    // units
    static let player:CGFloat = 350
    static let projectile:CGFloat = 900

    // seconds
    static let fireRate:TimeInterval = 0.15
    static let spawnRate:TimeInterval = 2
}

// settings
struct Constants {
    static let lives = 5
}

struct Values {
    // Setting for sound
    static var isSoundEnabled:Bool {
        get {
            return UserDefaults.standard.value(forKey: "isSoundEnabled") as? Bool ?? true
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "isSoundEnabled")
            UserDefaults.standard.synchronize()
        }
    }
}

/// A mask that defines which categories of bodies cause intersection notifications with this physics body.
struct Collision {
    static let none : UInt32 = 0
    static let player  : UInt32 = 0b1
    static let enemy: UInt32 = 0b10
    static let projectile: UInt32 = 0b100
}

/// State of the current game.
enum GameState {
    case over
    case playing
    case pause
}
