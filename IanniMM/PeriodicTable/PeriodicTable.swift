//
//  PeriodicTable.swift
//  IanniMM
//
//  Created by Kevin Bai on 2018-04-07.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import Foundation

class PeriodicTable {
    // backend class
    let filename = "PeriodicTable"
    let filetype = "json"
    var elements: [Element] = []
    
    var currentFormulaString = ""
    var previewString = ""
    
    var elementSymbols: [String] = []
    init() {
        
    }
    
    // load the periodic table from json file
    func loadTable() {
        let fileRoot = Bundle.main.path(forResource: filename, ofType: filetype)
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: fileRoot!))
            elements = try JSONDecoder().decode([Element].self, from: data)
            
            for element in elements {
                elementSymbols.append(element.symbol)
            }
        }
        catch let jsonErr {
            print("Unable to parse data: ", jsonErr)
        }
    }
    
    // determine whether a 2 letter symbol is an element symbol
    func findSymbolCombinations(with letter: String) -> [String] {
        var secondLetterCombinations: [String] = []
        if let first = letter.first {
            for symbol in elementSymbols {
                if symbol.first! == first {
                    if symbol.count > 1 {
                        secondLetterCombinations.append(String(symbol.last!))
                    }
                }
            }
        }
        
        return secondLetterCombinations
    }
    
    // calculate molar masses with percent composition
    public func calculateMolarMassWithPercents(formula: String) -> ([Element:Int], Double) {
        //split string at •
        let subFormulae = formula.split(separator: "•")
        var sum: Double = 0
        var elementsCount: [Element:Int] = [:]
        for subFormula in subFormulae {
            var formattedSubFormula = FormulaStringFormatter.format(formula: String(subFormula), elements: elements, symbols: elementSymbols)
            Formulable.insertBracketPairs(formattedFormula: &formattedSubFormula)
            let solve = Formulable.solve(formattedFormula: formattedSubFormula)
            sum += solve.1
            Formulable.merge(originalDictionary: &elementsCount, with: solve.0)
        }
        // round to 4 decimal places
        return (elementsCount, round(sum * 10000) / 10000)
    }
    
    // calculate molar mass without percent composition
    public func calculateMolarMass(formula: String) -> Double {
        //split string at •
        let subFormulae = formula.split(separator: "•")
        var sum: Double = 0
        for subFormula in subFormulae {
            var formattedSubFormula = FormulaStringFormatter.format(formula: String(subFormula), elements: elements, symbols: elementSymbols)
            Formulable.insertBracketPairs(formattedFormula: &formattedSubFormula)
            sum += Formulable.solve(formattedFormula: formattedSubFormula).1
        }
        // round to 4 decimal places
        return round(sum * 10000) / 10000
    }
}
