//
//  Lab.swift
//  DominantGradient
//
//  Created by Alexey Vorobyov on 20.09.2023.
//

import UIKit

public struct Lab {
    let l: CGFloat
    let a: CGFloat
    let b: CGFloat
}

extension Lab {
    init(xyz: XYZ) {
        let refX = 95.047
        let refY = 100.0
        let refZ = 108.883

        func transform(value: Double) -> Double {
            value > 0.008856 ? pow(value, 1 / 3) : (7.787 * value) + (16 / 116)
        }

        let x = transform(value: xyz.x / refX)
        let y = transform(value: xyz.y / refY)
        let z = transform(value: xyz.z / refZ)

        self.init(
            l: (116.0 * y) - 16.0,
            a: 500.0 * (x - y),
            b: 200.0 * (y - z)
        )
    }
}
