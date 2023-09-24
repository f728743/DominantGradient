//
//  MulticolorGradient.swift
//  RandomPathAinmation
//
//  Created by Alexey Vorobyov on 09.09.2023.
//

import SwiftUI

struct MulticolorGradient: View, Animatable {
    var points: ColorSpots
    var bias: Float  = 0.001
    var power: Float = 2
    var noise: Float = 2

    var uniforms: Uniforms {
        .init(params: .init(spots: points, bias: bias, power: power, noise: noise))
    }

    var animatableData: ColorSpots.AnimatableData {
        get {
            points.animatableData
        }
        set {
            points = .init(newValue)
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
        points: [
            .init(position: .top, color: .pink),
            .init(position: .leading, color: .indigo),
            .init(position: .bottomTrailing, color: .cyan)
        ]
    )
    .ignoresSafeArea()
}
