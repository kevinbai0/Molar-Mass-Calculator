//
//  KeyboardView.swift
//  IanniMM
//
//  Created by Kevin Bai on 2018-04-07.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import UIKit

protocol KeyboardViewDelegate:class {
    func keyboardViewDidFinishString(letter: String)
    func keyboardViewDidGiveTemporaryString(letter: String) -> ([String], Bool)
    func keyboardViewDidDeleteAtCursor()
    func keyboardViewDidAddText(string: String)
    func keyboardViewWillHide()
}

enum KeyboardState {
    case regularKeyboard, completingSymbolRegularKeyboard, numpad
}

class KeyboardView: UIView {
    // create all the keys that are needed to form the alphabetå
    var qwertyKeysView = QwertyKeysView()
    var currentAutoCompleteResults: [String]?
    var keyboardHeight: CGFloat {
        get {
            if UIScreen.main.isiPhoneXFamily {
                return qwertyKeysView.keyHeight * 5 + qwertyKeysView.keyVerticalPadding * 5 + qwertyKeysView.keyTopSpacing + 20.scaled
            }
            return qwertyKeysView.keyHeight * 5 + qwertyKeysView.keyVerticalPadding * 5 + qwertyKeysView.keyTopSpacing
        }
    }
    
    var delegate: KeyboardViewDelegate?
    
    var currentState: KeyboardState {
        get { return self.keyboardState }
    }
    
    var keyboardState: KeyboardState = .regularKeyboard
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init() {
        super.init(frame: .zero)
        // place qwerty row keys
        
        self.clipsToBounds = true
        qwertyKeysView.addToView(self, .left, .right, .top, .bottom)
        self.backgroundColor = .white
        // set frame
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - keyboardHeight, width: UIScreen.main.bounds.width, height: keyboardHeight)
    }
    
    // update view when refreshing constraints
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        let selectedKey = getKeyFrom(point: location, keySet: qwertyKeysView.keys)
        highlightKey(highlightedKey: selectedKey, keySet: qwertyKeysView.keys)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        let selectedKey = getKeyFrom(point: location, keySet: qwertyKeysView.keys)
        highlightKey(highlightedKey: selectedKey, keySet: qwertyKeysView.keys)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        self.handleRegularKeyboardInput(location: location)
    }
    
    func handleRegularKeyboardInput(location: CGPoint) {
        let selectedKey = getKeyFrom(point: location, keySet: qwertyKeysView.keys)
        highlightKey(highlightedKey: nil, keySet: qwertyKeysView.keys)
        if let keyText = selectedKey?.label.text {
            if selectedKey?.keyType == .letter || selectedKey?.keyType == .decimalDigit || selectedKey?.keyType == .punctuation {
                self.setQwertyKeysState(selectedKey: selectedKey!, keyText: keyText)
            }
            else {
                if keyText == "←" {
                    delegate?.keyboardViewDidDeleteAtCursor()
                }
                else if keyText == "Done" {
                    self.delegate?.keyboardViewWillHide()
                }
            }
        }
        else if self.keyboardState == .completingSymbolRegularKeyboard {
            delegate?.keyboardViewDidFinishString(letter: "")
            self.resetKeyHighlights(keySet: qwertyKeysView.keys)
            qwertyKeysView.setKeysToUppercase()
            self.keyboardState = .regularKeyboard
        }
    }
    
    func setQwertyKeysState(selectedKey: Key, keyText: String) {
        if self.keyboardState == .completingSymbolRegularKeyboard {
            if currentAutoCompleteResults?.contains(keyText) ?? false {
                self.setKeyboardState(state: .regularKeyboard, keyText: keyText)
            }
            else {
                self.setKeyboardState(state: .regularKeyboard, keyText: "")
                if selectedKey.keyType == .decimalDigit || selectedKey.keyType == .punctuation {
                    self.setKeyboardState(state: .regularKeyboard, keyText: keyText)
                }
            }
        }
        else if self.keyboardState == .regularKeyboard {
            self.setKeyboardState(state: .completingSymbolRegularKeyboard, keyText: keyText)
        }
    }
    
    func setKeyboardState(state: KeyboardState, keyText: String) {
        guard let delegate = delegate else { return }
        if state == .completingSymbolRegularKeyboard {
            let results = delegate.keyboardViewDidGiveTemporaryString(letter: keyText)
            currentAutoCompleteResults = results.0
            let isSingleLetterSymbol = results.1
            if let autocompleteResults = currentAutoCompleteResults {
                if autocompleteResults.count > 0 {
                    qwertyKeysView.hideNonAutocompleteOptions(autocompleteOptions: autocompleteResults, shouldHideNumbersAndSymbols: !isSingleLetterSymbol)
                    self.keyboardState = .completingSymbolRegularKeyboard
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) {
                        if self.keyboardState == .completingSymbolRegularKeyboard {
                            self.qwertyKeysView.setKeysToLowercase()
                        }
                    }
                }
                else {
                    self.keyboardState = .regularKeyboard
                }
            }
            return
        }
        
        qwertyKeysView.setKeysToUppercase()
        delegate.keyboardViewDidFinishString(letter: keyText)
        self.keyboardState = .regularKeyboard
        self.resetKeyHighlights(keySet: qwertyKeysView.keys)
        
    }
    
    private func highlightKey(highlightedKey: Key?, keySet: [Key]) {
        for key in keySet {
            if key == highlightedKey {
                if key.selectableState != .temporaryUnselectable {
                    key.selectableState = .highlightedState
                }
            }
            else {
                if key.selectableState == .highlightedState {
                    key.selectableState = .defaultState
                }
            }
        }
    }
    
    private func resetKeyHighlights(keySet: [Key]) {
        for key in keySet {
            key.selectableState = .defaultState
        }
    }
    
    private func getKeyFrom(point: CGPoint, keySet: [Key]) -> Key? {
        var minDist: CGFloat = 1000.0
        var minDistKey: Key?
        for key in keySet {
            if point.isIn(frame: key.frame) && key.selectableState != .permanentUnselectable {
                return key
            }
            else {
                let dist = point.distance(from: key.frame)
                if dist != 0 && dist < minDist {
                    minDistKey = key
                    minDist = dist
                }
            }
        }
        if minDist < qwertyKeysView.keyHorizontalPadding {
            return minDistKey
        }
        return nil
    }
}
