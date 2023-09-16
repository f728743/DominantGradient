//
//  ArtworkGradient.swift
//  DominantGradient
//
//  Created by Alexey Vorobyov on 14.09.2023.
//

import SwiftUI

struct ArtworkGradient: View {
    @StateObject var vm = ArtworkGradientViewModel()
    private var columns = Array(
        repeating: GridItem(.flexible(), spacing: 14),
        count: 5
    )

    var body: some View {
        ScrollView {
            VStack(spacing: 80) {
                image
                controls
                colorSwatches
                Spacer()
            }
        }
        .onAppear {
            vm.onAppear()
        }
    }
}

private extension ArtworkGradient {
    var image: some View {
        Image(vm.currentImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .shadow(radius: 10)
            }
            .padding(40)
    }

    var colorSwatches: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            ForEach(vm.colors, id: \.self) { color in
                ZStack(alignment: .bottom) {
                    Color(uiColor: color.color)
                        .frame(width: 44, height: 44)
                        .cornerRadius(5)
                        .shadow(color: .primary.opacity(0.3), radius: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(UIColor.systemGray3), lineWidth: 1)
                        )
                    Text(String(format: "%.4f", color.frequency))
                        .font(.system(size: 8))
                        .background(Color.white)
                        .foregroundColor(.black)
                        .padding(.bottom, 4)
                }
            }
        }
    }

    var controls: some View {
        HStack(spacing: 40) {
            Button(
                action: { vm.prev() },
                label: { Image(systemName: "backward.fill") }
            )
            Button(
                action: { vm.next() },
                label: { Image(systemName: "forward.fill") }
            )
        }
        .foregroundColor(.primary)
        .font(.system(size: 40))
    }
}

#Preview {
    ArtworkGradient()
}
