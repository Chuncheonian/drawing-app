//
//  UIColor+.swift
//  DrawingApp
//
//  Created by Dongyoung Kwon on 2023/11/11.
//

import UIKit

extension UIColor {
    
    static func makeUIColor(for systemColor: SystemColor) -> UIColor {
        switch systemColor {
        case .blue: return .systemBlue
        case .cyan: return .systemCyan
        case .gray: return .systemGray
        case .mint: return .systemMint
        case .pink: return .systemPink
        case .teal: return .systemTeal
        case .brown: return .systemBrown
        case .green: return .systemGreen
        case .indigo: return .systemIndigo
        case .orange: return .systemOrange
        case .purple: return .systemPurple
        case .yellow: return .systemYellow
        case .red: return .systemRed
        }
    }
}
