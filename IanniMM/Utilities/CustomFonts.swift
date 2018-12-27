//
//  CustomFonts.swift
//  IanniMM
//
//  Created by Kevin Bai on 2018-04-09.
//  Copyright © 2018 Kevin Bai. All rights reserved.
//

import UIKit

struct Dosis: CustomFontType {
    let prefix = "Dosis"
    let acceptedWeights: [FontWeight] = [.extraLight, .light, .regular, .medium, .semiBold, .bold, .extraBold]
}
struct SFCompactDisplay: CustomFontType {
    let prefix = "SFCompactDisplay"
    let acceptedWeights: [FontWeight] = [.thin, .ultraLight, .light, .regular, .medium, .semiBold, .bold, .black, .heavy]
}
struct Nunito: CustomFontType {
    let prefix: String = "Nunito"
    let acceptedWeights: [FontWeight] = [.extraLight, .extraLightItalic, .light, .lightItalic, .regular, .regularItalic, .semiBold, .semiBoldItalic, .bold, .boldItalic, .extraBold, .extraBoldItalic, .black, .blackItalic]
}

struct SourceCodePro: CustomFontType {
    let prefix: String = "SourceCodePro"
    let acceptedWeights: [FontWeight] = [
        .extraLight, .light, .regular, .medium, .semiBold, .bold, .black
    ]
}

struct SFCompactText: CustomFontType {
    let prefix = "SFCompactText"
    let acceptedWeights: [FontWeight] = [.light, .lightItalic, .regular, .regularItalic, .medium, .mediumItalic, .semiBold, .semiBoldItalic, .bold, .boldItalic, .heavy, .heavyItalic]
}

extension UIFont {
    static var main: CustomFontType = SourceCodePro()
    static var secondary: CustomFontType = SourceCodePro()
    static var highlight: CustomFontType = SourceCodePro()
    
    class func dosis(_ type: FontWeight, _ size: CGFloat) -> UIFont? {
        return UIFont(name: "Dosis-\(type.rawValue.1)", size: size)
    }
    
    class func mainFont(_ weight: FontWeight, _ size: CGFloat) -> UIFont? {
        return main.fontFor(weight: weight, size: size)
    }
    class func secondaryFont(_ weight: FontWeight, _ size: CGFloat) -> UIFont? {
        return secondary.fontFor(weight: weight, size: size)
    }
}

protocol CustomFontType {
    var prefix: String { get }
    var acceptedWeights: [FontWeight] { get }
    func fontFor(weight: FontWeight, size: CGFloat) -> UIFont?
}
extension CustomFontType {
    func fontFor(weight: FontWeight, size: CGFloat) -> UIFont? {
        let closestWeight = weight.getClosestFontWeight(fontType: self)
        guard let newWeight = closestWeight else {
            return nil
        }
        return UIFont(name: "\(self.prefix)-\(newWeight.rawValue.1)", size: size)
    }
}


enum FontWeightGroup: Double {
    case lighter = 4.0, regular = 5.0, heavier = 11.0
}

enum FontWeight: RawRepresentable {
    typealias RawValue = (Double, String)
    init?(rawValue: (Double, String)) {
        self = .regular
    }
    
    case thin, thinItalic, ultraLight, ultraLightItalic, extraLight, extraLightItalic, light, lightItalic, regular, regularItalic, medium, mediumItalic, semiBold, semiBoldItalic, bold, boldItalic, extraBold, extraBoldItalic, heavy, heavyItalic, black, blackItalic

    
    var rawValue: (Double, String) {
        switch self {
        case .thin:
            return (0.0, "Thin")
        case .thinItalic:
            return (0.5, "ThinItalic")
        case .ultraLight:
            return (1.0, "UltraLight")
        case .ultraLightItalic:
            return (1.5, "UltraLightItalic")
        case .extraLight:
            return (2.0, "ExtraLight")
        case .extraLightItalic:
            return (2.5, "ExtraLightItalic")
        case .light:
            return (3.0, "Light")
        case .lightItalic:
            return (3.5, "LightItalic")
        case .regular:
            return (4.0, "Regular")
        case .regularItalic:
            return (4.5, "RegularItalic")
        case .medium:
            return (5.0, "Medium")
        case .mediumItalic:
            return (5.5, "MediumItalic")
        case .semiBold:
            return (6.0, "SemiBold")
        case .semiBoldItalic:
            return (6.5, "SemiBoldItalic")
        case .bold:
            return (7.0, "Bold")
        case .boldItalic:
            return (7.5, "BoldItalic")
        case .extraBold:
            return (8.0, "ExtraBold")
        case .extraBoldItalic:
            return (8.5, "ExtraBoldItalic")
        case .heavy:
            return (9.0, "Heavy")
        case .heavyItalic:
            return (9.5, "HeavyItalic")
        case .black:
            return (10.0, "Black")
        case .blackItalic:
            return (10.5, "BlackItalic")
        }
    }
    
    var weightGroup: FontWeightGroup {
        get {
            if self.rawValue.0 < FontWeightGroup.lighter.rawValue {
                return FontWeightGroup.lighter
            }
            else if self.rawValue.0 < FontWeightGroup.regular.rawValue {
                return FontWeightGroup.regular
            }
            else {
                return FontWeightGroup.heavier
            }
        }
    }
    
    
    
    func getClosestFontWeight(fontType: CustomFontType) -> FontWeight? {
        if fontType.acceptedWeights.contains(self) { return self }
        
        var minRange = 0.0
        var maxRange = FontWeightGroup.lighter.rawValue
        if self.weightGroup == .regular {
            minRange = FontWeightGroup.lighter.rawValue
            maxRange = FontWeightGroup.regular.rawValue
        }
        else if self.weightGroup == .heavier {
            minRange = FontWeightGroup.regular.rawValue
            maxRange = FontWeightGroup.heavier.rawValue
        }
        
        func weightInRange(weight: FontWeight) -> Bool {
            return weight.rawValue.0 >= minRange && weight.rawValue.0 < maxRange
        }
        
        var closestWeight: FontWeight?
        var minDistance = 50.0 // just a placeholder
        for weight in fontType.acceptedWeights {
            if weightInRange(weight: weight) {
                let distance = abs(weight.rawValue.0 - self.rawValue.0)
                if distance < minDistance && round(distance) == distance {
                    minDistance = distance
                    closestWeight = weight
                }
            }
        }
        return closestWeight
    }
    
}
