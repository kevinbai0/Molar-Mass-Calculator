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
    func keyboardViewDidGiveTemporaryString(letter: String) -> [String]
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
    var numpadKeysView = NumpadKeysView()
    
    var keyboardHeight: CGFloat {
        get {
            if UIScreen.main.isiPhoneXFamily {
                return qwertyKeysView.keyHeight * 4 + qwertyKeysView.keyVerticalPadding * 4 + qwertyKeysView.keyTopSpacing + 20.scaled
            }
            return qwertyKeysView.keyHeight * 4 + qwertyKeysView.keyVerticalPadding * 4 + qwertyKeysView.keyTopSpacing
        }
    }
    
    var delegate: KeyboardViewDelegate?
    private var keyboardState: KeyboardState = .regularKeyboard {
        didSet {
            if oldValue != .numpad && keyboardState == .numpad {
                if oldValue == .completingSymbolRegularKeyboard {
                    delegate?.keyboardViewDidFinishString(letter: "")
                    self.resetKeyHighlights(keySet: qwertyKeysView.keys)
                    qwertyKeysView.setKeysToUppercase()
                }
                numpadKeysView.isHidden = false
                UIView.animateKeyframes(withDuration: 0.2, delay: 0.0, options: .calculationModeCubic, animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                        self.qwertyKeysView.alpha = 0.0
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                        self.numpadKeysView.alpha = 1.0
                    }
                }) { _ in
                    self.qwertyKeysView.isHidden = true
                }
            }
            else if oldValue == .numpad && keyboardState == .regularKeyboard {
                qwertyKeysView.isHidden = false
                UIView.animateKeyframes(withDuration: 0.2, delay: 0.0, options: .calculationModeCubic, animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                        self.numpadKeysView.alpha = 0.0
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                        self.qwertyKeysView.alpha = 1.0
                    }
                }) { _ in
                    self.numpadKeysView.isHidden = true
                }
            }
        }
    }
    
    var currentState: KeyboardState {
        get { return self.keyboardState }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init() {
        super.init(frame: .zero)
        // place qwerty row keys
        let linearColorGradient = CAGradientLayer()
        linearColorGradient.colors = [UIColor.rgb(91,160,94).cgColor, UIColor.rgb(115,206,160).cgColor]
        self.layer.addSublayer(linearColorGradient)
        linearColorGradient.frame = CGRect(x: 0, y: -UIScreen.main.bounds.height + keyboardHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let alphaLayer = CALayer()
        alphaLayer.backgroundColor = UIColor.white.withAlphaComponent(0.21).cgColor
       // self.layer.addSublayer(alphaLayer)
        alphaLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: keyboardHeight)
        
        self.clipsToBounds = true
        qwertyKeysView.addToView(self, .left, .right, .top, .bottom)
        numpadKeysView.addToView(self, .left, .right, .top, .bottom)
        numpadKeysView.isHidden = true
        numpadKeysView.alpha = 0.0
        
        // set frame
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - keyboardHeight, width: UIScreen.main.bounds.width, height: keyboardHeight)
    }
    
    // update view when refreshing constraints
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        let keySet = keyboardState == .numpad ? numpadKeysView.keys : qwertyKeysView.keys
        let selectedKey = getKeyFrom(point: location, keySet: keySet)
        highlightKey(highlightedKey: selectedKey, keySet: keySet)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        let keySet = keyboardState == .numpad ? numpadKeysView.keys : qwertyKeysView.keys
        let selectedKey = getKeyFrom(point: location, keySet: keySet)
        highlightKey(highlightedKey: selectedKey, keySet: keySet)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        if keyboardState == .regularKeyboard || keyboardState == .completingSymbolRegularKeyboard {
            self.handleRegularKeyboardInput(location: location)
        }
        else if keyboardState == .numpad {
            handleNumpadInput(location: location)
        }
    }
    
    func handleRegularKeyboardInput(location: CGPoint) {
        let selectedKey = getKeyFrom(point: location, keySet: qwertyKeysView.keys)
        highlightKey(highlightedKey: nil, keySet: qwertyKeysView.keys)
        if let keyText = selectedKey?.label.text {
            if selectedKey!.keyType == .letter {
                self.setQwertyKeysState(selectedKey: selectedKey!, keyText: keyText)
            }
            else {
                if keyText == "←" {
                    delegate?.keyboardViewDidDeleteAtCursor()
                }
                else if keyText == "123" {
                    self.keyboardState = .numpad
                }
                else if keyText == "Done" {
                    self.delegate?.keyboardViewWillHide()
                }
            }
        }
        else if self.keyboardState == .completingSymbolRegularKeyboard {
            self.keyboardState = .regularKeyboard
            delegate?.keyboardViewDidFinishString(letter: "")
            self.resetKeyHighlights(keySet: qwertyKeysView.keys)
            qwertyKeysView.setKeysToUppercase()
        }
    }
    
    func setQwertyKeysState(selectedKey: Key, keyText: String) {
        if self.keyboardState == .completingSymbolRegularKeyboard {
            if selectedKey.selectableState == .defaultState {
                self.setKeyboardState(state: .regularKeyboard, keyText: keyText)
            }
            else {
                self.setKeyboardState(state: .regularKeyboard, keyText: "")
            }
        }
        else if self.keyboardState == .regularKeyboard {
            if selectedKey.selectableState == .defaultState {
                self.setKeyboardState(state: .completingSymbolRegularKeyboard, keyText: keyText)
            }
            else {
                self.setKeyboardState(state: .completingSymbolRegularKeyboard, keyText: "")
            }
        }
    }
    
    func handleNumpadInput(location: CGPoint) {
        let selectedKey = getKeyFrom(point: location, keySet: numpadKeysView.keys)
        highlightKey(highlightedKey: nil, keySet: numpadKeysView.keys)
        if let keyText = selectedKey?.label.text {
            if selectedKey!.keyType == .letter {
                self.delegate?.keyboardViewDidAddText(string: keyText)
            }
            else {
                if keyText == "←" {
                    delegate?.keyboardViewDidDeleteAtCursor()
                }
                else if keyText == "abc" {
                    self.keyboardState = .regularKeyboard
                }
                else if keyText == "Done" {
                    self.delegate?.keyboardViewWillHide()
                }
            }
        }
    }
    
    func setKeyboardState(state: KeyboardState, keyText: String) {
        if state == .completingSymbolRegularKeyboard {
            if let autocompleteResults = delegate?.keyboardViewDidGiveTemporaryString(letter: keyText) {
                if autocompleteResults.count > 0 {
                    qwertyKeysView.hideNonAutocompleteOptions(autocompleteOptions: autocompleteResults)
                    self.keyboardState = .completingSymbolRegularKeyboard
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                        self.qwertyKeysView.setKeysToLowercase()
                    }
                }
                else {
                    self.keyboardState = .regularKeyboard
                }
            }
        }
        else if state == .regularKeyboard {
            qwertyKeysView.setKeysToUppercase()
            delegate?.keyboardViewDidFinishString(letter: keyText)
            self.keyboardState = .regularKeyboard
            self.resetKeyHighlights(keySet: qwertyKeysView.keys)
        }
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
            if key.selectableState != .permanentUnselectable {
                key.selectableState = .defaultState
            }
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
