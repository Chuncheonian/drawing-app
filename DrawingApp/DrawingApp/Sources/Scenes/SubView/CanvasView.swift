//
//  CanvasView.swift
//  DrawingApp
//
//  Created by Dongyoung Kwon on 2023/11/05.
//

import UIKit

protocol CanvasViewDelegate: AnyObject {
    func onTapRectangleView(_ view: RectangleView, rectangle: Rectangle)
}

final class CanvasView: UIView {
    
    // MARK: - property
    
    // INTERNAL
    weak var delegate: CanvasViewDelegate?
    
    // PRIVATE
    private var layers: [CAShapeLayer] = []
    
    private var currentPath: UIBezierPath?
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
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        
        let newPath = UIBezierPath()
        newPath.move(to: point)
        
        currentPath = newPath
        
        let newLayer = CAShapeLayer()
        newLayer.strokeColor = UIColor.black.cgColor
        newLayer.fillColor = UIColor.clear.cgColor
        newLayer.lineWidth = 5
        newLayer.lineCap = .round
        newLayer.path = newPath.cgPath
        
        currentLayer = newLayer
        layer.addSublayer(newLayer)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              let currentPath = currentPath,
              let currentLayer = currentLayer
        else { return }
        
        let point = touch.location(in: self)
        currentPath.addLine(to: point)
        currentLayer.path = currentPath.cgPath
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currentLayer = currentLayer else { return }
        
        layers.append(currentLayer)
        
        self.currentPath = nil
        self.currentLayer = nil
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
}

// MARK: - set up UI

extension CanvasView {
    private func setUpUI() {
        setUpView()
        setUpLayout()
        setUpComponents()
    }
    
    private func setUpView() {
        backgroundColor = .white
    }
    
    private func setUpLayout() {
        
    }
    
    private func setUpComponents() {
        
    }
}

// MARK: - RectangleViewDelegate

extension CanvasView: RectangleViewDelegate {
    func onTapRectangleView(_ view: RectangleView, rectangle: Rectangle) {
        delegate?.onTapRectangleView(view, rectangle: rectangle)
    }
}
