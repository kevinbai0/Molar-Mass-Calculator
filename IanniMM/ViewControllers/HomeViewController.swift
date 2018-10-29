//
//  HomeViewController.swift
//  Ianni's Molar Masses
//
//  Created by Kevin Bai on 2018-04-06.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import UIKit

enum ApplicationState {
    case defaultState, selectedTextField, showingPreResults, showingResults
}

class HomeViewController: UIViewController, HomeViewDelegate, KeyboardViewDelegate, SolutionVCDelegate, IanniVCDelegate {
    var periodicTable = PeriodicTable()
    let homeView = HomeView()
    let keyboardView = KeyboardView()
    let solutionVC: SolutionVC = SolutionVC()
    let onboardingVC = OnboardingVC()
    let ianniVC = IanniVC()
    
    let transition = FillThroughAnimation()
    
    var state: ApplicationState = .defaultState {
        didSet {
            homeView.state = state
            if oldValue != .defaultState && state == .defaultState {
                self.homeView.titleLabel.x1Anchor = .left(20.scaled.pad)
                self.homeView.titleLabel.x2Anchor = .right(20.scaled.pad)
                homeView.formulaInputView.y1Anchor = .centerY
                homeView.formulaInputView.x1Anchor = .left(20.scaled.pad)
                homeView.formulaInputView.x2Anchor = .right(20.scaled.pad)
                homeView.helpButton.y1Anchor = .bottom(20.scaled.pad)

                homeView.formulaInputView.inputTextField.resignFirstResponder()
                periodicTable.currentFormulaString = ""
                periodicTable.previewString = ""
                self.keyboardView.setKeyboardState(state: .regularKeyboard, keyText: "")
                updateMolarMassCalculations()
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
            else if oldValue != .selectedTextField && state == .selectedTextField {
                if UIScreen.main.isiPadPortrait || UIScreen.main.isiPadLandscape {
                    homeView.formulaInputView.y1Anchor = .bottom((self.keyboardView.keyboardHeight + 35.scaled).pad)
                }
                else {
                    homeView.formulaInputView.y1Anchor = .bottom((self.keyboardView.keyboardHeight).pad)
                }
                homeView.formulaInputView.x1Anchor = .left(self.keyboardView.qwertyKeysView.keyHorizontalPadding.pad)
                homeView.formulaInputView.x2Anchor = .right(self.keyboardView.qwertyKeysView.keyHorizontalPadding.pad)
                self.homeView.titleLabel.x2Anchor = .right(homeView.left, 20.scaled.pad)
                self.homeView.titleLabel.x1Anchor = .left(homeView.left, (-self.view.frame.width + 20.scaled).pad)
                self.homeView.helpButton.y1Anchor = .top(self.view.bottom)
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
        self.periodicTable = table
        
        self.keyboardView.delegate = self
        
        homeView.helpButton.addTarget(self, action: #selector(showOnboarding), for: .touchUpInside)
        homeView.formulaInputView.inputTextField.inputView = keyboardView
        homeView.delegate = self
        self.addChildViewController(solutionVC)
        solutionVC.view.addToView(self.view, .left, .top, .right , .bottom(homeView.formulaInputView.top))
        solutionVC.view.isHidden = true
        solutionVC.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var big = false
        DispatchQueue.main.async {
            let _ = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true, block: { (_) in
                if big {
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                        self.homeView.subTitleButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    }, completion: nil)
                }
                else {
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                        self.homeView.subTitleButton.transform = .identity
                    }, completion: nil)
                }
                big = !big
            })
        }
        
        self.homeView.subTitleButton.addTarget(self, action: #selector(showIanniView(sender:)), for: .touchUpInside)
        ianniVC.delegate = self
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
            self.solutionVC.setMolarMassLabel(value: molarMass.1)
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
    
    override func loadView() {
        print(UIScreen.main.bounds)
        self.view = homeView
    }
    
    @objc func showIanniView(sender: UIButton) {
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
    }
    
    
}
