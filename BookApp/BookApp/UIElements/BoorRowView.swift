//
//  BookRow.swift
//  BookApp
//
//  Created by Andrii Tishchenko on 2024-08-30.
//

import Foundation
import SwiftUI

struct BookRowView: View {
    var book: Book
    
    var body: some View {
        HStack {
            AsyncImage(url: book.coverImageURL) { image in
                image.resizable()
                    .frame(width: 50, height: 70)
            } placeholder: {
                ProgressView()
            }
            VStack(alignment: .leading) {
                Text(book.title).font(.headline).foregroundColor(                    
                    Color.rowTitleColor
                )
                Text(book.author).font(.subheadline).foregroundColor(
                    Color.rowTitleColor
                )
            }
        }
    }
}
