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
        let drawLine: PassthroughSubject<DrawingGesture, Never>
    }
    
    struct Output {
        let appendRectangleView: PassthroughSubject<Rectangle, Never>
        let updateRectangleView: PassthroughSubject<Rectangle, Never>
        let currentLine: PassthroughSubject<Line?, Never>
    }
    
    // MARK: - property
    
    // INTERNAL
    let input: Input
    private(set) var output: Output
    
    // PRIVATE
    private var cancellables: Set<AnyCancellable> = .init()
    private let drawingUseCase: any DrawingUseCase
    
    // PRIVATE - INPUT
    private let canvasViewRect: CurrentValueSubject<CGRect, Never> = .init(.zero)
    private let onTapRectangleItemButton: PassthroughSubject<Void, Never> = .init()
    private let onTapRectangleView: PassthroughSubject<Rectangle, Never> = .init()
    
    // PRIVATE - OUTPUT
    private let appendRectangleView: PassthroughSubject<Rectangle, Never> = .init()
    private let updateRectangleView: PassthroughSubject<Rectangle, Never> = .init()
    
    // MARK: - initialize
    
    init(drawingUseCase: any DrawingUseCase){
        self.input = .init(
            canvasViewRect: canvasViewRect,
            onTapRectangleItemButton: onTapRectangleItemButton,
            onTapRectangleView: onTapRectangleView,
            drawLine: .init()
        )
        self.output = .init(
            appendRectangleView: appendRectangleView,
            updateRectangleView: updateRectangleView,
            currentLine: .init()
        )
        self.drawingUseCase = drawingUseCase
        
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
        
        input.drawLine
            .sink(receiveValue: { [weak self] drawingGesture in
                guard let self else { return }
                
                switch drawingGesture {
                case .began(let point):
                    let lineStream = drawingUseCase.createLineStream(from: point)
                    
                    Task {
                        for await line in lineStream {
                            self.output.currentLine.send(line)
                        }
                        self.output.currentLine.send(nil)
                    }
                case .changed(let point):
                    drawingUseCase.addPointToCurrentLine(to: point)
                case .ended:
                    drawingUseCase.finishLineStream()
                }
            })
            .store(in: &cancellables)
    }
}
