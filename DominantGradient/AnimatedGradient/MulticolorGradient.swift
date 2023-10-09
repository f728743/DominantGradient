//
//  MulticolorGradient.swift
//  RandomPathAinmation
//
//  Created by Alexey Vorobyov on 09.09.2023.
//

import SwiftUI

struct MulticolorGradient: View, Animatable {
    var points: ColorPoints
    var animationUpdateHandler: ((ColorPoints) -> Void)?

    var uniforms: Uniforms {
        .init(params: .init(points: points, bias: 0.05, power: 2.5, noise: 2))
    }

    var animatableData: ColorPoints.AnimatableData {
        get {
            points.animatableData
        }
        set {
            points = .init(newValue)
            animationUpdateHandler?(points)
        }
    }

    var body: some View {
        Rectangle()
            .colorEffect(ShaderLibrary.gradient(.boundingRect, .uniforms(uniforms)))
    }
}

extension Shader.Argument {
    static func uniforms(_ param: Uniforms) -> Shader.Argument {
        var copy = param
        return .data(Data(bytes: &copy, count: MemoryLayout<Uniforms>.stride))
    }
}

#Preview {
    MulticolorGradient(
        points: .init(
            points: [
                .init(position: .top, color: .pink),
                .init(position: .leading, color: .indigo),
                .init(position: .bottomTrailing, color: .cyan)
            ]
        )
    )
    .ignoresSafeArea()
}
