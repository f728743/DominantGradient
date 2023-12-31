//
//  ColorfulBackgroundViewModel.swift
//  DominantGradient
//
//  Created by Alexey Vorobyov on 24.09.2023.
//

import Combine
import SwiftUI

class ColorfulBackgroundViewModel: ObservableObject {
    static let animationDuration: Double = 20
    @Published var points: ColorPoints = .zero.suffled

    private var colors: [Color] = []
    private var shown = false
    private var animatedData: ColorPoints = .zero
    private var animatioTimerCancellable: AnyCancellable?

    func onAppear() {
        shown = true
        animate()
        animatedData = points

        animatioTimerCancellable = Timer
            .publish(every: Self.animationDuration * 0.9, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.animate()
            }
    }

    func onUpdate(animatedData: ColorPoints) {
        self.animatedData = animatedData
    }

    func set(_ colors: [Color]) {
        guard colors != self.colors else { return }
        self.colors = colors
        if shown {
            withAnimation {
                points = animatedData.colored(colors: colors)
            }
        } else {
            points = animatedData.colored(colors: colors)
        }
    }

    func animate() {
        withAnimation(.linear(duration: Self.animationDuration)) {
            points = points.suffled
        }
    }
}

extension ColorPoint {
    static func random(withColor color: Color) -> ColorPoint {
        .init(
            position: .init(x: CGFloat.random(in: 0 ..< 1), y: CGFloat.random(in: 0 ..< 1)),
            color: color
        )
    }
}
