//
//  UIFont+Custom.swift
//  Cars
//
//  Created by Ravi Vora on 25/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    public enum SFUIType: String {
        case medium = "-Medium"
    }

    static func SFUI(_ type: SFUIType = .medium, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: "SFUIDisplay\(type.rawValue)", size: size)!
    }

    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }

    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
}
