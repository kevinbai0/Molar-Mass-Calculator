//
//  Key.swift
//  IanniMM
//
//  Created by Kevin Bai on 2018-04-07.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import UIKit

class Key: UIView {
    enum KeyState {
        case defaultState, highlightedState, permanentUnselectable, temporaryUnselectable
    }
    var keyType: CFCharacterSetPredefinedSet

    let label = UILabel()
    var originalFrame = CGRect() {
        willSet(value) {
            self.frame = value
        }
    }
    
    // depending whether the key is shown or hidden, animate the key
    var isShown: Bool = false {
        willSet(value) {
            if value && !isShown {

            }
            else if !value && isShown {
            }
        }
    }
    
    
    // change the animation, color, and positioning of the key depending on the state of the key
    var selectableState: KeyState = .defaultState {
        didSet {
            if oldValue != .defaultState && selectableState == .defaultState {
                UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                    self.backgroundColor = .white
                    self.transform = .identity
                    self.label.alpha = 1.0
                }, completion: nil)
            }
            else if oldValue != .highlightedState && selectableState == .highlightedState {
                UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                    self.backgroundColor = .rgb(178,178,178)
                    self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }, completion: nil)
            }
            else if oldValue != .permanentUnselectable && selectableState == .permanentUnselectable {
                self.label.alpha = 0.0
                self.backgroundColor = .rgb(51,51,51)
            }
            else if oldValue != .temporaryUnselectable && selectableState == .temporaryUnselectable {
                UIView.animate(withDuration: 0.1) {
                    self.label.alpha = 0.0
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(letter: String, type: CFCharacterSetPredefinedSet = .letter) {
        self.keyType = type
        super.init(frame: CGRect.zero)
        label.text = letter
        label.textColor = .rgb(51,51,51)
        if UIScreen.main.isiPadPortrait || UIScreen.main.isiPadLandscape {
            label.font = .mainFont(.light, 12.scaled)
        }
        else {
            label.font = .mainFont(.light, 20.scaled)
        }
        label.textAlignment = .center
        
        label.addToView(self, .left(1.scaled.pad), .right(1.scaled.pad), .centerY)
        self.backgroundColor = .white
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.rgb(112,112,112).cgColor
    }
    // round corners when updating the key view
    override func layoutSubviews() {
        super.layoutSubviews()
        if UIScreen.main.isiPadPortrait || UIScreen.main.isiPadLandscape {
            self.layer.cornerRadius = 3.scaled
        }
        else {
            self.layer.cornerRadius = 5.scaled
        }
    }
}
