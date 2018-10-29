//
//  UIColorExtensions.swift
//  Tasks
//
//  Created by Kevin Bai on 2018-01-06.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import UIKit

extension UILabel {
    class func create(_ title: String, _ color: UIColor, _ font: UIFont?, textAlign: NSTextAlignment = .natural) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = color
        label.font = font
        label.textAlignment = textAlign
        return label
    }
}

extension UITextField {
    var placeholderColor: UIColor? {
        get {
            return nil
        }
        set(value) {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : value ?? UIColor.white])
        }
    }
}

extension UIColor {
    class func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
}

extension UIView {
    func layoutRootView() {
        guard let view = self.superview else {
            return self.layoutIfNeeded()
        }
        return view.layoutRootView()
    }
    func getRootViewImage() -> UIImage? {
        let rootView = getRootView()
        return rootView.getImage()
    }
    func getImage() -> UIImage? {
        UIGraphicsBeginImageContext(self.frame.size)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    private func getRootView() -> UIView {
        guard let view = self.superview else {
            return self
        }
        return view
    }
}

extension UIViewController {
    func getRootVC() -> UIViewController {
        guard let vc = self.parent else { return self }
        return vc.getRootVC()
    }
}

extension NSMutableAttributedString {
    // get attributed string from a formula string
    class func attributedFormulaFrom(_ formula: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: formula)
        if formula.count > 0 {
            var prevSubscripted = false
            let range = NSRange(location: 0, length: 1)
            attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.mainFont(.light, UIScreen.main.isiPhoneXFamily ? 20.scaled : 24.scaled)!, range: range)
            for index in 1..<formula.count {
                let i = formula.index(formula.startIndex, offsetBy: index)
                let prevI = formula.index(before: i)
                let asciiValue = Int(formula[i].unicodeScalars.first!.value)
                let prevAscii = Int(formula[prevI].unicodeScalars.first!.value)
                // if it is a number and it comes after a bracket or a letter, then it is subscripted
                if asciiValue >= 48 && asciiValue <= 57 {
                    if prevAscii < 48 || prevAscii > 57 {
                        if String(formula[prevI]) != "•" {
                            let range = NSRange(location: index, length: 1)
                            attributedString.addAttribute(NSAttributedStringKey.baselineOffset, value: -5, range: range)
                            attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.mainFont(.light, 16.scaled)!, range: range)
                            prevSubscripted = true
                        }
                        else { prevSubscripted = false }
                    }
                    else if prevSubscripted {
                        let range = NSRange(location: index, length: 1)
                        attributedString.addAttribute(NSAttributedStringKey.baselineOffset, value: -5, range: range)
                        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.mainFont(.light, 16.scaled)!, range: range)
                        prevSubscripted = true
                    }
                    else {
                        let range = NSRange(location: index, length: 1)
                        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.mainFont(.light, UIScreen.main.isiPhoneXFamily ? 20.scaled : 24.scaled)!, range: range)
                    }
                }
                else {
                    let range = NSRange(location: index, length: 1)
                    attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.mainFont(.light, UIScreen.main.isiPhoneXFamily ? 20.scaled : 24.scaled)!, range: range)
                }
            }
        }
        
        return attributedString
    }
}
