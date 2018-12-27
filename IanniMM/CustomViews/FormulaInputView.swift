//
//  InputView.swift
//  IanniMM
//
//  Created by Kevin Bai on 2018-04-12.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import UIKit

// formula input view is the view that displays the chemical formula and the function buttons
class FormulaInputView: UIView {
    enum FormulaInputViewState {
        case regular, showingTextField
    }
    
    // define views and global constraints
    let inputTextField = UITextField()
    let molarMassLabel = UILabel.create("", .rgb(51,51,51), .mainFont(.regular, 12.scaled))
    
    var placeholderTimer: Timer?
    var toggleOpacity = false
    
    var state: FormulaInputViewState = .regular {
        didSet {
            if oldValue != .showingTextField && state == .showingTextField {
                inputTextField.y1Anchor = .top(20.scaled.pad)
                UIView.animate(withDuration: 0.2) {
                    self.layoutIfNeeded()
                    self.molarMassLabel.alpha = 1.0
                }
            }
            else if oldValue != .regular && state == .regular {
                inputTextField.y1Anchor = .top
                UIView.animate(withDuration: 0.2) {
                    self.layoutIfNeeded()
                    self.molarMassLabel.alpha = 0.0
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init() {
        super.init(frame: CGRect.zero)
        
        if UIScreen.main.isiPhoneXFamily {
            inputTextField.font = .mainFont(.light, 16.scaled)
        }
        else {
            inputTextField.font = .mainFont(.light, 16.scaled)
        }
        inputTextField.textColor = .rgb(51,51,51)
        inputTextField.placeholder = "Input a chemical formula"
        inputTextField.placeholderColor = UIColor.rgb(178,178, 178)
        
        
        inputTextField.addToView(self, .left(10.scaled.pad), .right(10.scaled.pad), .top, .height(50.scaled.constant))
        
        molarMassLabel.addToView(self, .centerX, .top(5.scaled.pad))
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 6
        self.layer.shadowOpacity = 0.16
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }
    
    func setMolarMassLabel(value: Double) {
        if "\(value) g/mol" != self.molarMassLabel.text {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.molarMassLabel.alpha = 0.0
            }) { _ in
                self.molarMassLabel.text = "\(value) g/mol"
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations: {
                    if self.state == .showingTextField {
                        self.molarMassLabel.alpha = 1.0
                    }
                }, completion: nil)
            }
        }
    }
}
