//
//  Formulable.swift
//  IanniMM
//
//  Created by Kevin Bai on 2018-04-10.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import Foundation

class Formulable {
    // checks for
    var valueInt: Int?
    var valueElement: Element?
    var valueSymbol: String?
    var formulaType: FormulaType
    var bracketPairIndex: Int?
    
    init(formulaType: FormulaType, value: Any) {
        self.formulaType = formulaType
        if formulaType == .coefficient || formulaType == .subScript {
            valueInt = value as? Int
        }
        else if formulaType == .element {
            valueElement = value as? Element
        }
        else {
            valueSymbol = value as? String
        }
    }
    
    var stringified:String {
        get {
            if let coefficient = valueInt { return "\(coefficient)" }
            else if let element = valueElement { return element.symbol }
            else if let elementSymbol = valueSymbol { return elementSymbol }
            return ""
        }
    }
    
    // if there aren't an equal number of '(' as ')', then fill intelligently fill in the missing bracket pairs
    class func insertMissingBrackets(formattedFormula: inout [Formulable]) {
        // count number of opened brackets and number of closed brackets
        var openCounter = 0, closedCounter = 0
        for formulable in formattedFormula {
            if formulable.formulaType == .bracketOpen {
                openCounter += 1
            }
            else if formulable.formulaType == .bracketClose {
                closedCounter += 1
            }
        }
        
        if formattedFormula.count > 0 {
            // see if there is a coefficient
            let hasCoefficient = formattedFormula[0].formulaType == .coefficient
            let diff = openCounter - closedCounter
            if diff > 0 { // if there are more '(' parentheses
                for _ in 0..<diff {
                    // add an equal # of ')' parentheses to the end
                    formattedFormula.append(Formulable(formulaType: .bracketClose, value: ")"))
                }
            }
            else if diff < 0 { // if there are more ')' parentheses
                let insertionIndex = hasCoefficient ? 1 : 0
                for _ in 0..<(-diff) {
                    // add an equal # of '(' parentheses to the beginning but after a coefficient if there is one
                    formattedFormula.insert(Formulable(formulaType: .bracketOpen, value: "("), at: insertionIndex)
                }
            }
        }
    }
    
    class func insertBracketPairs(formattedFormula: inout [Formulable], fixMissingBrackets: Bool = true) {
        if fixMissingBrackets { // if missing brackets then insert brackets to the formula
            insertMissingBrackets(formattedFormula: &formattedFormula)
        }
        // else determine which brackets are a pair when brackets are chained together
        // ex: (()()(()())) [0] and [last] are a pair, [1] and [2] are a pair and so on...
        var bracketPairs: [(Int, Int)] = []
        for i in 0..<formattedFormula.count {
            if formattedFormula[i].formulaType == .bracketOpen {
                bracketPairs.append((i, -1))
            }
            else if formattedFormula[i].formulaType == .bracketClose {
                var foundMatch = false
                for j in stride(from: bracketPairs.count - 1, through: 0, by: -1) {
                    if !foundMatch && bracketPairs[j].1 == -1 {
                        foundMatch = true
                        bracketPairs[j].1 = i
                    }
                }
            }
        }
        
        for pair in bracketPairs {
            formattedFormula[pair.0].bracketPairIndex = pair.1
            formattedFormula[pair.1].bracketPairIndex = pair.0
        }
    }
    
    // recursive formula to solve for the
    class func solve(formattedFormula: [Formulable], currentIndex: Int = 0) -> ([Element:Int], Double) {
        // keep track of the number of elements in the formula
        var elementsCountList: [Element:Int] = [:]
        var sum: Double = 0 // keep track of the molar mass
        if formattedFormula.count > 0 {
            // if the current index is the last one then it is an element and add the element to elements count, while adding its molar mass to the total sum
            if currentIndex + 1 == formattedFormula.count {
                if formattedFormula[currentIndex].formulaType == .element {
                    sum += formattedFormula[currentIndex].valueElement!.atomicMass
                    merge(originalDictionary: &elementsCountList, with: [formattedFormula[currentIndex].valueElement!:1]);
                }
                // this is the base case
                return (elementsCountList, sum)
            }
            // handle coefficients
            if formattedFormula[currentIndex].formulaType == .coefficient {
                var newSolve = solve(formattedFormula: formattedFormula, currentIndex: currentIndex + 1)
                sum += Double(formattedFormula[currentIndex].valueInt!) * newSolve.1
                for item in newSolve.0 {
                    if let _ = newSolve.0[item.key] {
                        newSolve.0[item.key]! *= formattedFormula[currentIndex].valueInt!
                    }
                    else {
                        newSolve.0[item.key] = formattedFormula[currentIndex].valueInt!
                    }
                }
                merge(originalDictionary: &elementsCountList, with: newSolve.0)
            }
            else if formattedFormula[currentIndex].formulaType == .element {
                // if current index is an element
                var multiplier = 1
                let element = formattedFormula[currentIndex].valueElement!
                // check if next is a subscript
                if currentIndex + 1 < formattedFormula.count {
                    if formattedFormula[currentIndex+1].formulaType == .subScript {
                        multiplier = formattedFormula[currentIndex+1].valueInt!
                    }
                }
                if let _ = elementsCountList[element] {
                    elementsCountList[element]! += multiplier
                }
                else {
                    elementsCountList[element] = multiplier
                }
                
                let nextSolve = solve(formattedFormula: formattedFormula, currentIndex: currentIndex + 1)
                sum += formattedFormula[currentIndex].valueElement!.atomicMass * Double(multiplier) + nextSolve.1
                
                merge(originalDictionary: &elementsCountList, with: nextSolve.0)
            }
            else if formattedFormula[currentIndex].formulaType == .bracketOpen {
                // on open bracket, recurse and treat the inside of the bracket one element, then calculate a multiplier if there is a subscipt after the bracket
                let subStart = currentIndex + 1
                let subFinish = formattedFormula[currentIndex].bracketPairIndex!
                let subFormatted = formattedFormula[subStart..<subFinish]
                
                var multiplier = 1
                if subFinish + 1 < formattedFormula.count {
                    if formattedFormula[subFinish + 1].formulaType == .subScript {
                        multiplier = formattedFormula[subFinish + 1].valueInt!
                    }
                }
                var arraySubformatted = Array(subFormatted)
                // fix bracket pair indices
                insertBracketPairs(formattedFormula: &arraySubformatted, fixMissingBrackets: false)
                
                var subSolve = solve(formattedFormula: Array(subFormatted), currentIndex: 0)
                var nextSolve: ([Element:Int], Double)?
                
                if subFinish + 1 < formattedFormula.count {
                    nextSolve = solve(formattedFormula: formattedFormula, currentIndex: subFinish + 1)
                }
                
                for item in subSolve.0 {
                    if let _ = subSolve.0[item.key] {
                        subSolve.0[item.key]! *= multiplier
                    }
                }
                merge(originalDictionary: &elementsCountList, with: subSolve.0)
                if let next = nextSolve {
                    merge(originalDictionary: &elementsCountList, with: next.0)
                    return (elementsCountList, subSolve.1 * Double(multiplier) + next.1)
                }
                return (elementsCountList, subSolve.1 * Double(multiplier))
                
            }
            else if formattedFormula[currentIndex].formulaType == .subScript {
                //skip to next since subscripts are already accounted for
                let nextSolve = solve(formattedFormula: formattedFormula, currentIndex: currentIndex + 1)
                sum += nextSolve.1
                merge(originalDictionary: &elementsCountList, with: nextSolve.0)
            }
        }
        return (elementsCountList, sum)
    }
    
    // add the values of 1 dictionary to another
    class func merge(originalDictionary: inout [Element:Int], with dictionary: [Element:Int]) {
        for item in dictionary {
            if let _ = originalDictionary[item.key] {
                originalDictionary[item.key]! += item.value
            }
            else {
                originalDictionary[item.key] = item.value
            }
        }
    }
}
