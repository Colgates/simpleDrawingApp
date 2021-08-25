//
//  DrawingCanvasViewController.swift
//  SimpleDrawingApp
//
//  Created by Evgenii Kolgin on 31.05.2021.
//

import UIKit
import PencilKit

class DrawingCanvasViewController: UIViewController {
    
    lazy var canvasView: PKCanvasView = {
        let canvasView = PKCanvasView()
        canvasView.drawingPolicy = .anyInput
        canvasView.maximumZoomScale = 1
        canvasView.minimumZoomScale = 1
        return canvasView
    }()
    
    lazy var toolPicker: PKToolPicker = {
        let toolPicker = PKToolPicker()
        toolPicker.addObserver(self)
        return toolPicker
    }()
    
    var drawingData = Data()
    var drawingChanged: (Data) -> Void = {_ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(canvasView)
        canvasView.frame = view.bounds
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.delegate = self
        canvasView.becomeFirstResponder()
        
        if let drawing = try? PKDrawing(data: drawingData) {
            canvasView.drawing = drawing
        }
    }
}

extension DrawingCanvasViewController: PKToolPickerObserver, PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        drawingChanged(canvasView.drawing.dataRepresentation())
    }
}

