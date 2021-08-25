//
//  DrawingView.swift
//  SimpleDrawingApp
//
//  Created by Evgenii Kolgin on 31.05.2021.
//

import SwiftUI

struct DrawingView: View {
    
    @State var id: UUID?
    @State var data: Data?
    @State var title: String?
    
    var body: some View {
        VStack {
            DrawingCanvasView(data: data ?? Data(), id: id ?? UUID())
                .navigationBarTitle(title ?? "Untitled", displayMode: .inline)
        }
    }
}

