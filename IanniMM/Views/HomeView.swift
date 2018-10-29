//
//  HomeView.swift
//  Ianni's Molar Masses
//
//  Created by Kevin Bai on 2018-04-06.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import UIKit

// define a protocol for the homeview
protocol HomeViewDelegate:class {
    func homeViewDidSelectInputField()
}

class HomeView: UIView, UITextFieldDelegate, UIGestureRecognizerDelegate  {
    let titleLabel = UILabel.create("Molar Mass Calculator", .white, .mainFont(.bold, 32.scaled))
    let subTitleLabel = UILabel.create("For Frank Ianni", .white, .mainFont(.light, 14.scaled))
    let subTitleButton = UIButton()
    let formulaInputView = FormulaInputView()
    
    let helpButton = UIButton()
    
    var state: ApplicationState = .defaultState {
        didSet {
            if oldValue != .selectedTextField && state == .selectedTextField {
            }
        }
    }
    
    // hide the search menu when the user taps the input field or exits the search menu
    var searchMenuHidden: Bool = true
    weak var delegate: HomeViewDelegate?
    let gradientLayer = CAGradientLayer()
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init() {
        // set the background colors
        super.init(frame: CGRect.zero)
        self.backgroundColor = .rgb(91,160,94)
        gradientLayer.colors = [UIColor.rgb(91,160,94).cgColor, UIColor.rgb(115,206,160).cgColor]
        self.layer.addSublayer(gradientLayer)
        formulaInputView.inputTextField.delegate = self
        
        helpButton.setTitle("?", for: [])
        helpButton.setTitleColor(.white, for: [])
        helpButton.titleLabel?.font = .mainFont(.extraLight, 32.scaled)
        helpButton.layer.borderWidth = 1.0
        helpButton.layer.borderColor = UIColor.white.cgColor
        
        subTitleButton.layer.borderWidth = 1.0
        subTitleButton.layer.borderColor = UIColor.white.cgColor
        subTitleButton.layer.cornerRadius = 5.0
        
        subTitleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5.scaled, bottom: 0, right: 5.scaled)
        subTitleButton.setTitle("For Frank Ianni", for: [])
        subTitleButton.titleLabel?.font = .mainFont(.light, 14.scaled)

        // init constraints
        titleLabel.textAlignment = .center
        titleLabel.addToView(self, .left(20.scaled.pad), .right(20.scaled.pad), .top(38.scaled.pad))
        subTitleButton.addToView(self, .right(titleLabel.right), .top(titleLabel.bottom), .width(0.4.ratio))
        titleLabel.adjustsFontSizeToFitWidth = true
        helpButton.addToView(self, .bottom(20.scaled.pad), .left(20.scaled.pad), .width(50.scaled.constant), .height(helpButton.width))
        formulaInputView.addToView(self, .centerX, .left(20.scaled.pad), .right(20.scaled.pad), .centerY, .height(50.scaled.constant))
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        helpButton.layer.cornerRadius = helpButton.frame.width / 2
        gradientLayer.frame = self.bounds
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.homeViewDidSelectInputField()
        return true
    }
}
