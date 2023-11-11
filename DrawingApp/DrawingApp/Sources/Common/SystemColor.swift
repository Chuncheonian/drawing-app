//
//  SystemColor.swift
//  DrawingApp
//
//  Created by Dongyoung Kwon on 2023/11/06.
//

import Foundation

enum SystemColor: String, CaseIterable {
    case blue, cyan, gray, mint, pink, teal
    case brown, green, indigo, orange, purple, yellow
    
    static var random: Self {
        SystemColor.allCases.randomElement() ?? .blue
    }
}
