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

    
    var keys: [Key] = [
        Key(letter: "0"),
        Key(letter: "1"),
        Key(letter: "2"),
        Key(letter: "3"),
        Key(letter: "4"),
        Key(letter: "5"),
        Key(letter: "6"),
        Key(letter: "7"),
        Key(letter: "8"),
        Key(letter: "9"),
        Key(letter: "Q"),
        Key(letter: "W"),
        Key(letter: "E"),
        Key(letter: "R"),
        Key(letter: "T"),
        Key(letter: "Y"),
        Key(letter: "U"),
        Key(letter: "I"),
        Key(letter: "O"),
        Key(letter: "P"),
        Key(letter: "A"),
        Key(letter: "S"),
        Key(letter: "D"),
        Key(letter: "F"),
        Key(letter: "G"),
        Key(letter: "H"),
        Key(letter: "J"),
        Key(letter: "K"),
        Key(letter: "L"),
        Key(letter: "Z"),
        Key(letter: "X"),
        Key(letter: "C"),
        Key(letter: "V"),
        Key(letter: "B"),
        Key(letter: "N"),
        Key(letter: "M"),
        Key(letter: "⇧", type: .control),
        Key(letter: "←", type: .control),
        Key(letter: "•"),
        Key(letter: "("),
        Key(letter: ")"),
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
        //shift and delete
        keys[36].addToView(self, .left(keyHorizontalPadding.pad), .right(keys[29].left, keyHorizontalPadding.pad), .height(keyHeight.constant), .top(keys[29].top))
        keys[37].addToView(self, .left(keyHorizontalPadding.pad, keys[35].right), .right(keyHorizontalPadding.pad), .height(keyHeight.constant), .top(keys[35].top))
        // •, (, and )
        keys[38].addToView(self, .left(keyHorizontalPadding.pad), .top(keys[36].bottom, keyVerticalPadding.pad), .width(keyWidth.constant), .height(keyHeight.constant))
        keys[39].addToView(self, .left(keys[38].right, keyHorizontalPadding.pad), .top(keys[36].bottom, keyVerticalPadding.pad), .width(keyWidth.constant), .height(keyHeight.constant))
        keys[40].addToView(self, .left(keys[39].right, keyHorizontalPadding.pad), .top(keys[36].bottom, keyVerticalPadding.pad), .width(keyWidth.constant), .height(keyHeight.constant))
        
        // delete all and done button
        keys[41].addToView(self, .left(keys[40].right, keyHorizontalPadding.pad), .centerX, .height(keyHeight.constant), .top(keys[38].top))
        keys[42].addToView(self, .left(keys[41].right, keyHorizontalPadding.pad), .right(keyHorizontalPadding.pad), .top(keys[38].top), .height(keyHeight.constant))
        // Done button
        // ⇧ button
        //keys[29].addToView(self, .left(keyHorizontalPadding.pad), .right(keys[19].left, (keyHorizontalPadding * 2).pad), .top(keys[19].top), .height(keyHeight.constant))
        
        // set keys q and j to never selectable since those are never used in the periodic table
        keys[10].selectableState = .permanentUnselectable
        keys[26].selectableState = .permanentUnselectable
    }
    
    func hideNonAutocompleteOptions(autocompleteOptions: [String]) {
        for key in keys {
            if let keyText = key.label.text {
                if !autocompleteOptions.contains(keyText.lowercased()) && key.keyType == .letter {
                    if key.selectableState != .permanentUnselectable {
                        key.selectableState = .temporaryUnselectable
                    }
                }
            }
        }
    }
    
    func setKeysToLowercase() {
        for key in keys {
            if key.keyType == .letter { key.label.text = key.label.text?.lowercased() }
        }
    }
    func setKeysToUppercase() {
        for key in keys {
            if key.keyType == .letter { key.label.text = key.label.text?.uppercased() }
        }
    }
}
