//
//  RectangleView.swift
//  DrawingApp
//
//  Created by Dongyoung Kwon on 2023/11/05.
//

import UIKit

protocol RectangleViewDelegate: AnyObject {
    func onTapRectangleView(_ view: RectangleView, rectangle: Rectangle)
}

final class RectangleView: UIView {
    
    // MARK: - property
    
    // INTERNAL
    weak var delegate: RectangleViewDelegate?
    
    // PRIVATE
    private var rectangle: Rectangle?
    
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

// MARK: - internal method

extension RectangleView {
    
    func bind(with state: Rectangle) {
        self.rectangle = state
        
        backgroundColor = UIColor.makeUIColor(for: state.backgroundColor)
        
        if state.isSelected {
            layer.borderWidth = 5
            layer.borderColor = UIColor.systemRed.cgColor
        } else {
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
        }
    }
}

// MARK: - action

extension RectangleView {
    @objc
    private func handleTapGesture() {
        guard let rectangle else { return }
        
        delegate?.onTapRectangleView(self, rectangle: rectangle)
    }
}

// MARK: - set up UI

extension RectangleView {
    private func setUpUI() {
        setUpView()
        setUpLayout()
        setUpComponents()
    }
    
    private func setUpView() {
        backgroundColor = .white
        let gesture = UITapGestureRecognizer(target: self, 
                                             action: #selector(handleTapGesture))
        self.addGestureRecognizer(gesture)
    }
    
    private func setUpLayout() {
        
    }
    
    private func setUpComponents() {
        
    }
}
