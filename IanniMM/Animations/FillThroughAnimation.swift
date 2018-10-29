//
//  FillThroughAnimation.swift
//  IanniMM
//
//  Created by Kevin Bai on 2018-09-22.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import UIKit

class FillThroughAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    var duration: TimeInterval = 1.0
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else { return }
        containerView.addSubview(toView)
        toView.alpha = 0.0
        UIView.animate(withDuration: duration, animations: {
            toView.alpha = 1.0
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    
}
