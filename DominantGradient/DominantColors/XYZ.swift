//
//  XYZ.swift
//  DominantGradient
//
//  Created by Alexey Vorobyov on 20.09.2023.
//

import UIKit

struct XYZ: Equatable {
    let x: CGFloat
    let y: CGFloat
    let z: CGFloat
}

extension XYZ {
    init(r: CGFloat, g: CGFloat, b: CGFloat) {
        func transform(value: Double) -> Double {
            value > 0.04045 ? pow((value + 0.055) / 1.055, 2.4) : value / 12.92
        }

        let red = transform(value: r) * 100.0
        let green = transform(value: g) * 100.0
        let blue = transform(value: b) * 100.0

        self.init(
            x: red * 0.4124 + green * 0.3576 + blue * 0.1805,
            y: red * 0.2126 + green * 0.7152 + blue * 0.0722,
            z: red * 0.0193 + green * 0.1192 + blue * 0.9505
        )
    }
}
