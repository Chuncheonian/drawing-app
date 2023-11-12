//
//  CanvasView.swift
//  DrawingApp
//
//  Created by Dongyoung Kwon on 2023/11/05.
//

import UIKit

protocol CanvasViewDelegate: AnyObject {
    func onTapRectangleView(_ view: RectangleView, rectangle: Rectangle)
    func didBeginTouchAtPoint(point: CGPoint)
    func didMoveTouchToPoint(point: CGPoint)
    func didEndTouchToPoint()
}

final class CanvasView: UIView {
    
    // MARK: - property
    
    // INTERNAL
    weak var delegate: CanvasViewDelegate?
    
    // PRIVATE
    private var currentLayer: CAShapeLayer?
    
    // MARK: - life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUpUI()
    }
}

// MARK: - touch action

extension CanvasView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        
        delegate?.didBeginTouchAtPoint(point: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        
        delegate?.didMoveTouchToPoint(point: point)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didEndTouchToPoint()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
}

// MARK: - internal method

extension CanvasView {
    
    func append(rectangle: Rectangle) {
        let rectangleView = RectangleView(frame: rectangle.rect)
        rectangleView.bind(with: rectangle)
        rectangleView.delegate = self
        
        addSubview(rectangleView)
    }
    
    func drawLine(_ line: Line?) {
        switch line {
        case .some(let line):
            updateCanvas(with: line)
        case .none:
            currentLayer = nil
        }
    }
}

// MARK: - private method for drawing line

extension CanvasView {
    
    private func updateCanvas(with line: Line) {
        if currentLayer == nil {
            createShapeLayer(for: line)
        }
        updateCurrentLayerPath(with: line)
    }
    
    private func createShapeLayer(for line: Line) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.makeUIColor(for: line.color).cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.lineCap = .round
        
        currentLayer = shapeLayer
        layer.addSublayer(shapeLayer)
    }
    
    private func updateCurrentLayerPath(with line: Line) {
        guard let path = createPath(for: line) else { return }
        currentLayer?.path = path.cgPath
    }
    
    private func createPath(for line: Line) -> UIBezierPath? {
        guard let firstPoint = line.points.first else { return nil }
        
        let path = UIBezierPath()
        path.move(to: firstPoint)
        
        for point in line.points.dropFirst() {
            path.addLine(to: point)
        }
        
        return path
    }
}

// MARK: - set up UI

extension CanvasView {
    private func setUpUI() {
        setUpView()
    }
    
    private func setUpView() {
        backgroundColor = .white
    }
}

// MARK: - RectangleViewDelegate

extension CanvasView: RectangleViewDelegate {
    func onTapRectangleView(_ view: RectangleView, rectangle: Rectangle) {
        delegate?.onTapRectangleView(view, rectangle: rectangle)
    }
}
