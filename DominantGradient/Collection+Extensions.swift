//
//  Collection+Extensions.swift
//  DominantGradient
//
//  Created by Alexey Vorobyov on 09.10.2023.
//

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
