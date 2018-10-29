//
//  NumpadKeysView.swift
//  IanniMM
//
//  Created by Kevin Bai on 2018-08-21.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import UIKit

class NumpadKeysView: UIView {
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
        Key(letter: "("),
        Key(letter: ")"),
        Key(letter: "•"),
        Key(letter: "abc", type: .control),
        Key(letter: "Done", type: .control),
        Key(letter: "←", type: .control)
    ]
    var keyWidth: CGFloat {
        get {
            if UIScreen.main.isiPhoneXFamily {
                return 50.scaled
            }
            else if UIScreen.main.isiPadPortrait || UIScreen.main.isiPadLandscape {
                return 65.scaled
            }
            return 57.scaled
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
        get { return 5.scaled }
    }
    var keyHorizontalPadding: CGFloat {
        get {
            if UIScreen.main.isiPadLandscape {
                return (UIScreen.main.bounds.height - 5 * keyWidth) / 6
            }
            return (UIScreen.main.bounds.width - 5 * keyWidth) / 6
        }
    }
    let keyTopSpacing: CGFloat = 10.scaled
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init() {
        super.init(frame: .zero)
        
        // brackets
        // open (
        keys[10].addToView(self, .left(keyHorizontalPadding.pad), .width(keyWidth.constant), .height((keyHeight * 2 + keyVerticalPadding).constant), .top(keyTopSpacing.pad))
        // close )
        keys[11].addToView(self, .right(keyHorizontalPadding.pad), .width(keyWidth.constant), .height((keyHeight * 2 + keyVerticalPadding).constant), .top(keyTopSpacing.pad))
        keys[7].addToView(self, .left(keys[10].right, keyHorizontalPadding.pad), .top(keyTopSpacing.pad), .width(keyWidth.constant), .height(keyHeight.constant))
        keys[8].addToView(self, .left(keys[7].right, keyHorizontalPadding.pad), .top(keyTopSpacing.pad), .width(keyWidth.constant), .height(keyHeight.constant))
        keys[9].addToView(self, .left(keys[8].right, keyHorizontalPadding.pad), .top(keyTopSpacing.pad), .width(keyWidth.constant), .height(keyHeight.constant))
        keys[6].addToView(self, .right(keys[9].right), .top(keys[9].bottom, keyVerticalPadding.pad), .width(keyWidth.constant), .height(keyHeight.constant))
        keys[5].addToView(self, .right(keys[6].left, keyHorizontalPadding.pad), .top(keys[6].top), .width(keyWidth.constant), .height(keyHeight.constant))
        keys[4].addToView(self, .right(keys[5].left, keyHorizontalPadding.pad), .top(keys[6].top), .width(keyWidth.constant), .height(keyHeight.constant))
        keys[3].addToView(self, .right(keys[9].right), .top(keys[6].bottom, keyVerticalPadding.pad), .width(keyWidth.constant), .height(keyHeight.constant))
        keys[2].addToView(self, .right(keys[3].left, keyHorizontalPadding.pad), .top(keys[3].top), .width(keyWidth.constant), .height(keyHeight.constant))
        keys[1].addToView(self, .right(keys[2].left, keyHorizontalPadding.pad), .top(keys[3].top), .width(keyWidth.constant), .height(keyHeight.constant))
        keys[0].addToView(self, .top(keys[1].bottom, keyVerticalPadding.pad), .height(keyHeight.constant), .centerX(keys[2].centerX), .width((keyWidth * 2).constant))
        
        // "←" button
        keys[15].addToView(self, .right(keyHorizontalPadding.pad), .width(keyWidth.constant), .height(keyHeight.constant), .top(keys[11].bottom, keyVerticalPadding.pad))
        
        // • button
        keys[12].addToView(self, .left(keyHorizontalPadding.pad), .right(keyHorizontalPadding.pad, keys[1].left), .height(keyHeight.constant), .top(keys[10].bottom, keyVerticalPadding.pad))
        // abc button
        keys[13].addToView(self, .left(keyHorizontalPadding.pad), .right(keys[0].left, keyHorizontalPadding.pad), .top(keys[12].bottom, keyVerticalPadding.pad), .height(keyHeight.constant))
        // done button
        keys[14].addToView(self, .right(keyHorizontalPadding.pad), .left(keys[0].right, keyHorizontalPadding.pad), .height(keyHeight.constant), .top(keys[1].bottom, keyVerticalPadding.pad))
        

    }
}
