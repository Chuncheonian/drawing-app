//
//  CanvasViewController.swift
//  DrawingApp
//
//  Created by Dongyoung Kwon on 2023/11/05.
//

import Combine
import OSLog
import UIKit

final class CanvasViewController: UIViewController {
    
    // MARK: - property
    
    private var cancellables: Set<AnyCancellable> = .init()
    private let logger: Logger = .init(subsystem: AppConfig.BuildSetting.appBundleIdentifier,
                                       category: "CanvasViewController")
    private let viewModel: CanvasViewModel
    
    private var selectedRectangleView: RectangleView?
    
    // MARK: - ui component property
    
    private let canvasView: CanvasView = .init()
    private let toolbarView: ToolbarView = .init()
    
    // MARK: - life cycle
    
    init(viewModel: CanvasViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        binding()
    }
    
    deinit {
        logger.debug("deinitialize")
    }
}

extension CanvasViewController {
    private func binding() {
        viewModel.output.appendRectangleView
            .sink(receiveValue: { [weak self] rectangle in
                guard let self else { return }
                
                canvasView.append(rectangle: rectangle)
            })
            .store(in: &cancellables)
        
        viewModel.output.updateRectangleView
            .sink(receiveValue: { [weak self] rectangle in
                guard let self else { return }
                
                selectedRectangleView?.bind(with: rectangle)
                selectedRectangleView = nil
            })
            .store(in: &cancellables)
    }
}

// MARK: - set up UI

extension CanvasViewController {
    private func setUpUI() {
        setUpView()
        setUpLayout()
        setUpComponents()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
    }
    
    private func setUpLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(canvasView)
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            canvasView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            canvasView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            canvasView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
        view.layoutIfNeeded()
        viewModel.input.canvasViewRect.send(canvasView.frame)
        
        view.addSubview(toolbarView)
        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolbarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toolbarView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,
                                                constant: -10)
        ])
    }
    
    private func setUpComponents() {
        setUpCanvasView()
        setUpToolbarView()
    }
    
    private func setUpCanvasView() {
        canvasView.delegate = self
    }
    
    private func setUpToolbarView() {
        toolbarView.delegate = self
    }
}

// MARK: - ToolbarViewDelegate

extension CanvasViewController: ToolbarViewDelegate {
    func onTapRectangleItemButton() {
        logger.info("tapped rectangle button")
        
        viewModel.input.onTapRectangleItemButton.send()
    }
    
    func onTapDrawingItemButton() {
        logger.info("tapped drawing button")
    }
}

// MARK: - CanvasViewDelegate

extension CanvasViewController: CanvasViewDelegate {
    func onTapRectangleView(_ view: RectangleView, rectangle: Rectangle) {
        /* NOTE: 사각형 클릭 이벤트 처리 로직 임시 방편, 추후 고칠 예정 */
        selectedRectangleView = view
        viewModel.input.onTapRectangleView.send(rectangle)
    }
}
