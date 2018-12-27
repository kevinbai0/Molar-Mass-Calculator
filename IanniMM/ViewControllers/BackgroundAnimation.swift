//
//  BackgroundAnimation.swift
//  IanniMM
//
//  Created by Kevin Bai on 2018-12-26.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import SpriteKit

class BackgroundAnimation: SKScene {
    enum Quadrant {
        case above, below, left, right
    }
    var molecules: [SKShapeNode:(CGFloat, CGFloat, CGFloat, Bool)] = [:]
    
    let moleculeBezier = UIBezierPath()
    var moleculePath: CGPath!
    
    let periodicTable: PeriodicTable
    var currentPeriodicElementNumber = 1

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(size: CGSize, periodicTable: PeriodicTable) {
        self.periodicTable = periodicTable
        super.init(size: size)
        self.backgroundColor = .white
        let π = CGFloat.pi
        let spacing: CGFloat = 0.005
        let radius: CGFloat = 25
        let edge: CGFloat = 90
        
        moleculeBezier.addArc(withCenter: CGPoint(x: -edge / 2 * sqrt(3), y: -edge / 2), radius: radius, startAngle: π / 6 - spacing, endAngle: π/6 + spacing, clockwise: false)
        moleculeBezier.addLine(to: CGPoint(x: -radius * cos(1 / 6 * π - spacing), y: -radius * sin(1 / 6 * π - spacing)))
        moleculeBezier.addArc(withCenter: CGPoint(x: 0, y: 0), radius: radius, startAngle: 7 * π / 6 - spacing, endAngle: -π / 6 + spacing, clockwise: false)
        moleculeBezier.addLine(to: CGPoint(x: edge / 2 * sqrt(3) - radius * cos(π / 6 + spacing), y: -edge / 2 + radius * sin(π / 6 + spacing)))
        moleculeBezier.addArc(withCenter: CGPoint(x: edge / 2 * sqrt(3), y: -edge / 2), radius: radius, startAngle: 5 / 6 * π - spacing, endAngle: 5 / 6 * π + spacing, clockwise: false)
        moleculeBezier.addLine(to: CGPoint(x: radius * cos(π/6 + spacing), y: -radius * sin(π/6 + spacing)))
        moleculeBezier.addArc(withCenter: CGPoint(x: 0, y: 0), radius: radius, startAngle: 11 * π / 6 - spacing, endAngle: 7 * π / 6 + spacing, clockwise: false)
        moleculeBezier.addLine(to: CGPoint(x: -edge / 2*sqrt(3) + radius * cos(π/6-spacing), y: -edge / 2 + radius * sin(π/6 - spacing)))
        moleculeBezier.close()
        moleculePath = moleculeBezier.cgPath
    }
    override func sceneDidLoad() {
        super.sceneDidLoad()
    }
    
    var initialSpawning = true
    var spawningCounter = 0
    var spawningIndex = 0
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
    }

    override func update(_ currentTime: TimeInterval) {
        if initialSpawning {
            spawningCounter += 1
            if spawningCounter % 30 == 0 {
                if spawningIndex >= 8 { initialSpawning = false }
                else if spawningIndex % 4 == 0 { spawnRandomMolecule(quadrant: .left, periodicElement: true) }
                else if spawningIndex % 4 == 1 { spawnRandomMolecule(quadrant: .right, periodicElement: false) }
                else if spawningIndex % 4 == 2 { spawnRandomMolecule(quadrant: .above, periodicElement: true) }
                else if spawningIndex % 4 == 3 { spawnRandomMolecule(quadrant: .below, periodicElement: false) }
                spawningIndex += 1
            }
        }
        for (molecule, (dx, dy, dRotation, isPeriodic)) in molecules {
            molecule.position.x += dx
            molecule.position.y += dy
            molecule.zRotation += dRotation
            if let outOfQuadrant = moleculeIsOutOfBounds(node: molecule, velocity: CGVector(dx: dx, dy: dy)) {
                spawnRandomMolecule(quadrant: outOfQuadrant, periodicElement: isPeriodic, oldMolecule: molecule)
            }
        }
    }
    
    func spawnRandomMolecule(quadrant: Quadrant, periodicElement: Bool, oldMolecule: SKShapeNode? = nil) {
        // generate random number between
        let dv = CGFloat(arc4random()) / CGFloat(UInt32.max) >= 0.5 ? CGFloat(-1) : CGFloat(1)
        let molecule = oldMolecule ?? (periodicElement ? PeriodicNode() : generateMolecule())
        
        var dRotation = CGFloat(arc4random()) / CGFloat(UInt32.max) * 0.02 - 0.01
        if abs(dRotation) < 0.003 {
            dRotation += dRotation < 0 ? -0.005 : 0.005
        }
        var dx: CGFloat = 0
        var dy: CGFloat = 0
        if quadrant == .above || quadrant == .below {
            let randX = arc4random_uniform(UInt32(self.frame.width))
            let randDX = CGFloat(arc4random()) / CGFloat(UInt32.max) * 2 - 1
            molecule.position = CGPoint(x: CGFloat(randX), y: dv > 0 ? -100 : self.frame.height + 100)
            dx = randDX
            dy = 1 + CGFloat(arc4random()) / CGFloat(UInt32.max) * 0.5 * dv
        }
        else {
            let randY = arc4random_uniform(UInt32(self.frame.height))
            let randDY = CGFloat(arc4random_uniform(4)) - 2
            molecule.position = CGPoint(x: dv > 0 ? -100 : self.frame.width + 100, y: CGFloat(randY))
            dx = 1 + CGFloat(arc4random()) / CGFloat(UInt32.max) * 0.5 * dv
            dy = randDY
        }
        if oldMolecule == nil {
            self.addChild(molecule)
        }
        if let periodicNode = molecule as? PeriodicNode {
            if currentPeriodicElementNumber < self.periodicTable.elementSymbols.count {
                periodicNode.elementSymbol = self.periodicTable.elementSymbols[currentPeriodicElementNumber]
                periodicNode.elementNumberString = "\(self.currentPeriodicElementNumber)"
                periodicNode.molarMassString = "\(String(format: "%.2f", self.periodicTable.elements[currentPeriodicElementNumber].atomicMass)) g/mol"
                self.currentPeriodicElementNumber += 1
            }
            else {
                currentPeriodicElementNumber = 1
            }
        }
        molecules[molecule] = (dx, dy, dRotation, periodicElement)
    }
    
    func moleculeIsOutOfBounds(node: SKShapeNode, velocity: CGVector) -> Quadrant? {
        // simulate width and height as 200 pixels so 100 is half since calling self.frame is too expensive
        if node.position.x - 100 > self.frame.maxX && velocity.dx > 0 { return .right }
        if node.position.y - 100 > self.frame.maxY && velocity.dy > 0 { return .above }
        if node.position.x + 100 < 0 && velocity.dx < 0 { return .left }
        if node.position.y + 100 < 0 && velocity.dy < 0 { return .below }
        return nil
    }
    
    
    func generateMolecule() -> SKShapeNode {
        let shapeNode = SKShapeNode(path: moleculePath)
        shapeNode.lineWidth = 1.0
        shapeNode.fillColor = .white
        shapeNode.strokeColor = .rgb(153,153,153,0.4)
        shapeNode.name = "molecule"
        return shapeNode
    }
}


class PeriodicNode: SKShapeNode {
    var shapeNode: SKShapeNode?
    var labelNode: SKLabelNode = SKLabelNode()
    var numberNode: SKLabelNode = SKLabelNode()
    var molarMassNode: SKLabelNode = SKLabelNode()
    var elementSymbol: String? {
        get { return labelNode.text }
        set { labelNode.text = newValue }
    }
    var elementNumberString: String? {
        get { return numberNode.text }
        set { numberNode.text = newValue }
    }
    var molarMassString: String? {
        get { return molarMassNode.text }
        set { molarMassNode.text = newValue }
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    init(size: CGSize = CGSize(width: 90, height: 90)) {
        super.init()
        self.path = CGPath(rect: CGRect(x: 0, y: 0, width: 90, height: 90), transform: nil)
        let width: CGFloat = 90
        let height: CGFloat = 90
        labelNode.fontName = "SourceCodePro-Regular"
        labelNode.fontSize = 40
        labelNode.fontColor = .rgb(153,153,153,0.4)
        labelNode.verticalAlignmentMode = .center
        numberNode.fontSize = 12
        numberNode.fontName = "SourceCodePro-Regular"
        numberNode.fontColor = .rgb(153,153,153,0.4)
        molarMassNode.fontSize = 10
        molarMassNode.fontName = "SourceCodePro-Regular"
        molarMassNode.fontColor = .rgb(153,153,153,0.4)
        self.addChild(labelNode)
        self.addChild(numberNode)
        self.addChild(molarMassNode)
        labelNode.position = self.frame.midPoint
        numberNode.position = CGPoint(x: width - 10, y: height - 22)
        molarMassNode.position = CGPoint(x: width / 2, y: 10)
        numberNode.horizontalAlignmentMode = .right
        molarMassNode.horizontalAlignmentMode = .center
        
        self.lineWidth = 1.0
        self.fillColor = .white
        self.strokeColor = .rgb(153,153,153,0.4)
        self.name = "molecule"
        let randX = CGFloat(arc4random_uniform(UInt32(self.frame.width * 3 / 2))) - self.frame.width / 4
        let randY = CGFloat(arc4random_uniform(UInt32(self.frame.height * 3 / 2))) - self.frame.height / 4
        self.position = CGPoint(x: randX, y: randY)
    }
}
