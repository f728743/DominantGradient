//
//  BlurView.swift
//  DominantGradient
//
//  Created by Alexey Vorobyov on 20.09.2023.
//

import SwiftUI
import UIKit

struct VisualEffect: UIViewRepresentable {
    var effect: UIVisualEffect
    let intensity: CGFloat

    init(effect: UIVisualEffect, intensity: CGFloat = 1) {
        self.effect = effect
        self.intensity = intensity
    }

    init(style: UIBlurEffect.Style, intensity: CGFloat = 1) {
        self.init(effect: UIBlurEffect(style: style), intensity: intensity)
    }

    func makeUIView(context _: Context) -> UIVisualEffectView {
        VisualEffectVuew(effect: effect, intensity: intensity)
    }

    func updateUIView(_ uiView: UIVisualEffectView, context _: Context) {
        uiView.effect = effect
    }
}

private class VisualEffectVuew: UIVisualEffectView {
    private let theEffect: UIVisualEffect
    private let customIntensity: CGFloat
    private var animator: UIViewPropertyAnimator?

    init(effect: UIVisualEffect, intensity: CGFloat) {
        theEffect = effect
        customIntensity = intensity
        super.init(effect: nil)
    }

    required init?(coder _: NSCoder) { nil }

    deinit {
        animator?.stopAnimation(true)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        effect = nil
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in
            self.effect = theEffect
        }
        animator?.fractionComplete = customIntensity
    }
}
