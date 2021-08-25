//
//  ContentView.swift
//  SimpleDrawingApp
//
//  Created by Evgenii Kolgin on 31.05.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Drawing.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Drawing.title, ascending: true)
    ])
    
    var drawings: FetchedResults<Drawing>
    
    @State private var showSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(drawings) {drawing in
                        NavigationLink(destination: DrawingView(id: drawing.id, data: drawing.canvasData, title: drawing.title)) {
                            Text(drawing.title ?? "Untitled")
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let drawing = drawings[index]
                            viewContext.delete(drawing)
                            do {
                                try viewContext.save()
                            } catch {
                                viewContext.rollback()
                                print("Failed to save context \(error)")
                            }
                        }
                    }
                    
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Canvas")
                        }
                    })
                    .foregroundColor(.blue)
                    .sheet(isPresented: $showSheet) {
                        AddNewCanvasView()
                    }
                }
                .navigationTitle("Drawings")
                .toolbar {
                    EditButton()
                }
            }
            VStack {
                Image(systemName: "scribble.variable")
                    .font(.largeTitle)
                Text("No canvas has been selected")
                    .font(.title)
            }
        }
    }
}
