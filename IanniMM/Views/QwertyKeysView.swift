//
//  QwertyKeysView.swift
//  IanniMM
//
//  Created by Kevin Bai on 2018-08-21.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import UIKit

class QwertyKeysView: UIView {
    // create key width depending on screen size
    var keyWidth: CGFloat {
        // depends current screen size
        get {
            if UIScreen.main.isiPhoneXFamily {
                return 24.scaled
            }
            else if UIScreen.main.isiPadPortrait || UIScreen.main.isiPadLandscape {
                return 32.scaled
            }
            return 25.scaled
        }
    }
    var keyHeight: CGFloat {
        get {
            if UIScreen.main.isiPadPortrait || UIScreen.main.isiPadLandscape {
                return 25.scaled
            }
            return 32.scaled
        }
    }
    
    var keyVerticalPadding: CGFloat {
        get {
            if UIScreen.main.isiPadPortrait || UIScreen.main.isiPadLandscape {
                return 5.scaled
            }
            return 10.scaled
        }
    }
    var keyHorizontalPadding: CGFloat {
        get {
            if UIScreen.main.isiPadLandscape {
                return (UIScreen.main.bounds.height - 10 * keyWidth) / 11
            }
            return (UIScreen.main.bounds.width - 10 * keyWidth) / 11
        }
    }
    let keyTopSpacing: CGFloat = 10.scaled
    
    var isUpperCase: Bool = true {
        didSet {
            if isUpperCase {
                UIView.animate(withDuration: 0.05, delay: 0.0, options: .allowUserInteraction, animations: {
                    self.keys[36].backgroundColor = .rgb(51,51,51)
                    self.keys[36].label.textColor = .white
                }, completion: nil)
                
            }
            else {
                UIView.animate(withDuration: 0.05, delay: 0.0, options: .allowUserInteraction, animations: {
                    self.keys[36].backgroundColor = .white
                    self.keys[36].label.textColor = .rgb(51,51,51)
                }, completion: nil)
            }
        }
    }

    
    var keys: [Key] = [
        Key(letter: "0", type: .decimalDigit),
        Key(letter: "1", type: .decimalDigit),
        Key(letter: "2", type: .decimalDigit),
        Key(letter: "3", type: .decimalDigit),
        Key(letter: "4", type: .decimalDigit),
        Key(letter: "5", type: .decimalDigit),
        Key(letter: "6", type: .decimalDigit),
        Key(letter: "7", type: .decimalDigit),
        Key(letter: "8", type: .decimalDigit),
        Key(letter: "9", type: .decimalDigit),
        Key(letter: "Q", type: .letter),
        Key(letter: "W", type: .letter),
        Key(letter: "E", type: .letter),
        Key(letter: "R", type: .letter),
        Key(letter: "T", type: .letter),
        Key(letter: "Y", type: .letter),
        Key(letter: "U", type: .letter),
        Key(letter: "I", type: .letter),
        Key(letter: "O", type: .letter),
        Key(letter: "P", type: .letter),
        Key(letter: "A", type: .letter),
        Key(letter: "S", type: .letter),
        Key(letter: "D", type: .letter),
        Key(letter: "F", type: .letter),
        Key(letter: "G", type: .letter),
        Key(letter: "H", type: .letter),
        Key(letter: "J", type: .letter),
        Key(letter: "K", type: .letter),
        Key(letter: "L", type: .letter),
        Key(letter: "Z", type: .letter),
        Key(letter: "X", type: .letter),
        Key(letter: "C", type: .letter),
        Key(letter: "V", type: .letter),
        Key(letter: "B", type: .letter),
        Key(letter: "N", type: .letter),
        Key(letter: "M", type: .letter),
        Key(letter: "⇧", type: .control),
        Key(letter: "←", type: .control),
        Key(letter: "•", type: .punctuation),
        Key(letter: "(", type: .punctuation),
        Key(letter: ")", type: .punctuation),
        Key(letter: "Del All", type: .control),
        Key(letter: "Done", type: .control)
    ]
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    init() {
        super.init(frame: .zero)
        
        let width = UIScreen.main.isiPadLandscape ? UIScreen.main.bounds.height : UIScreen.main.bounds.width
        keys[0].addToView(self, .left(keyHorizontalPadding.pad), .width(keyWidth.constant), .height(keyHeight.constant), .top(keyTopSpacing.pad))
        for i in 1..<10 {
            keys[i].addToView(self, .left(keyHorizontalPadding.pad, keys[i-1].right), .top(keys[i-1].top), .width(keyWidth.constant), .height(keyHeight.constant))
        }
        keys[10].addToView(self, .left(keyHorizontalPadding.pad), .width(keyWidth.constant), .height(keyHeight.constant), .top(keys[0].bottom, self.keyVerticalPadding.pad))
        for i in 11..<20 {
            keys[i].addToView(self, .left(keyHorizontalPadding.pad, keys[i-1].right), .top(keys[i-1].top), .width(keyWidth.constant), .height(keyHeight.constant))
        }
        let thirdRowSideSpacing = (width - (9 * keyWidth + 8 * keyHorizontalPadding)) / 2
        keys[20].addToView(self, .left(thirdRowSideSpacing.pad), .width(keyWidth.constant), .height(keyHeight.constant), .top(keys[10].bottom, self.keyVerticalPadding.pad))
        for i in 21..<29 {
            keys[i].addToView(self, .left(keys[i-1].right, keyHorizontalPadding.pad), .width(keyWidth.constant), .height(keyHeight.constant), .top(keys[10].bottom, self.keyVerticalPadding.pad))
        }
        let fourthRowSideSpacing = (width - (7 * keyWidth + 6 * keyHorizontalPadding)) / 2
        keys[29].addToView(self, .left(fourthRowSideSpacing.pad), .width(keyWidth.constant), .height(keyHeight.constant), .top(keys[20].bottom, keyVerticalPadding.pad))
        for i in 30..<36 {
            keys[i].addToView(self, .left(keys[i-1].right, keyHorizontalPadding.pad), .width(keyWidth.constant), .height(keyHeight.constant), .top(keys[20].bottom, keyVerticalPadding.pad))
        }
        // ⇧ button and delete
        keys[36].addToView(self, .left(keyHorizontalPadding.pad), .right(keys[29].left, keyHorizontalPadding.pad), .height(keyHeight.constant), .top(keys[29].top))
        keys[37].addToView(self, .left(keyHorizontalPadding.pad, keys[35].right), .right(keyHorizontalPadding.pad), .height(keyHeight.constant), .top(keys[35].top))
        // •, (, and )
        keys[38].addToView(self, .left(keyHorizontalPadding.pad), .top(keys[36].bottom, keyVerticalPadding.pad), .width(keyWidth.constant), .height(keyHeight.constant))
        keys[39].addToView(self, .left(keys[38].right, keyHorizontalPadding.pad), .top(keys[36].bottom, keyVerticalPadding.pad), .width(keyWidth.constant), .height(keyHeight.constant))
        keys[40].addToView(self, .left(keys[39].right, keyHorizontalPadding.pad), .top(keys[36].bottom, keyVerticalPadding.pad), .width(keyWidth.constant), .height(keyHeight.constant))
        
        // delete all and done button
        keys[41].addToView(self, .left(keys[40].right, keyHorizontalPadding.pad), .centerX, .height(keyHeight.constant), .top(keys[38].top))
        keys[42].addToView(self, .left(keys[41].right, keyHorizontalPadding.pad), .right(keyHorizontalPadding.pad), .top(keys[38].top), .height(keyHeight.constant))
        
        // color the shift button
        keys[36].backgroundColor = .rgb(51,51,51)
        keys[36].label.textColor = .white
    }
    
    func hideNonAutocompleteOptions(autocompleteOptions: [String], shouldHideNumbersAndSymbols: Bool) {
        for key in keys {
            if let keyText = key.label.text {
                if !autocompleteOptions.contains(keyText.lowercased()) && key.keyType == .letter {
                    key.selectableState = .temporaryUnselectable
                }
                if shouldHideNumbersAndSymbols && (key.keyType == .decimalDigit || key.keyType == .symbol) {
                    key.selectableState = .temporaryUnselectable
                }
            }
        }
    }
    
    func setKeysToLowercase() {
        self.isUpperCase = false
        for key in keys {
            if key.keyType == .letter { key.label.text = key.label.text?.lowercased() }
        }
        // shift label
    }
    func setKeysToUppercase() {
        self.isUpperCase = true
        for key in keys {
            if key.keyType == .letter { key.label.text = key.label.text?.uppercased() }
        }
    }
}
