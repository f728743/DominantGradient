//
//  DominantColorsTests.swift
//  DominantGradientTests
//
//  Created by Alexey Vorobyov on 18.09.2023.
//

@testable import DominantGradient
import XCTest

final class DominantColorsTests: XCTestCase {
    func testDominantColor() {
        let image1 = UIImage(named: "radio_15_motown")
        let image2 = UIImage(named: "radio_03_hiphop_new")

        let hexColors1 = (image1?.dominantColorFrequencies(with: .high) ?? []).map { $0.color.hex }
        let hexColors2 = (image2?.dominantColorFrequencies(with: .high) ?? []).map { $0.color.hex }

        XCTAssertEqual(hexColors1, ["#563C2A", "#F99B06", "#FFFFFF"])
        XCTAssertEqual(hexColors2, ["#020202", "#F5F5F5", "#010101", "#FAAC18"])
    }

    func testDominantColorPerformance() throws {
        let image = UIImage(named: "radio_15_motown")
        measure {
            _ = image?.dominantColorFrequencies(with: .high)
        }
    }
}

extension UIColor {
    var hex: String {
        let components = cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        return String(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
    }
}
