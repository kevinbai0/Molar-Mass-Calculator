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
    
    // define views and global constraints
    let inputTextField = UITextField()
    
    var previewAnswerLabel = UILabel.create("", .black, .dosis(.light, 18.scaled))
    
    var placeholderTimer: Timer?
    var toggleOpacity = false
    let borderBottomLineView = UIView()
    let paddingView = UIView()
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init() {
        super.init(frame: CGRect.zero)
        
        if UIScreen.main.isiPhoneXFamily {
            inputTextField.font = .mainFont(.light, 20.scaled)
        }
        else {
            inputTextField.font = .mainFont(.light, 24.scaled)
        }
        inputTextField.textColor = .rgb(197,255,195)
        inputTextField.placeholder = "Input a chemical formula"
        inputTextField.placeholderColor = UIColor.rgb(197,255,195).withAlphaComponent(0.8)
                
        placeholderTimer = Timer(timeInterval: 1.0, target: self, selector: #selector(animatePlaceholderColor), userInfo: nil, repeats: true)
        placeholderTimer?.fire()
        
        inputTextField.addToView(self, .left, .right, .top, .bottom)
        inputTextField.leftView = paddingView
        inputTextField.leftViewMode = .always
        borderBottomLineView.backgroundColor = .white
        borderBottomLineView.addToView(self, .left, .right, .bottom, .height(1.scaled.constant))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if UIScreen.main.isiPhoneXFamily {
            paddingView.frame = CGRect(x: 0, y: 0, width: 10, height: self.inputTextField.frame.height)
        }
    }
    
    
    @objc func animatePlaceholderColor() {
        print("animate")
        let alpha: CGFloat = toggleOpacity ? 0.5 : 0.8
        toggleOpacity = !toggleOpacity
        UIView.animate(withDuration: 0.8) {
            self.inputTextField.placeholderColor = UIColor.rgb(197,255,195).withAlphaComponent(alpha)
        }
    }
}
