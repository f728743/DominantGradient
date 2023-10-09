//
//  ColorPoint.swift
//  RandomPathAinmation
//
//  Created by Alexey Vorobyov on 09.09.2023.
//

import SwiftUI

struct ColorPoint: Hashable {
    var position: UnitPoint
    var color: Color
}

extension ColorPoint: CustomStringConvertible {
    var description: String {
        String(format: "Point(x=%.3f,y=%.3f,c=\(UIColor(color).hex))", position.x, position.y)
    }
}

extension ColorPoint: Animatable {
    typealias AnimatableData = AnimatablePair<UnitPoint.AnimatableData, Color.Resolved.AnimatableData>

    var animatableData: ColorPoint.AnimatableData {
        get {
            .init(position.animatableData, color.resolve(in: .init()).animatableData)
        }
        set {
            position = .init(newValue.first)
            color = .init(newValue.second)
        }
    }
}

private extension ColorPoint {
    static var zero: ColorPoint {
        .init(position: .zero, color: .black.opacity(0))
    }

    init(_ animatableData: ColorPoint.AnimatableData) {
        self.init(
            position: .init(animatableData.first),
            color: .init(animatableData.second)
        )
    }
}

private extension Color {
    init(_ animatableData: Color.Resolved.AnimatableData) {
        var resolvedColor = Color.Resolved(red: 0, green: 0, blue: 0)
        resolvedColor.animatableData = animatableData
        self.init(resolvedColor)
    }
}

private extension UnitPoint {
    static let animatableDataRatio =
        UnitPoint(x: 1, y: 1).animatableData.first / UnitPoint(x: 1, y: 1).x

    init(_ animatableData: UnitPoint.AnimatableData) {
        self.init(
            x: animatableData.first / UnitPoint.animatableDataRatio,
            y: animatableData.second / UnitPoint.animatableDataRatio
        )
    }
}

struct ColorPoints {
    let point0: ColorPoint
    let point1: ColorPoint
    let point2: ColorPoint
    let point3: ColorPoint
    let point4: ColorPoint
    let point5: ColorPoint
    let point6: ColorPoint
    let point7: ColorPoint
}

struct ColorPointsAnimatableData {
    var value0: ColorPoint.AnimatableData
    var value1: ColorPoint.AnimatableData
    var value2: ColorPoint.AnimatableData
    var value3: ColorPoint.AnimatableData
    var value4: ColorPoint.AnimatableData
    var value5: ColorPoint.AnimatableData
    var value6: ColorPoint.AnimatableData
    var value7: ColorPoint.AnimatableData
}

extension ColorPoints {
    init(points: [ColorPoint]) {
        self.init(
            point0: points[safe: 0] ?? .init(position: .zero, color: .black.opacity(0)),
            point1: points[safe: 1] ?? .init(position: .zero, color: .black.opacity(0)),
            point2: points[safe: 2] ?? .init(position: .zero, color: .black.opacity(0)),
            point3: points[safe: 3] ?? .init(position: .zero, color: .black.opacity(0)),
            point4: points[safe: 4] ?? .init(position: .zero, color: .black.opacity(0)),
            point5: points[safe: 5] ?? .init(position: .zero, color: .black.opacity(0)),
            point6: points[safe: 6] ?? .init(position: .zero, color: .black.opacity(0)),
            point7: points[safe: 7] ?? .init(position: .zero, color: .black.opacity(0))
        )
    }

    init(_ animatableData: ColorPointsAnimatableData) {
        self.init(
            point0: .init(animatableData.value0),
            point1: .init(animatableData.value1),
            point2: .init(animatableData.value2),
            point3: .init(animatableData.value3),
            point4: .init(animatableData.value4),
            point5: .init(animatableData.value5),
            point6: .init(animatableData.value6),
            point7: .init(animatableData.value7)
        )
    }

    static var zero: ColorPoints {
        .init(
            point0: .zero,
            point1: .zero,
            point2: .zero,
            point3: .zero,
            point4: .zero,
            point5: .zero,
            point6: .zero,
            point7: .zero
        )
    }

    var suffled: ColorPoints {
        .init(
            point0: .random(withColor: point0.color),
            point1: .random(withColor: point1.color),
            point2: .random(withColor: point2.color),
            point3: .random(withColor: point3.color),
            point4: .random(withColor: point4.color),
            point5: .random(withColor: point5.color),
            point6: .random(withColor: point6.color),
            point7: .random(withColor: point7.color)
        )
    }

    func colored(colors: [Color]) -> ColorPoints {
        .init(
            point0: .init(position: point0.position, color: colors[safe: 0] ?? .black.opacity(0)),
            point1: .init(position: point1.position, color: colors[safe: 1] ?? .black.opacity(0)),
            point2: .init(position: point2.position, color: colors[safe: 2] ?? .black.opacity(0)),
            point3: .init(position: point3.position, color: colors[safe: 3] ?? .black.opacity(0)),
            point4: .init(position: point4.position, color: colors[safe: 4] ?? .black.opacity(0)),
            point5: .init(position: point5.position, color: colors[safe: 5] ?? .black.opacity(0)),
            point6: .init(position: point6.position, color: colors[safe: 6] ?? .black.opacity(0)),
            point7: .init(position: point7.position, color: colors[safe: 7] ?? .black.opacity(0))
        )
    }
}

extension ColorPoints: Animatable {
    var animatableData: ColorPointsAnimatableData {
        get { .init(self) }
        set { self = .init(newValue) }
    }
}

extension ColorPointsAnimatableData {
    init(_ colorPoints: ColorPoints) {
        self.init(
            value0: colorPoints.point0.animatableData,
            value1: colorPoints.point1.animatableData,
            value2: colorPoints.point2.animatableData,
            value3: colorPoints.point3.animatableData,
            value4: colorPoints.point4.animatableData,
            value5: colorPoints.point5.animatableData,
            value6: colorPoints.point6.animatableData,
            value7: colorPoints.point7.animatableData
        )
    }
}

extension ColorPointsAnimatableData: VectorArithmetic {
    static func - (lhs: ColorPointsAnimatableData, rhs: ColorPointsAnimatableData) -> ColorPointsAnimatableData {
        .init(
            value0: lhs.value0 - rhs.value0,
            value1: lhs.value1 - rhs.value1,
            value2: lhs.value2 - rhs.value2,
            value3: lhs.value3 - rhs.value3,
            value4: lhs.value4 - rhs.value4,
            value5: lhs.value5 - rhs.value5,
            value6: lhs.value6 - rhs.value6,
            value7: lhs.value7 - rhs.value7
        )
    }

    static func + (lhs: ColorPointsAnimatableData, rhs: ColorPointsAnimatableData) -> ColorPointsAnimatableData {
        .init(
            value0: lhs.value0 + rhs.value0,
            value1: lhs.value1 + rhs.value1,
            value2: lhs.value2 + rhs.value2,
            value3: lhs.value3 + rhs.value3,
            value4: lhs.value4 + rhs.value4,
            value5: lhs.value5 + rhs.value5,
            value6: lhs.value6 + rhs.value6,
            value7: lhs.value7 + rhs.value7
        )
    }

    mutating func scale(by rhs: Double) {
        value0 = value0.scaled(by: rhs)
        value1 = value1.scaled(by: rhs)
        value2 = value2.scaled(by: rhs)
        value3 = value3.scaled(by: rhs)
        value4 = value4.scaled(by: rhs)
        value5 = value5.scaled(by: rhs)
        value6 = value6.scaled(by: rhs)
        value7 = value7.scaled(by: rhs)
    }

    var magnitudeSquared: Double {
        value0.magnitudeSquared +
            value1.magnitudeSquared +
            value2.magnitudeSquared +
            value3.magnitudeSquared +
            value4.magnitudeSquared +
            value5.magnitudeSquared +
            value6.magnitudeSquared +
            value7.magnitudeSquared
    }

    static var zero: ColorPointsAnimatableData {
        .init(
            value0: .zero,
            value1: .zero,
            value2: .zero,
            value3: .zero,
            value4: .zero,
            value5: .zero,
            value6: .zero,
            value7: .zero
        )
    }
}
