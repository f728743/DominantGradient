//
//  DominantColors.swift
//  DominantGradient
//
//  Created by Alexey Vorobyov on 18.09.2023.
//

import UIKit

struct ColorFrequency: Hashable {
    let color: UIColor
    let frequency: Double
}

enum DominantColorQuality {
    case low
    case fair
    case high
    case best
}

extension UIImage {
    func dominantColorFrequencies(
        with quality: DominantColorQuality = .fair
    ) -> [ColorFrequency]? {
        let image = cgImage?.colorSpace?.model == .rgb ? self : convertToRGBColorspace()
        let maxNumberOfColors = 500
        let targetSize = quality.targetSize(for: resolution)
        guard let colorCounts = image?
            .resize(to: targetSize)
            .cgImage?
            .colorCounts(maxAlpha: 150)?
            .sorted(by: { $0.count > $1.count })
            .prefix(maxNumberOfColors)
        else { return nil }

        let similarColors = mergeSimilar(colors: Array(colorCounts), diffThreshold: 6, maxCount: 20)
        let dominantColors = mergeSimilar(colors: similarColors, diffThreshold: 18, maxCount: 6)
        let totalDominantColors = dominantColors.reduce(into: 0) { $0 += $1.count }
        return dominantColors.map {
            let percentage = (Double($0.count) / Double(totalDominantColors))
            return .init(
                color: .init(red: $0.color.rgb.r, green: $0.color.rgb.g, blue: $0.color.rgb.b, alpha: 255),
                frequency: percentage
            )
        }
        .filter { $0.frequency > 0.005 }
    }
}

private func mergeSimilar(colors: [ColorCount], diffThreshold: CGFloat = 10.0, maxCount: Int) -> [ColorCount] {
    var result = [ColorCount]()
    for colorCount in colors {
        var bestMatchScore: CGFloat?
        var bestMatchColor: ColorCount?
        for dominantColor in result {
            let differenceScore =
                CGFloat(colorCount.color.lab.deltaECIE94(rhs: dominantColor.color.lab))
                    .rounded(.toNearestOrEven, precision: 100)
            if differenceScore < bestMatchScore ?? CGFloat(Int.max) {
                bestMatchScore = differenceScore
                bestMatchColor = dominantColor
            }
        }
        if let bestMatchScore = bestMatchScore, bestMatchScore < diffThreshold {
            bestMatchColor = bestMatchColor.map { .init(color: $0.color, count: $0.count + 1) }
        } else {
            result.append(colorCount)
        }
    }
    return result
        .prefix(maxCount)
        .sorted { $0.count > $1.count }
}

private struct RGBBytes: Hashable {
    let r: UInt8
    let g: UInt8
    let b: UInt8
}

private struct Color {
    let rgb: RGBBytes
    let lab: Lab
}

private struct ColorCount {
    let color: Color
    let count: Int
}

extension DominantColorQuality {
    var prefferedPixelCount: CGFloat? {
        switch self {
        case .low: return 1000
        case .fair: return 10000
        case .high: return 100_000
        case .best: return nil
        }
    }

    func targetSize(for size: CGSize) -> CGSize {
        guard let prefferedPixelCount = prefferedPixelCount else {
            return size
        }
        guard size.pixelCount > prefferedPixelCount else {
            return size
        }
        return size.transformToFit(in: prefferedPixelCount)
    }
}

private extension CGImage {
    func colorCounts(maxAlpha: UInt8) -> [ColorCount]? {
        guard colorSpace?.model == .rgb,
              bitsPerPixel == 32 || bitsPerPixel == 24,
              let data = dataProvider?.data,
              let dataPtr = CFDataGetBytePtr(data),
              let componentLayout = bitmapInfo.componentLayout
        else {
            return nil
        }

        let isAlphaPremultiplied = bitmapInfo.chromaIsPremultipliedByAlpha
        let bytesPerPixel = bitsPerPixel / 8
        let numPixels = CFDataGetLength(data) / bytesPerPixel

        return (0 ..< numPixels)
            .compactMap { pixelIndex in
                RGBBytes(
                    data: dataPtr + pixelIndex * bytesPerPixel,
                    layout: componentLayout,
                    isAlphaPremultiplied: isAlphaPremultiplied,
                    maxAlpha: maxAlpha
                )
            }
            .frequencies
            .map {
                ColorCount(
                    color: .init(rgb: $0.key),
                    count: $0.value
                )
            }
    }
}

extension Sequence where Element: Hashable {
    var frequencies: [Element: Int] {
        let frequencyPairs = map { ($0, 1) }
        return Dictionary(frequencyPairs, uniquingKeysWith: +)
    }
}

extension Color {
    init(rgb: RGBBytes) {
        self.rgb = rgb
        lab = .init(
            xyz: XYZ(
                r: (CGFloat(rgb.r) / 255).rounded(.toNearestOrEven, precision: 100),
                g: (CGFloat(rgb.g) / 255).rounded(.toNearestOrEven, precision: 100),
                b: (CGFloat(rgb.b) / 255).rounded(.toNearestOrEven, precision: 100)
            ).rounded(.toNearestOrEven, precision: 100)
        ).rounded(.toNearestOrEven, precision: 100)
    }
}

extension Lab {
    func rounded(_ rule: FloatingPointRoundingRule, precision: Int) -> Lab {
        .init(
            l: l.rounded(rule, precision: precision),
            a: a.rounded(rule, precision: precision),
            b: b.rounded(rule, precision: precision)
        )
    }
}

extension XYZ {
    func rounded(_ rule: FloatingPointRoundingRule, precision: Int) -> XYZ {
        .init(
            x: x.rounded(rule, precision: precision),
            y: y.rounded(rule, precision: precision),
            z: z.rounded(rule, precision: precision)
        )
    }
}

private extension CGFloat {
    func rounded(_ rule: FloatingPointRoundingRule, precision: Int) -> CGFloat {
        return (self * CGFloat(precision)).rounded(rule) / CGFloat(precision)
    }
}

private extension CGSize {
    var pixelCount: CGFloat {
        return width * height
    }

    /// Returns a new size of the target area, keeping the same aspect ratio.
    func transformToFit(in targetPixelCount: CGFloat) -> CGSize {
        let ratio = pixelCount / targetPixelCount
        let targetSize = CGSize(width: width / sqrt(ratio), height: height / sqrt(ratio))

        return targetSize
    }
}

extension RGBBytes {
    init?(
        data: UnsafePointer<UInt8>,
        layout: CGBitmapInfo.ComponentLayout,
        isAlphaPremultiplied: Bool,
        maxAlpha: UInt8
    ) {
        switch layout.count {
        case 3:
            let c0 = data[0]
            let c1 = data[1]
            let c2 = data[2]
            if layout == .bgr {
                self.init(r: c2, g: c1, b: c0)
            } else {
                self.init(r: c0, g: c1, b: c2)
            }
        case 4:
            let c0 = data[0]
            let c1 = data[1]
            let c2 = data[2]
            let c3 = data[3]
            let r: UInt8
            let g: UInt8
            let b: UInt8
            let a: UInt8
            switch layout {
            case .abgr:
                a = c0; b = c1; g = c2; r = c3
            case .argb:
                a = c0; r = c1; g = c2; b = c3
            case .bgra:
                b = c0; g = c1; r = c2; a = c3
            case .rgba:
                r = c0; g = c1; b = c2; a = c3
            default:
                return nil
            }
            if a < maxAlpha {
                return nil
            }
            if isAlphaPremultiplied, a > 0 {
                self.init(r: r / a, g: g / a, b: b / a)
            }
            self.init(r: r, g: g, b: b)
        default:
            self.init(r: 0, g: 0, b: 0)
        }
    }
}
