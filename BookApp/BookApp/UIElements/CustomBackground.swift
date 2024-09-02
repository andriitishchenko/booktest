//
//  CustomBackground.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-31.
//

import Foundation

import SwiftUI

struct CustomBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
    }
}


struct CustomListBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.black.opacity(0.5))
                    .padding()
            )
    }
}

extension View {
    func applyCustomBackground() -> some View {
        self.modifier(CustomBackground())
    }
    
    func applyCustomListBackground() -> some View {
        self.modifier(CustomListBackground())
    }
}
