//
//  ErrorPopupView.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-30.
//

import Foundation

import SwiftUI

struct ErrorPopupView: View {
    let message: String
    
    var body: some View {
        VStack {
            Text(message)
                .lineLimit(3)
                .font(.body)
                .foregroundColor(.white)
                .padding()
                .cornerRadius(8)
        }
        .frame(maxWidth: .infinity)
        .background(Color.red)
        .cornerRadius(20)
    }
}
