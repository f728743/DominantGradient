//
//  ColorfulBackground.swift
//  DominantGradient
//
//  Created by Alexey Vorobyov on 20.09.2023.
//

import SwiftUI

struct ColorfulBackground: View {
    static let animationDuration: Double = 5

    @Binding var points: [ColorSpot]
    let timer = Timer
        .publish(every: ColorfulBackground.animationDuration * 0.9, on: .main, in: .common)
        .autoconnect()

    var body: some View {
        MulticolorGradient(
            points: points,
            bias: 0.05,
            power: 2.5,
            noise: 2
        )
        .onReceive(timer) { _ in animate() }
        .onAppear { animate() }
    }

    func animate() {
        withAnimation(.easeInOut(duration: ColorfulBackground.animationDuration)) {
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

#Preview {
    ColorfulBackground(
        points: .constant(
            [.pink, .indigo, .cyan].map { .random(withColor: $0) }
        )
    ).ignoresSafeArea()
}
