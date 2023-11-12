//
//  DrawingUseCase.swift
//  DrawingApp
//
//  Created by Dongyoung Kwon on 2023/11/12.
//

import Foundation

protocol DrawingUseCase {
    func createLineStream(from point: CGPoint) -> AsyncStream<Line>
    func addPointToCurrentLine(to point: CGPoint)
    func finishLineStream()
}

final class DrawingUseCaseImpl: DrawingUseCase {
    
    private var currentLine: Line?
    private var lines: [Line] = []
    private var streamContinuation: AsyncStream<Line>.Continuation?
    
    func createLineStream(from point: CGPoint) -> AsyncStream<Line> {
        currentLine = Line(points: [point], color: SystemColor.randomExcludingRed)
        
        return .init { continuation in
            self.streamContinuation = continuation
            continuation.yield(currentLine!)
        }
    }
    
    func addPointToCurrentLine(to point: CGPoint) {
        currentLine?.points.append(point)
        
        if let currentLine {
            streamContinuation?.yield(currentLine)
        }
    }
    
    func finishLineStream() {
        guard let currentLine else { return }
        
        lines.append(currentLine)
        self.currentLine = nil
        streamContinuation?.finish()
    }
}
