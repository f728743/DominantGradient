//
//  Lab+ColorDifference.swift
//  DominantGradient
//
//  Created by Alexey Vorobyov on 20.09.2023.
//

import Foundation

extension Lab {
    func deltaECIE94(rhs: Lab) -> Double {
        let lhs = self

        let kL = 1.0
        let kC = 1.0
        let kH = 1.0
        let k1 = 0.045
        let k2 = 0.015
        let sL = 1.0

        let c1 = sqrt(pow(lhs.a, 2) + pow(lhs.b, 2))
        let sC = 1 + k1 * c1
        let sH = 1 + k2 * c1

        let deltaL = lhs.l - rhs.l
        let deltaA = lhs.a - rhs.a
        let deltaB = lhs.b - rhs.b

        let c2 = sqrt(pow(rhs.a, 2) + pow(rhs.b, 2))
        let deltaCab = c1 - c2

        let deltaHab = sqrt(pow(deltaA, 2) + pow(deltaB, 2) - pow(deltaCab, 2))

        let p1 = pow(deltaL / (kL * sL), 2)
        let p2 = pow(deltaCab / (kC * sC), 2)
        let p3 = pow(deltaHab / (kH * sH), 2)

        return sqrt(p1 + p2 + p3)
    }
}
