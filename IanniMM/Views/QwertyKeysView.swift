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
            return 40.scaled
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
        Key(letter: "123", type: .control),
        Key(letter: "Done", type: .control),
        Key(letter: "←", type: .control),
        Key(letter: "⇧", type: .control)
    ]
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    init() {
        super.init(frame: .zero)
        
        let width = UIScreen.main.isiPadLandscape ? UIScreen.main.bounds.height : UIScreen.main.bounds.width
        keys[0].addToView(self, .left(keyHorizontalPadding.pad), .width(keyWidth.constant), .height(keyHeight.constant), .top(keyTopSpacing.pad))
        for i in 1..<10 {
            keys[i].addToView(self, .left(keyHorizontalPadding.pad, keys[i-1].right), .top(keys[i-1].top), .width(keyWidth.constant), .height(keyHeight.constant))
        }
        let secondRowSideSpacing = (width - (9 * keyWidth + 8 * keyHorizontalPadding)) / 2
        keys[10].addToView(self, .left(secondRowSideSpacing.pad), .width(keyWidth.constant), .height(keyHeight.constant), .top(keys[0].bottom, self.keyVerticalPadding.pad))
        for i in 11..<19 {
            keys[i].addToView(self, .left(keys[i-1].right, keyHorizontalPadding.pad), .width(keyWidth.constant), .height(keyHeight.constant), .top(keys[0].bottom, self.keyVerticalPadding.pad))
        }
        let thirdRowSideSpacing = (width - (7 * keyWidth + 6 * keyHorizontalPadding)) / 2
        keys[19].addToView(self, .left(thirdRowSideSpacing.pad), .width(keyWidth.constant), .height(keyHeight.constant), .top(keys[10].bottom, keyVerticalPadding.pad))
        for i in 20..<26 {
            keys[i].addToView(self, .left(keys[i-1].right, keyHorizontalPadding.pad), .width(keyWidth.constant), .height(keyHeight.constant), .top(keys[10].bottom, keyVerticalPadding.pad))
        }
        
        // 123 numpad button
        keys[26].addToView(self, .left(keyHorizontalPadding.pad), .right(self.centerX, (keyHorizontalPadding / 2).pad), .height(keyHeight.constant), .top(keys[19].bottom, keyVerticalPadding.pad))
        // Done button
        keys[27].addToView(self, .right(keyHorizontalPadding.pad), .left(self.centerX, (keyHorizontalPadding / 2).pad), .height(keyHeight.constant), .top(keys[19].bottom, keyVerticalPadding.pad))
        // ← button
        keys[28].addToView(self, .right(keyHorizontalPadding.pad), .left(keys[25].right, (2 * keyHorizontalPadding).pad), .height(keyHeight.constant), .top(keys[19].top))
        // ⇧ button
        //keys[29].addToView(self, .left(keyHorizontalPadding.pad), .right(keys[19].left, (keyHorizontalPadding * 2).pad), .top(keys[19].top), .height(keyHeight.constant))
        
        // set keys q and j to never selectable since those are never used in the periodic table
        keys[0].selectableState = .permanentUnselectable
        keys[16].selectableState = .permanentUnselectable
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
