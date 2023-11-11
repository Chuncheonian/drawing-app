//
//  CanvasViewModel.swift
//  DrawingApp
//
//  Created by Dongyoung Kwon on 2023/11/05.
//

import Combine
import Foundation

final class CanvasViewModel {
    
    // MARK: - input & output
    
    struct Input {
        let canvasViewRect: CurrentValueSubject<CGRect, Never>
        let onTapRectangleItemButton: PassthroughSubject<Void, Never>
        let onTapRectangleView: PassthroughSubject<Rectangle, Never>
    }
    
    struct Output {
        let appendRectangleView: PassthroughSubject<Rectangle, Never>
        let updateRectangleView: PassthroughSubject<Rectangle, Never>
    }
    
    // MARK: - property
    
    // INTERNAL
    let input: Input
    private(set) var output: Output
    
    // PRIVATE
    private var cancellables: Set<AnyCancellable> = .init()
    
    // PRIVATE - INPUT
    private let canvasViewRect: CurrentValueSubject<CGRect, Never> = .init(.zero)
    private let onTapRectangleItemButton: PassthroughSubject<Void, Never> = .init()
    private let onTapRectangleView: PassthroughSubject<Rectangle, Never> = .init()
    
    // PRIVATE - OUTPUT
    private let appendRectangleView: PassthroughSubject<Rectangle, Never> = .init()
    private let updateRectangleView: PassthroughSubject<Rectangle, Never> = .init()
    
    // MARK: - initialize
    
    init() {
        self.input = .init(
            canvasViewRect: canvasViewRect,
            onTapRectangleItemButton: onTapRectangleItemButton,
            onTapRectangleView: onTapRectangleView
        )
        self.output = .init(
            appendRectangleView: appendRectangleView,
            updateRectangleView: updateRectangleView
        )
        
        transform()
    }
}

// MARK: - transform

extension CanvasViewModel {
    private func transform() {
        
        onTapRectangleItemButton
            .sink(receiveValue: { [weak self] in
                guard let self else { return }
                
                let canvasRect = self.canvasViewRect.value
                let rectangleEdge = 100
                
                let rectangleX = Int(canvasRect.minX)...(Int(canvasRect.maxX)-rectangleEdge)
                let rectangleY = Int(canvasRect.minY)...(Int(canvasRect.maxY)-rectangleEdge)
                
                if let randomX = rectangleX.randomElement(),
                   let randomY = rectangleY.randomElement() {
                    
                    let newRectangle = Rectangle.init(
                        rect: .init(x: randomX, y: randomY, width: rectangleEdge, height: rectangleEdge),
                        backgroundColor: SystemColor.randomExcludingRed,
                        isSelected: false
                    )
                    
                    appendRectangleView.send(newRectangle)
                }
            })
            .store(in: &cancellables)
        
        onTapRectangleView
            .sink(receiveValue: { [weak self] rectangle in
                guard let self else { return }
                
                var _rectangle = rectangle
                _rectangle.isSelected.toggle()
                updateRectangleView.send(_rectangle)
            })
            .store(in: &cancellables)
    }
}

extension CanvasViewModel {
    
}
