//
//  Molecule.swift
//  IanniMM
//
//  Created by Kevin Bai on 2018-12-26.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import SpriteKit

class Molecule: SKShapeNode {
    let centerCircle = SKShapeNode(circleOfRadius: 15)
    let circle2 = SKShapeNode(circleOfRadius: 15)
    let circle3 = SKShapeNode(circleOfRadius: 15)
    var line1: SKShapeNode?
    var line2: SKShapeNode?

    required init?(coder aDecoder: NSCoder) { fatalError() }
    override init() {
        let moleculeBezier = UIBezierPath()
        moleculeBezier.addArc(withCenter: CGPoint(x: -35 * sqrt(3), y: -35), radius: 15, startAngle: -1/6 * CGFloat.pi, endAngle: 11/6 * CGFloat.pi, clockwise: true)
        moleculeBezier.addLine(to: CGPoint(x: -15 * sqrt(3), y: -15))
        moleculeBezier.addArc(withCenter: CGPoint(x: 0, y: 0), radius: 15, startAngle: 2 / 3 * CGFloat.pi, endAngle: 8 / 3 * CGFloat.pi, clockwise: true)
        moleculeBezier.move(to: CGPoint(x: 15 * sqrt(3), y: -15))
        moleculeBezier.addLine(to: CGPoint(x: 55 / 2 * sqrt(3), y: -55 / 2))
        moleculeBezier.addArc(withCenter: CGPoint(x: 35 * sqrt(3), y: -35), radius: 15, startAngle: 7 / 6 * CGFloat.pi, endAngle: 19 / 6 * CGFloat.pi, clockwise: true)
        
        super.init()
        /*centerCircle.position = CGPoint(x: 0, y: 0)
        circle2.position = CGPoint(x: -35 * sqrt(3), y: -35)
        circle3.position = CGPoint(x: 35 * sqrt(3), y: -35)
        let bezierPath1 = UIBezierPath()
        bezierPath1.move(to: CGPoint(x: centerCircle.position.x - 1, y: centerCircle.position.y))
        bezierPath1.addLine(to: CGPoint(x: centerCircle.position.x + 1, y: centerCircle.position.y))
        bezierPath1.addLine(to: CGPoint(x: circle2.position.x + 1, y: circle2.position.y))
        bezierPath1.addLine(to: CGPoint(x: circle2.position.x - 1, y: circle2.position.y))
        bezierPath1.addLine(to: CGPoint(x: centerCircle.position.x - 1, y: centerCircle.position.y))
        bezierPath1.close()
        let bezierPath2 = UIBezierPath()
        bezierPath2.move(to: CGPoint(x: centerCircle.position.x + 1, y: centerCircle.position.y))
        bezierPath2.addLine(to: CGPoint(x: centerCircle.position.x - 1, y: centerCircle.position.y))
        bezierPath2.addLine(to: CGPoint(x: circle3.position.x - 1, y: circle3.position.y))
        bezierPath2.addLine(to: CGPoint(x: circle3.position.x + 1, y: circle3.position.y))
        bezierPath2.addLine(to: CGPoint(x: centerCircle.position.x + 1, y: centerCircle.position.y))
        bezierPath2.close()
        line1 = SKShapeNode(path: bezierPath1.cgPath)
        line2 = SKShapeNode(path: bezierPath2.cgPath)
        centerCircle.fillColor = .white
        circle2.fillColor = .white
        circle3.fillColor = .white
        centerCircle.strokeColor = .rgb(153,153,153, 0.4)
        circle2.strokeColor = .rgb(153,153,153, 0.4)
        circle3.strokeColor = .rgb(153,153,153, 0.4)
        centerCircle.lineWidth = 1.0
        circle2.lineWidth = 1.0
        circle3.lineWidth = 1.0*/
        
        
        /*line1?.strokeColor = .rgb(153,153,153, 0.4)
        line2?.strokeColor = .rgb(153,153,153, 0.4)
        line1?.lineWidth = 1.0
        line2?.lineWidth = 1.0
        
        self.addChild(line1!)
        self.addChild(line2!)
        self.addChild(centerCircle)
        self.addChild(circle2)
        self.addChild(circle3)
        
        centerCircle.physicsBody = SKPhysicsBody(circleOfRadius: 15, center: centerCircle.position)
        circle2.physicsBody = SKPhysicsBody(circleOfRadius: 15, center: circle2.position)
        circle3.physicsBody = SKPhysicsBody(circleOfRadius: 15, center: circle3.position)
        line1?.physicsBody = SKPhysicsBody(polygonFrom: bezierPath1.cgPath)
        line2?.physicsBody = SKPhysicsBody(polygonFrom: bezierPath2.cgPath)
        
        centerCircle.physicsBody?.affectedByGravity = false
        circle2.physicsBody?.affectedByGravity = false
        circle3.physicsBody?.affectedByGravity = false
        line1?.physicsBody?.affectedByGravity = false
        line2?.physicsBody?.affectedByGravity = false
        centerCircle.physicsBody?.collisionBitMask = 0
        circle2.physicsBody?.collisionBitMask = 0
        circle3.physicsBody?.collisionBitMask = 0
        line1?.physicsBody?.collisionBitMask = 0
        line2?.physicsBody?.collisionBitMask = 0
        centerCircle.physicsBody?.contactTestBitMask = 0
        circle2.physicsBody?.contactTestBitMask = 0
        circle3.physicsBody?.contactTestBitMask = 0
        line1?.physicsBody?.contactTestBitMask = 0
        line2?.physicsBody?.contactTestBitMask = 0*/
        
        /*self.physicsBody = SKPhysicsBody(bodies: [centerCircle.physicsBody!, circle2.physicsBody!, circle3.physicsBody!, line1!.physicsBody!, line2!.physicsBody!])*/
        self.fillColor = .white
        self.strokeColor = .rgb(153,153,153,0.4)
        self.physicsBody = SKPhysicsBody(polygonFrom: moleculeBezier.cgPath)
        self.physicsBody?.collisionBitMask = 1
        self.physicsBody?.contactTestBitMask = 1
        self.physicsBody?.isDynamic = true
        self.name = "molecule"
    }
}
