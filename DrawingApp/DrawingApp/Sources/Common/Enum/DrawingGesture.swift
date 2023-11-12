//
//  DrawingGesture.swift
//  DrawingApp
//
//  Created by Dongyoung Kwon on 2023/11/12.
//

import Foundation

enum DrawingGesture {
    case began(point: CGPoint)
    case changed(point: CGPoint)
    case ended
}
