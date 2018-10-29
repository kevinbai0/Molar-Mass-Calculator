//
//  InputViewButton.swift
//  IanniMM
//
//  Created by Kevin Bai on 2018-04-12.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import UIKit

class InputViewButton: UIView {
    // each function button
    var label = UILabel()
    var touchInFrame = true
    var colorIsDefault = false
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(labelTitle: String) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .rgb(0,153,144)
        label.text = labelTitle
        label.textColor = .white
        label.font = .dosis(.light, 18.scaled)
        
        label.addToView(self, .centerX(), .centerY())
    }
    
    // different touch recognizers to determine the color of the buttons when users interact with them
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        colorIsDefault = false
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = .rgb(0,93,87)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if location.isIn(frame: self.frame) && colorIsDefault {
            colorIsDefault = false
            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = .rgb(0,93,87)
            }
        }
        else if !location.isIn(frame: self.frame) && !colorIsDefault {
            colorIsDefault = true
            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = .rgb(0,153,144)
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        colorIsDefault = true
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = .rgb(0,153,144)
        }
    }
}
