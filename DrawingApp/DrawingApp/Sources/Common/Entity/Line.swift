//
//  Line.swift
//  DrawingApp
//
//  Created by Dongyoung Kwon on 2023/11/12.
//

import Foundation

struct Line: Identifiable {
    let id = UUID()
    
    var points: [CGPoint]
    let color: SystemColor
}
