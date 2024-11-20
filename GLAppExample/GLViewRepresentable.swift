//
// GLViewRepresentable.swift
// GLAppExample
//
// Created by Sergei Iakovlev on 20.11.2024
// Copyright © 2024 . All rights reserved.
//

import SwiftUI

struct GLViewRepresentable: UIViewRepresentable {
    typealias UIViewType = GLView
    
    @Binding var angle: Float
    
    func makeUIView(context: Context) -> GLView {
        return GLView()
    }
    
    func updateUIView(_ uiView: GLView, context: Context) {
        uiView.rotation = angle
        uiView.layoutSubviews()
    }
}

