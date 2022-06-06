//
//  RatingView.swift
//  Bookworm
//
//  Created by Dan Lovell on 6/2/22.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int // value returned to caller
    
    var label = ""
    var maximumRating = 5
    
    var offImage: Image? // optionally add a San Fransymbols for a no rating symbol
    //var onImage = Image(systemName: "star.fill") // Form the San Fransymbols collection
    var onImage = Image(systemName: "arrow.up.heart.fill") // Form the San Fransymbols collection
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            if !label.isEmpty {
                Text(label)
            }
            
            ForEach(1..<maximumRating+1, id: \.self) { number in
                image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
            }
            
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage // onImage is optional
        } else {
            return onImage
        }
    }
    
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(4)) // a constant to get preview to appear ok
    }
}
