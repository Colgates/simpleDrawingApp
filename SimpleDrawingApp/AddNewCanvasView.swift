//
//  AddNewCanvasView.swift
//  SimpleDrawingApp
//
//  Created by Evgenii Kolgin on 31.05.2021.
//

import SwiftUI

struct AddNewCanvasView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var canvasTitle = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Canvas Title", text: $canvasTitle)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationTitle("Add new canvas")
            .navigationBarItems(leading:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Image(systemName: "xmark")
                                    }),
                                trailing:
                                    Button(action: {
                                        if !canvasTitle.isEmpty {
                                            
                                            let drawing = Drawing(context: viewContext)
                                            drawing.title = canvasTitle
                                            drawing.id = UUID()
                                            
                                            do {
                                                try viewContext.save()
                                            } catch {
                                                print("Failed to save context \(error)")
                                                viewContext.rollback()
                                            }
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                    }, label: {
                                        Text("Add")
                                    }))
        }
    }
}

