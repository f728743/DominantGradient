//
//  ColorfulBackground.swift
//  DominantGradient
//
//  Created by Alexey Vorobyov on 20.09.2023.
//

import SwiftUI

struct ColorfulBackground: View {
    @StateObject var vm = ColorfulBackgroundViewModel()
    let colors: [Color]

    var body: some View {
        MulticolorGradient(points: vm.points, bias: 0.05, power: 2.5, noise: 2)
        .onAppear {
            vm.set(colors)
            vm.onAppear()
        }
        .onChange(of: colors) {
            vm.set(colors)
        }
    }
}

#Preview {
    ColorfulBackground(colors: [.pink, .indigo, .cyan])
        .ignoresSafeArea()
}
