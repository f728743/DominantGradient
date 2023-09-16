//
//  UIColor+Extensions.swift
//  DominantGradient
//
//  Created by Alexey Vorobyov on 19.09.2023.
//

import UIKit

public extension UIColor {
    convenience init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }
}
