//
//  Utilities.swift
//  https://github.com/ysoftware
//
//  Created by Ярослав Ерохин on 16.12.16.
//  Copyright © 2016 Yaroslav Erohin. All rights reserved.
//

import CoreGraphics
import SpriteKit
import Foundation

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / .pi }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

extension Array {
    mutating func remove<T>(object: T) where T : Equatable {
        self = self.filter({$0 as? T != object})
    }
}

func pointAroundCircumference(fromCenter center:CGPoint, radius:CGFloat, angle:CGFloat) -> CGPoint {
    var point:CGPoint = .zero
    point.x = center.x + radius * cos(angle)
    point.y = center.y + radius * sin(angle)
    return point
}

public extension CGPoint {
    // random CGPoint
    static func random(min:UInt32 = 0, range:UInt32 = 1000) -> CGPoint {
        return CGPoint(x:Int(arc4random()%range + min),y:Int(arc4random()%range + min))}

    static func random(around point:CGPoint, distance:CGFloat) -> CGPoint {
        let angle = CGFloat(Measurement<UnitAngle>(value: Double(arc4random()%360), unit: .degrees).converted(to: .radians).value)
        return pointAroundCircumference(fromCenter: point, radius: distance, angle: angle)
    }

    /**
     * Creates a new CGPoint given a CGVector.
     */
    public init(vector: CGVector) {
        self.init(x: vector.dx, y: vector.dy)
    }

    /**
     * Given an angle in radians, creates a vector of length 1.0 and returns the
     * result as a new CGPoint. An angle of 0 is assumed to point to the right.
     */
    public init(angle: CGFloat) {
        self.init(x: cos(angle), y: sin(angle))
    }

    /**
     * Adds (dx, dy) to the point.
     */
    public mutating func offset(dx: CGFloat, dy: CGFloat) -> CGPoint {
        x += dx
        y += dy
        return self
    }

    /**
     * Returns the length (magnitude) of the vector described by the CGPoint.
     */
    public func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }

    /**
     * Returns the squared length of the vector described by the CGPoint.
     */
    public func lengthSquared() -> CGFloat {
        return x*x + y*y
    }

    /**
     * Normalizes the vector described by the CGPoint to length 1.0 and returns
     * the result as a new CGPoint.
     */
    func normalized() -> CGPoint {
        let len = length()
        return len>0 ? self / len : CGPoint.zero
    }

    /**
     * Normalizes the vector described by the CGPoint to length 1.0.
     */
    public mutating func normalize() -> CGPoint {
        self = normalized()
        return self
    }

    /**
     * Calculates the distance between two CGPoints. Pythagoras!
     */
    public func distanceTo(point: CGPoint) -> CGFloat {
        return (self - point).length()
    }

    /**
     * Returns the angle in radians of the vector described by the CGPoint.
     * The range of the angle is -π to π; an angle of 0 points to the right.
     */
    public var angle: CGFloat {
        return atan2(y, x)
    }
}

/**
 * Adds two CGPoint values and returns the result as a new CGPoint.
 */
public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

/**
 * Increments a CGPoint with the value of another.
 */
public func += ( left: inout CGPoint, right: CGPoint) {
    left = left + right
}

/**
 * Adds a CGVector to this CGPoint and returns the result as a new CGPoint.
 */
public func + (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
}

/**
 * Increments a CGPoint with the value of a CGVector.
 */
public func += ( left: inout CGPoint, right: CGVector) {
    left = left + right
}

/**
 * Subtracts two CGPoint values and returns the result as a new CGPoint.
 */
public func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

/**
 * Decrements a CGPoint with the value of another.
 */
public func -= ( left: inout CGPoint, right: CGPoint) {
    left = left - right
}

/**
 * Subtracts a CGVector from a CGPoint and returns the result as a new CGPoint.
 */
public func - (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x - right.dx, y: left.y - right.dy)
}

/**
 * Decrements a CGPoint with the value of a CGVector.
 */
public func -= ( left: inout CGPoint, right: CGVector) {
    left = left - right
}

/**
 * Multiplies two CGPoint values and returns the result as a new CGPoint.
 */
public func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

/**
 * Multiplies a CGPoint with another.
 */
public func *= ( left: inout CGPoint, right: CGPoint) {
    left = left * right
}

/**
 * Multiplies the x and y fields of a CGPoint with the same scalar value and
 * returns the result as a new CGPoint.
 */
public func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

/**
 * Multiplies the x and y fields of a CGPoint with the same scalar value.
 */
public func *= ( point: inout CGPoint, scalar: CGFloat) {
    point = point * scalar
}

/**
 * Multiplies a CGPoint with a CGVector and returns the result as a new CGPoint.
 */
public func * (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x * right.dx, y: left.y * right.dy)
}

/**
 * Multiplies a CGPoint with a CGVector.
 */
public func *= ( left: inout CGPoint, right: CGVector) {
    left = left * right
}

/**
 * Divides two CGPoint values and returns the result as a new CGPoint.
 */
public func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

/**
 * Divides a CGPoint by another.
 */
public func /= ( left: inout CGPoint, right: CGPoint) {
    left = left / right
}

/**
 * Divides the x and y fields of a CGPoint by the same scalar value and returns
 * the result as a new CGPoint.
 */
public func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

/**
 * Divides the x and y fields of a CGPoint by the same scalar value.
 */
public func /= ( point: inout CGPoint, scalar: CGFloat) {
    point = point / scalar
}

/**
 * Divides a CGPoint by a CGVector and returns the result as a new CGPoint.
 */
public func / (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x / right.dx, y: left.y / right.dy)
}

/**
 * Divides a CGPoint by a CGVector.
 */
public func /= ( left: inout CGPoint, right: CGVector) {
    left = left / right
}

/**
 * Performs a linear interpolation between two CGPoint values.
 */
public func lerp(start: CGPoint, end: CGPoint, t: CGFloat) -> CGPoint {
    return start + (end - start) * t
}