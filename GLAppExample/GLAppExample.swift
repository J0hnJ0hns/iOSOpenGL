//
// GLAppExample.swift
// GLAppExample
//
// Created by Sergei Iakovlev on 17.11.2024
// Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import SwiftUI

@main
struct GLAppExample: App {
    
    @State var degree: Float = 0
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                VStack(spacing: 10) {
                    GLViewRepresentable(angle: $degree)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                    Text("Angle: " + degree.description + " degrees")
                    Slider(
                        value: $degree,
                        in: 0...90,
                        onEditingChanged: { _ in }
                    )
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}
