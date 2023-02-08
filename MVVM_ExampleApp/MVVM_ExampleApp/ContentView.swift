//
//  ContentView.swift
//  MVVM_ExampleApp
//
//  Created by Dan Lovell on 1/23/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = PersonViewModel()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                ForEach(viewModel.people) { person in
                    HStack {
                        Text(person.name)
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        VStack (alignment: .trailing) {
                            Text(person.phoneNumber)
                            Text(person.email)
                        }
                    }
                    .frame(height: 60)
                    .padding(7)
                }
            }
            
            Menu("Menu".uppercased()) {
                Button("Reverse", action: { viewModel.reverseOrder() } )
                Button("Shuffle", action: { viewModel.shuffleOrder() } )
                Button("Remove Last", action: { viewModel.removeLastPerson() } )
                Button("Remove First", action: { viewModel.removeFirstPerson() } )
                Button("Refresh", action: { viewModel.addPeople() } )
            }
            
            .padding()
            
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
