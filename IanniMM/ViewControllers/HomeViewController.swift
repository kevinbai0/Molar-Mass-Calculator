//
//  HomeViewController.swift
//  Ianni's Molar Masses
//
//  Created by Kevin Bai on 2018-04-06.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import UIKit
import SpriteKit

enum ApplicationState {
    case defaultState, selectedTextField, showingPreResults, showingResults, showingIanniView
}

class HomeViewController: UIViewController, HomeViewDelegate, KeyboardViewDelegate, SolutionVCDelegate, IanniVCDelegate {
    var periodicTable = PeriodicTable()
    let homeView = HomeView()
    let keyboardView = KeyboardView()
    let solutionVC: SolutionVC = SolutionVC()
    let onboardingVC = OnboardingVC()
    let ianniVC = IanniVC()
    let skView = SKView(frame: .zero)
    var backgroundAnimationScene: BackgroundAnimation?
    
    let transition = FillThroughAnimation()
    
    var state: ApplicationState = .defaultState {
        didSet {
            homeView.state = state
            if oldValue != .defaultState && state == .defaultState {
                self.homeView.titleLabel.x1Anchor = .left(20.scaled.pad)
                self.homeView.titleLabel.x2Anchor = .right(20.scaled.pad)
                homeView.formulaInputView.y1Anchor = .bottom(20.scaled.pad)
                homeView.formulaInputView.heightALAnchor = .height(50.scaled.constant)
                homeView.formulaInputView.x1Anchor = .left(20.scaled.pad)
                homeView.formulaInputView.x2Anchor = .right(20.scaled.pad)
                homeView.formulaInputView.layer.cornerRadius = 10
                homeView.formulaInputView.state = .regular

                homeView.formulaInputView.inputTextField.resignFirstResponder()
                periodicTable.currentFormulaString = ""
                periodicTable.previewString = ""
                self.keyboardView.setKeyboardState(state: .regularKeyboard, keyText: "")
                updateMolarMassCalculations()
                UIView.animate(withDuration: 0.5) {
                    self.homeView.alpha = 1.0
                    self.view.layoutIfNeeded()
                }
            }
            else if oldValue != .selectedTextField && state == .selectedTextField {
                homeView.formulaInputView.y1Anchor = .bottom
                homeView.formulaInputView.state = .showingTextField
                homeView.formulaInputView.heightALAnchor = .height((self.view.frame.height / 2).constant)
                homeView.formulaInputView.layer.cornerRadius = 30
                homeView.formulaInputView.x1Anchor = .left
                homeView.formulaInputView.x2Anchor = .right
                self.homeView.titleLabel.x2Anchor = .right(homeView.left, 20.scaled.pad)
                self.homeView.titleLabel.x1Anchor = .left(homeView.left, (-self.view.frame.width + 20.scaled).pad)
                self.solutionVC.state = .showingPreview
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
            else if oldValue != .showingPreResults && state == .showingPreResults {
                self.solutionVC.state = .shown
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
            else if oldValue != .showingResults && state == .showingResults {
                self.homeView.formulaInputView.y1Anchor = .bottom(20.scaled.pad)
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
            else if oldValue != .showingIanniView && state == .showingIanniView {
                UIView.animate(withDuration: 0.5) {
                    self.homeView.alpha = 0
                }
            }
        }
    }
    
    // this variable determines whether to load the onboarding vc or not
    var hasLoadedBefore: Bool {
        get {
            if !UserDefaults.standard.bool(forKey: "hasLoadedBefore") {
                return false
            }
            else {
                return true
            }
        }
    }
    
    var previewCount = 0
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init() {
        let table = PeriodicTable()
        table.loadTable()
        super.init(nibName: nil, bundle: nil)
        skView.addToView(self.view, .left, .right, .top, .bottom)
        self.periodicTable = table
        
        self.keyboardView.delegate = self
        self.homeView.addToView(self.view, .left, .right, .top, .bottom)

        homeView.formulaInputView.inputTextField.inputView = keyboardView
        homeView.delegate = self
        self.addChildViewController(solutionVC)
        solutionVC.view.addToView(self.view, .left, .top, .right , .bottom(homeView.formulaInputView.top))
        solutionVC.view.isHidden = true
        solutionVC.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.homeView.subTitleButton.addTarget(self, action: #selector(showIanniView(sender:)), for: .touchUpInside)
        ianniVC.delegate = self
        
        backgroundAnimationScene = BackgroundAnimation(size: self.view.frame.size)
        skView.presentScene(backgroundAnimationScene)
    }
    func homeViewDidSelectInputField() {
        self.state = .selectedTextField
    }
    func keyboardViewDidFinishString(letter: String) {
        // TODO: Fix deleting when only 1 letter in preview string
        // reset preview string
        periodicTable.previewString += letter
        if !periodicTable.elementSymbols.contains(periodicTable.previewString) {
            periodicTable.previewString = ""
        }
        // append new text
        periodicTable.currentFormulaString += periodicTable.previewString
        periodicTable.previewString = ""
        updateMolarMassCalculations()
    }
    
    // return the autocomplete characters
    func keyboardViewDidGiveTemporaryString(letter: String) -> [String] {
        periodicTable.previewString = letter
        let combinations = periodicTable.findSymbolCombinations(with: letter)
        if combinations.count == 0 {
            periodicTable.currentFormulaString += letter
            periodicTable.previewString = ""
        }
        updateMolarMassCalculations()
        return combinations
    }
    func keyboardViewDidDeleteAtCursor() {
        if periodicTable.previewString.count > 0 {
            periodicTable.previewString.removeAll()
            keyboardView.setKeyboardState(state: .regularKeyboard, keyText: "")
        }
        else if periodicTable.currentFormulaString.count > 0 {
            var formatted = FormulaStringFormatter.format(formula: periodicTable.currentFormulaString, elements: periodicTable.elements, symbols: periodicTable.elementSymbols)
            if formatted.count > 0 {
                formatted.removeLast()
                periodicTable.currentFormulaString = FormulaStringFormatter.formatToString(formatted: formatted)
            }
            
        }
        updateMolarMassCalculations()
    }
    
    
    func keyboardViewDidAddText(string: String) {
        periodicTable.currentFormulaString += string
        updateMolarMassCalculations()
    }
    
    func keyboardViewWillHide() {
        self.homeView.formulaInputView.inputTextField.resignFirstResponder()
        self.state = .showingResults
    }
    
    func updateMolarMassCalculations() {
        let molarMass = periodicTable.calculateMolarMassWithPercents(formula: periodicTable.currentFormulaString + periodicTable.previewString)
        UIView.animate(withDuration: 0.2) {
            self.homeView.formulaInputView.setMolarMassLabel(value: molarMass.1)
            self.solutionVC.sortedElements = molarMass.0.sorted(by: { $0.0.atomicNumber < $1.0.atomicNumber })
        }
        if molarMass.1 != 0 && self.state == .selectedTextField {
            self.state = .showingPreResults
        }
        homeView.formulaInputView.inputTextField.attributedText = NSMutableAttributedString.attributedFormulaFrom(periodicTable.currentFormulaString + periodicTable.previewString)
    }
    
    func solutionVCWillHome() {
        self.state = .defaultState
    }
    
    @objc func showOnboarding() {
        self.present(onboardingVC, animated: true, completion: nil)
    }
    
    @objc func showIanniView(sender: UIButton) {
        self.state = .showingIanniView
        self.addChildViewController(ianniVC)
        ianniVC.view.addToView(self.view, .left, .right, .top, .bottom)
    }
    
    override func viewDidLayoutSubviews() {
        homeView.layoutSubviews()
        if !hasLoadedBefore {
            showOnboarding()
            UserDefaults.standard.set(true, forKey: "hasLoadedBefore")
        }
    }
}


extension HomeViewController {
    func ianniVCRemoveFromSuperview() {
        ianniVC.removeFromParentViewController()
        ianniVC.view.removeFromSuperview()
        self.state = .defaultState
    }
    
    
}
