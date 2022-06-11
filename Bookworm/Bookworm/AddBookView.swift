//
//  AddBookView.swift
//  Bookworm
//
//  Created by Dan Lovell on 6/1/22.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3 // default value
    @State private var genre = ""
    @State private var review = ""
    @State private var createdTS = Date.now
    
    private var isValidBookReview: Bool {
        if title.isEmpty { return false }
        if author.isEmpty { return false }
        if rating <= 0 || rating > 5 { return false }
        if genres.filter({$0 == genre}).isEmpty { return false }
        if review.isEmpty { return false }
        return true
    }
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    TextField("Name of Book", text: $title)
                    TextField("Author's Name", text:$author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                    
                }
                
                Section {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a Review")
                }
                
                Section {
                    Button("Save") {
                        let newBook = Book(context: moc)
                        
                        newBook.id = UUID()
                        newBook.title = title
                        newBook.author = author
                        newBook.rating = Int16(rating)
                        newBook.genre = genre
                        newBook.review = review
                        newBook.createdTS = Date.now
                        
                        try? moc.save() // Write RAM data to Persistent Storage
                        dismiss()
                    }
                    .disabled(!isValidBookReview)
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
            }
            .navigationTitle("Add Book")
            
        }
        
    }
    
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
