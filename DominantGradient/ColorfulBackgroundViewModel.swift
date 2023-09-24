//
//  ColorfulBackgroundViewModel.swift
//  DominantGradient
//
//  Created by Alexey Vorobyov on 24.09.2023.
//

import Combine
import SwiftUI

class ColorfulBackgroundViewModel: ObservableObject {
    static let animationDuration: Double = 5
    @Published var points: [ColorSpot] = []

    private var colors: [Color] = []
    private var shown = false
    private var animatioTimerCancellable: AnyCancellable?

    func onAppear() {
        shown = true
        animate()

        animatioTimerCancellable = Timer
            .publish(every: ColorfulBackgroundViewModel.animationDuration * 0.9, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.animate()
            }
    }

    func set(_ colors: [Color]) {
        guard colors != self.colors else { return }
        self.colors = colors
        if shown {
            withAnimation {
                points = colors.map { .random(withColor: $0) }
            }
        } else {
            points = colors.map { .random(withColor: $0) }
        }
    }

    func animate() {
        withAnimation(.linear(duration: ColorfulBackgroundViewModel.animationDuration)) {
            points = points.map { .random(withColor: $0.color) }
        }
    }
}

extension ColorSpot {
    static func random(withColor color: Color) -> ColorSpot {
        .init(
            position: .init(x: CGFloat.random(in: 0 ..< 1), y: CGFloat.random(in: 0 ..< 1)),
            color: color
        )
    }
}
