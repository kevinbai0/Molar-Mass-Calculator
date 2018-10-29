//
//  FormulaStringFormatter.swift
//  IanniMM
//
//  Created by Kevin Bai on 2018-04-10.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import Foundation

class FormulaStringFormatter {
    // convert string of formula to formulable array
    class public func format(formula: String, elements: [Element], symbols: [String]) -> [Formulable] {
        var prevNumbers = ""
        var numberFormulaType: FormulaType?
        var formattedFormula: [Formulable] = []
        for i in 0..<formula.count {
            let index = formula.index(formula.startIndex, offsetBy: i)
            if formula[index].isUppercase {
                // check if it is an element
                if i + 1 != formula.count {
                    let next = formula.index(after: index)
                    if formula[next].isLowercase {
                        if let element = getElement(symbol: String([formula[index], formula[next]]), elements: elements, symbols: symbols) {
                            formattedFormula.append(Formulable(formulaType: .element, value: element))
                        }
                    }
                    else {
                        // then try and format only the current one
                        if let element = getElement(symbol: String(formula[index]), elements: elements, symbols: symbols) {
                            formattedFormula.append(Formulable(formulaType: .element, value: element))
                        }
                    }
                    
                }
                else {
                    // last one, calculate element
                    if let element = getElement(symbol: String(formula[index]), elements: elements, symbols: symbols) {
                        formattedFormula.append(Formulable(formulaType: .element, value: element))
                    }
                }
            }
            else if formula[index].isNumber {
                prevNumbers.append(formula[index])
                if i == 0 {
                    numberFormulaType = .coefficient
                }
                else {
                    let prev = formula.index(before: index)
                    if !formula[prev].isNumber {
                        if formula[prev].ascii! == Character("•").ascii! {
                            numberFormulaType = .coefficient
                        }
                        else {
                            numberFormulaType = .subScript
                        }
                    }
                }
                
                if i + 1 == formula.count {
                    formattedFormula.append(Formulable(formulaType: numberFormulaType!, value: Int(prevNumbers)!))
                }
                else {
                    let next = formula.index(after: index)
                    if !formula[next].isNumber {
                        formattedFormula.append(Formulable(formulaType: numberFormulaType!, value:                                 Int(prevNumbers)!))
                        prevNumbers = ""
                    }
                }
            }
            else if !formula[index].isLowercase {
                if formula[index].ascii! == Character("(").ascii! {
                    formattedFormula.append(Formulable(formulaType: .bracketOpen, value: "("))
                }
                else if formula[index].ascii! == Character(")").ascii! {
                    formattedFormula.append(Formulable(formulaType: .bracketClose, value: ")"))
                }
                else if formula[index].ascii! == Character("•").ascii! {
                    formattedFormula.append(Formulable(formulaType: .dot, value: "•"))
                }
            }
        }
        return formattedFormula
    }
    
    private class func getElement(symbol: String, elements: [Element], symbols: [String]) -> Element? {
        let symbolIndex = symbols.index(of: symbol)
        guard let index = symbolIndex else { return nil }
        return elements[index]
    }
    class func formatToString(formatted: [Formulable]) -> String {
        var returnString = ""
        for format in formatted {
            returnString += format.stringified
        }
        return returnString
    }
}


