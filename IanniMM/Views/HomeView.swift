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
    let titleLabel = UILabel.create("Molar Mass Calculator", .rgb(51,51,51), .mainFont(.black, 42.scaled))
    let subTitleButton = UIButton()
    let formulaInputView = FormulaInputView()
        
    var state: ApplicationState = .defaultState {
        didSet {
            if oldValue != .selectedTextField && state == .selectedTextField {
            }
        }
    }
    
    // hide the search menu when the user taps the input field or exits the search menu
    var searchMenuHidden: Bool = true
    weak var delegate: HomeViewDelegate?
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init() {
        // set the background colors
        super.init(frame: CGRect.zero)
        formulaInputView.inputTextField.delegate = self
        
        
        subTitleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5.scaled, bottom: 0, right: 5.scaled)
        subTitleButton.setTitle("For Frank Ianni", for: [])
        subTitleButton.setTitleColor(.rgb(51,51,51), for: [])
        subTitleButton.layer.shadowColor = UIColor.black.cgColor
        subTitleButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        subTitleButton.layer.shadowRadius = 10
        subTitleButton.layer.shadowOpacity = 0.16
        subTitleButton.titleLabel?.font = .mainFont(.regular, 12.scaled)
        subTitleButton.backgroundColor = .white
        subTitleButton.contentEdgeInsets = UIEdgeInsets(top: 15.scaled, left: 10.scaled, bottom: 15.scaled, right: 10.scaled)

        // init constraints
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        titleLabel.addToView(self, .left(20.scaled.pad), .right(20.scaled.pad), .top(38.scaled.pad))
        subTitleButton.addToView(self, .left(titleLabel.left), .top(titleLabel.bottom, 20.scaled.pad), .width(0.5.ratio))
        formulaInputView.addToView(self, .centerX, .left(20.scaled.pad), .right(20.scaled.pad), .bottom(20.scaled.pad), .height(50.scaled.constant))
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        subTitleButton.layer.cornerRadius = subTitleButton.frame.height / 2
        let bezierPath =  UIBezierPath(roundedRect: subTitleButton.bounds, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: subTitleButton.frame.height / 2, height: subTitleButton.frame.height / 2))
        subTitleButton.layer.shadowPath = bezierPath.cgPath

    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.homeViewDidSelectInputField()
        return true
    }
}
