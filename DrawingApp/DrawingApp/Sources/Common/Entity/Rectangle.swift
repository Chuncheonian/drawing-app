//
//  Rectangle.swift
//  DrawingApp
//
//  Created by Dongyoung Kwon on 2023/11/06.
//

import Foundation

struct Rectangle: Identifiable {
    let id = UUID()
    
    let rect: CGRect
    let backgroundColor: SystemColor
    
    var isSelected: Bool {
        didSet {
            boarderWidth = isSelected ? 5 : 0
        }
    }
    
    let borderColor: SystemColor = .red
    
    var boarderWidth: CGFloat = 0
}
