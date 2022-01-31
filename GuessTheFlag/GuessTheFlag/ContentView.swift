//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Dan Lovell on 1/19/22.
//

import SwiftUI

struct FlagImage: View {
    let country: String
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 15)
    }
}

struct ContentView: View {
    
    @State private var showingScore: Bool = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var wins: Int = 0
    @State private var loses: Int = 0
    @State private var wrongFlagChosen: String = ""
    @State private var numberQuestions: Int = 0
    
    var body: some View {
        ZStack { // contains layered views
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                        .font(.subheadline.weight(.heavy))
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle.weight(.semibold))
                }
                
                ForEach(0..<3) { number in
                    Button {
                        numberQuestions += 1
                        flagTapped(number)
                    } label: {
                        FlagImage(country: countries[number])
                    }
                }
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
            
            if numberQuestions == 8 {
                Button("Restart") {
                    numberQuestions = 0
                    wins = 0
                    loses = 0
                }
            }
            
        } message: {
            Text("\(wrongFlagChosen) Your score is \(wins-loses)")
        }
    }
    
    func flagTapped(_ number: Int) {
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            wins += 1
            wrongFlagChosen = "Score increases!"
        } else {
            scoreTitle = "Wrong"
            loses += 1
            wrongFlagChosen = "Wrong flag; that one is for \(countries[number])!"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries = countries.shuffled()
        correctAnswer = Int.random(in: 0..<2)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
