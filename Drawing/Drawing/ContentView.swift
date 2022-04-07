//
//  ContentView.swift
//  Drawing
//
//  Created by Dan Lovell on 3/24/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Path {path in
            path.move(to: CGPoint(x: 200, y: 100)) // CG stands for Core Graphics
            path.addLine(to: CGPoint(x: 100, y: 300))
            path.addLine(to: CGPoint(x: 300, y: 300))
            path.addLine(to: CGPoint(x: 200, y: 100))
            //path.closeSubpath() // This makes the top corner of triangle join cleanly but no longer needed when .strok(.blue, style: StrokeStyle... is used below
        }
        // .fill(.blue)
        //.stroke(.blue, lineWidth: 10)
        // This next line rounds the 3 corners of our triangle
        .stroke(.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
