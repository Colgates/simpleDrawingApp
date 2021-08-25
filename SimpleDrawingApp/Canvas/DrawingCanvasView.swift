//
//  DrawingCanvasView.swift
//  SimpleDrawingApp
//
//  Created by Evgenii Kolgin on 31.05.2021.
//

import SwiftUI
import CoreData
import PencilKit

struct DrawingCanvasView: UIViewControllerRepresentable {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    typealias UIViewControllerType = DrawingCanvasViewController
    
    var data: Data
    var id: UUID
    
    func updateUIViewController(_ uiViewController: DrawingCanvasViewController, context: Context) {
        uiViewController.drawingData = data
    }
    
    func makeUIViewController(context: Context) -> DrawingCanvasViewController {
        let viewController = DrawingCanvasViewController()
        viewController.drawingData = data
        viewController.drawingChanged = {data in
            let request: NSFetchRequest<Drawing> = Drawing.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.predicate = predicate
            
            do {
                let result = try viewContext.fetch(request)
                let object = result.first
                object?.setValue(data, forKey: "canvasData")
                
                do {
                    try viewContext.save()
                } catch {
                    print("Error trying to save \(error)")
                }
                
            } catch {
                print("Error trying to fetch request \(error)")
            }
        }
        return viewController
    }
}

