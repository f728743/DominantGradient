//
//  ArtworkGradientViewModel.swift
//  DominantGradient
//
//  Created by Alexey Vorobyov on 14.09.2023.
//

import SwiftUI

class ArtworkGradientViewModel: ObservableObject {
    let images = [
        "radio_01_class_rock", "radio_02_pop", "radio_03_hiphop_new",
        "radio_04_punk", "radio_05_talk_01", "radio_06_country",
        "radio_07_dance_01", "radio_08_mexican", "radio_09_hiphop_old",
        "radio_11_talk_02", "radio_12_reggae", "radio_13_jazz",
        "radio_14_dance_02", "radio_15_motown", "radio_16_silverlake",
        "radio_17_funk", "radio_18_90s_rock"
    ]

    @Published var currentImageIndex = 0 {
        didSet {
            updateColors()
        }
    }

    @Published var colors: [ColorFrequency] = []
    @Published var points: [ColorSpot] = []

    var currentImage: String {
        images[currentImageIndex]
    }

    func onAppear() {
        updateColors()
    }

    func next() {
        guard images.count > 0 else { return }
        var next = currentImageIndex + 1
        if next >= images.count {
            next = 0
        }
        currentImageIndex = next
    }

    func prev() {
        guard images.count > 0 else { return }
        var prev = currentImageIndex - 1
        if prev < 0 {
            prev = images.count - 1
        }
        currentImageIndex = prev
    }
}

private extension ArtworkGradientViewModel {
    func updateColors() {
        guard let dominantColors = UIImage(named: currentImage)?
            .dominantColorFrequencies(with: .high) else { return }
        colors = dominantColors
        withAnimation {
            points = dominantColors.map { .random(withColor: Color($0.color)) }
        }
    }
}

#Preview {
    ArtworkGradient()
}
