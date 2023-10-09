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
        MulticolorGradient(
            points: vm.points,
            animationUpdateHandler: vm.onUpdate(animatedData:)
        )
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
