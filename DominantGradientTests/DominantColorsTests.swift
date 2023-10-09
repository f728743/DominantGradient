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
