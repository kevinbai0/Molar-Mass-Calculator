//
//  MyClass.swift
//  IanniMM
//
//  Created by Kevin Bai on 2018-04-12.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import UIKit

class OnboardingVC: UIViewController {
    /* Properties */
    
    var views: [OnboardingView] = []
    
    var currentPosition: CGFloat = 0
    //view constraint for the left anchor of the first onboarding view
    
    var leftSwipe = UISwipeGestureRecognizer()
    var rightSwipe = UISwipeGestureRecognizer()
    var pan = UIPanGestureRecognizer()
    var dotsView = DotsView(numDots: 3)
    
    let getStartedButton: UIButton = UIButton()
    let skipButton: UIButton = UIButton(type: .system)
    
    /* Initializers*/
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .rgb(126,224,219)
        // 3 views
        let view1 = OnboardingView(title: "Welcome", subHeading: "When you select a letter, the keyboard will gray out the letters that cannot form a symbol.", image:  UIImage(named: "keyboard1"), totalViews: 4)
        let view2 = OnboardingView(title: "Typing", subHeading: "If you want only want a one letter symbol, tap on any grayed out key to complete the current symbol.", image:  UIImage(named: "keyboard2"), totalViews: 4)
        let view3 = OnboardingView(title: "Number Pad", subHeading: "Select 123 for the number pad to input numbers, brackets, or a dot", image:  UIImage(named: "numpad"), totalViews: 4)
        
        // append all views to the array
        views.append(view1)
        views.append(view2)
        views.append(view3)
        
        // add all onboarding views to this view
        view1.addToView(self.view, .width, .top, .bottom, .left)
        view2.addToView(self.view, .left(view1.right), .top, .width, .bottom)
        view3.addToView(self.view, .left(view2.right), .top, .width, .bottom)
        
        getStartedButton.setTitle("Skip", for: [])
        getStartedButton.setTitleColor(.white, for: [])
        getStartedButton.titleLabel?.font = .mainFont(.light, 18.scaled)
        
        getStartedButton.backgroundColor = .rgb(93, 165, 102)
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(panScreen(sender:)))
        pan.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(pan)
        
        self.dotsView.addToView(self.view, .bottom(20.scaled.pad), .centerX, .width(0.5.ratio), .height(10.scaled.constant))
        getStartedButton.addToView(self.view, .right(20.scaled.pad), .centerY(dotsView.centerY), .width(0.2.ratio), .height(30.scaled.constant))
        
        getStartedButton.addTarget(self, action: #selector(hideOnboarding), for: .touchUpInside)
        getStartedButton.addTarget(self, action: #selector(getStartedTouchUp(sender:)), for: .touchDragExit)
        getStartedButton.addTarget(self, action: #selector(getStartedTouchDown(sender:)), for: .touchDown)
    }
    
    // swipe gesture recognition to change the screen
    @objc func panScreen(sender: UIPanGestureRecognizer) {
        if sender.state == .began {
        }
        if sender.state == .changed {
            let translationX = sender.translation(in: self.view).x
            if (currentPosition > 0 && currentPosition < CGFloat(views.count - 1)) || (currentPosition == 0 && translationX < 0) || (currentPosition == CGFloat(views.count - 1) && translationX > 0) {
                let leftShift = translationX - CGFloat(self.currentPosition) * self.view.frame.width
                views[0].x1Anchor = .left(leftShift.pad)
                self.view.layoutIfNeeded()
            }
        }
        else if sender.state == .ended {
            if sender.velocity(in: self.view).x > 150 || sender.translation(in: self.view).x > self.view.frame.width * 3 / 4 {
                // swipe right
                if currentPosition > 0 {
                    currentPosition -= 1
                }
            }
            else if sender.velocity(in: self.view).x < -150 || sender.translation(in: self.view).x < -self.view.frame.width * 3 / 4 {
                if currentPosition < CGFloat(views.count - 1) {
                    currentPosition += 1
                }
            }
            dotsView.setActive(order: Int(currentPosition))
            if Int(currentPosition) == views.count - 1 {
                getStartedButton.setTitle("Start!", for: [])
            }
            else {
                getStartedButton.setTitle("Skip", for: [])
            }
            
            views[0].x1Anchor = .left((-self.view.frame.width * currentPosition).pad)
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // touch up and down events for the getstarted button
    @objc func getStartedTouchDown(sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.backgroundColor = .rgb(142,229,153)
        }
    }
    
    @objc func getStartedTouchUp(sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.getStartedButton.backgroundColor = .rgb(93,165,102)
        }
    }
    
    @objc func hideOnboarding() {
        UIView.animate(withDuration: 0.2) {
            self.getStartedButton.backgroundColor = .rgb(93,165,102)
        }
        dismiss(animated: true) {
            self.views[0].x1Anchor = .left
            self.currentPosition = 0
            self.dotsView.setActive(order: 0)
            self.getStartedButton.setTitle("Skip", for: [])
        }
    }
    
    /* Delegate Methods */
    
    /* Overridden Methods */
    override func viewDidLayoutSubviews() {
        // reposition all subviews and set each corner radius
        super.viewDidLayoutSubviews()
        for v in views {
            v.layoutSubviews()
        }
        getStartedButton.layer.cornerRadius = getStartedButton.frame.height / 2
    }
}
