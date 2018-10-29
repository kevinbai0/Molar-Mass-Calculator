//
//  DotsView.swift
//  IanniMM
//
//  Created by Kevin Bai on 2018-04-12.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import UIKit

class DotsView: UIView {
    /* Properties */
    
    var dots: [UIView] = []
    
    /* Initializers*/
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    // supporting 3 or 4 dots in dots view
    init(numDots: Int) {
        super.init(frame: CGRect.zero)
        // add dots to view and position them depending on number of dots
        if numDots == 3 {
            let pad = 5.scaled
            dots.append(UIView())
            dots.append(UIView())
            dots.append(UIView())
            dots[1].addToView(self, .centerX, .height, .width(dots[1].height), .centerY)
            dots[0].addToView(self, .right(self.dots[1].left, pad.pad), .height, .width(dots[0].height), .centerY)
            dots[2].addToView(self, .left(self.dots[1].right, pad.pad), .height, .width(dots[2].height), .centerY)
            
        }
        if numDots == 4 {
            let pad = 5.scaled
            dots.append(UIView())
            dots.append(UIView())
            dots.append(UIView())
            dots.append(UIView())
            dots[1].addToView(self, .right(self.centerX, (pad / 2).pad), .centerY, .height, .width(dots[1].height))
            dots[2].addToView(self, .left(self.centerX,  (pad / 2).pad), .centerY, .height, .width(dots[2].height))
            dots[0].addToView(self, .right(dots[1].left, pad.pad), .centerY, .height, .width(dots[0].height))
            dots[3].addToView(self, .left(dots[2].right, pad.pad), .centerY, .height, .width(dots[3].height))
        }
        setActive(order: 0)
    }
    
    // set a specific dot to be on
    func setActive(order: Int) {
        for i in 0..<dots.count {
            if i == order {
                UIView.animate(withDuration: 0.2) {
                    self.dots[i].backgroundColor = .rgb(93,165,102)
                }
            }
            else {
                UIView.animate(withDuration: 0.2) {
                    self.dots[i].backgroundColor = .white
                }
            }
        }
    }
    
    // set corner radius when updating the view
    override func layoutSubviews() {
        super.layoutSubviews()
        for dot in dots {
            dot.layer.cornerRadius = dot.frame.width / 2
        }
    }
    
    /* Methods */
    
    /* Delegate Methods */
    
    /* Overridden Methods */
}
