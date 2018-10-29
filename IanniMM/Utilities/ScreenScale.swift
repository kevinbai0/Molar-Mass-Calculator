//
//  ScreenScale.swift
//  Tasks
//
//  Created by Kevin Bai on 2018-01-02.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import Foundation
import UIKit

//all are scaled to iPhone SE/5S screen
extension UIScreen {
    var isiPhoneXFamily: Bool {
        get {
            return round((self.bounds.width / self.bounds.height) * 100) / 100.0 == 0.46
        }
    }
    var isiPhoneXR: Bool {
        get {
            return self.bounds.width == 414.0 && self.bounds.height == 896.0
        }
    }
    var isiPadPortrait: Bool {
        get {
            return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad && self.bounds.width < self.bounds.height
        }
    }
    var isiPadLandscape: Bool {
        get {
            return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad && self.bounds.width > self.bounds.height
        }
    }
}

class ScreenScale {
    enum ScreenSize: RawRepresentable {
        var rawValue: CGSize {
            switch(self) {
            case .iPhone_4:
                return CGSize(width: 320.0, height: 568.0)
            case .iPhone_4_7:
                return CGSize(width: 375.0, height: 667.0)
            case .iPhone_5_5:
                return CGSize(width: 414.0, height: 736.0)
            case .iPhone_5_8:
                return CGSize(width: 375.0, height: 812.0)
            case .iPad_Retina:
                return CGSize(width: 768.0, height: 1024.0)
            }
        }
        init(rawValue: CGSize) {
            switch rawValue {
            case CGSize(width: 320.0, height: 568.0): self = .iPhone_4
            case CGSize(width: 375.0, height: 667.0): self = .iPhone_4_7
            case CGSize(width: 414.0, height: 736.0): self = .iPhone_5_5
            case CGSize(width: 375.0, height: 812.0): self = .iPhone_5_8
            case CGSize(width: 768.0, height: 1024.0): self = .iPad_Retina
            default: self = .iPhone_4
            }
        }
        
        typealias RawValue = CGSize
        
        case iPhone_4, iPhone_4_7, iPhone_5_5, iPhone_5_8, iPad_Retina
    }
    
    enum ScreenRatio: CGFloat {
        case iPhone_SE, iPhone_X, iPad_Retina
        typealias RawValue = CGFloat
        
        var rawValue: CGFloat {
            switch(self) {
            case .iPhone_SE:
                return 16.0/9.0 // se = 1.775, 6 = 1.779, Plus = 1.778
            case .iPhone_X:
                return 812.0/375.0 // 2.16533333
            case .iPad_Retina:
                return 4.0 / 3.0
            }
        }
        init(rawValue: CGFloat) {
            switch rawValue {
            case CGFloat(1.78): self = .iPhone_SE
            case CGFloat(2.17): self = .iPhone_X
            case CGFloat(1.33): self = .iPad_Retina
            case CGFloat(0.75): self = .iPad_Retina
            default: self = .iPhone_SE
            }
        }
    }
    static let originalWidth: CGFloat = 320.0
    static let originalHeight: CGFloat = 568.0
    
    static var screen: ScreenSize {
        return ScreenSize(rawValue: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    static var ratio: ScreenRatio {
        // round to nearest hundredth
        return ScreenRatio(rawValue: round((UIScreen.main.bounds.height / UIScreen.main.bounds.width) * 100) / 100)
    }
}

extension Int {
    var scaled: CGFloat {
        get {
            // take the average of the new width and height, divide it by the average of the old width and height
            // then multiply by the ratio of the ratio of the new screen with the ratio of the original screen if it is an iphone x
            if ScreenScale.ratio == .iPhone_SE {
                return CGFloat(self) * UIScreen.main.bounds.width / ScreenScale.originalWidth
            }
            else {
                return CGFloat(self) * (UIScreen.main.bounds.width + UIScreen.main.bounds.height) / (ScreenScale.originalWidth + ScreenScale.originalHeight)
            }
        }
    }
    
    var radians: CGFloat {
        get {
            return CGFloat(self).radians
        }
    }
}

extension Double {
    var scaled: CGFloat {
        get {
            // take the average of the new width and height, divide it by the average of the old width and height
            // then multiply by the ratio of the ratio of the new screen with the ratio of the original screen if it is an iphone x
            if ScreenScale.ratio == .iPhone_SE {
                return CGFloat(self) * UIScreen.main.bounds.width / ScreenScale.originalWidth
            }
            else {
                return CGFloat(self) * (UIScreen.main.bounds.width + UIScreen.main.bounds.height) / (ScreenScale.originalWidth + ScreenScale.originalHeight)
            }
        }
    }
    var radians: CGFloat {
        get {
            return CGFloat(self).radians
        }
    }
}

extension CGFloat {
    var radians: CGFloat {
        get {
            return self / 180.0 * CGFloat.pi
        }
    }
    
    static func scaleScreens(_ iPhone_4: CGFloat, _ iPhone_4_7: CGFloat = -1.0, _ iPhone_5_5: CGFloat = -1.0, _ iPhone_5_8: CGFloat = -1.0, _ iPad_Retina: CGFloat = -1.0) -> CGFloat {
        
        switch(ScreenScale.screen) {
        case .iPhone_4:
            return iPhone_4
        case .iPhone_4_7:
            return iPhone_4_7 >= 0 ? iPhone_4_7 : iPhone_4
        case .iPhone_5_5:
            return iPhone_5_5 >= 0 ? iPhone_5_5 : (iPhone_4_7 >= 0 ? iPhone_4_7 : iPhone_4)
        case .iPhone_5_8:
            return iPhone_5_8 >= 0 ? iPhone_5_8 : (iPhone_5_5 >= 0 ? iPhone_5_5 : (iPhone_4_7 >= 0 ? iPhone_4_7 : iPhone_4))
        case .iPad_Retina:
            return iPad_Retina >= 0 ? iPad_Retina : (iPhone_5_8 >= 0 ? iPhone_5_8 : (iPhone_5_5 >= 0 ? iPhone_5_5 : (iPhone_4_7 >= 0 ? iPhone_4_7 : iPhone_4)))
        }
    }
    
    static func scaleRatios(_ iPhone_SE: CGFloat, _ iPhone_X: CGFloat, _ iPad_Retina: CGFloat) -> CGFloat {
        switch ScreenScale.ratio {
        case .iPhone_SE:
            return iPhone_SE
        case .iPhone_X:
            return iPhone_X
        case .iPad_Retina:
            return iPad_Retina
        }
    }
}

