//
//  CGPointExtensions.swift
//  Tasks
//
//  Created by Kevin Bai on 2018-01-04.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import UIKit

extension CGPoint {
    func isIn(frame: CGRect) -> Bool {
        if x < frame.maxX && x > frame.minX && y < frame.maxY && y > frame.minY {
            return true
        }
        return false
    }
    func distance(from frame: CGRect) -> CGFloat {
        if frame.minX <= self.x && self.x <= frame.maxX {
            if frame.minY <= self.y && self.y <= frame.maxY { return 0.0 }
            else if self.y < frame.minY { return abs(frame.minY - self.y) }
            else { return abs(frame.maxY - self.y) }
        }
        else {
            if frame.minY <= self.y && self.y <= frame.maxY {
                if self.x < frame.minX { return abs(frame.minX - self.x) }
                else { return abs(frame.maxX - self.x) }
            }
            else if self.x < frame.minX && self.y < frame.minY {
                return self.distance(from: CGPoint(x: frame.minX, y: frame.minY))
            }
            else if self.x < frame.minX && self.y > frame.maxY {
                return self.distance(from: CGPoint(x: frame.minX, y: frame.maxY))
            }
            else if self.x > frame.maxX && self.y < frame.minY {
                return self.distance(from: CGPoint(x: frame.maxY, y: frame.minY))
            }
            else {
                return self.distance(from: CGPoint(x: frame.maxX, y: frame.maxY))
            }
        }
    }
    
    func distance(from point: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
    }
}

extension CGRect {
    var midPoint: CGPoint {
        get {
            return CGPoint(x: self.midX, y: self.midY)
        }
    }
}
