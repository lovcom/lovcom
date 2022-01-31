//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Dan Lovell on 1/29/22.
//

import SwiftUI

private struct ModifyButtons: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .controlSize(.small)
            .padding(1)
            .foregroundColor(.white)
            .background(Color.blue
                            .cornerRadius(5)
            )
    }
}

struct ContentView: View {
    
    private let moves = ["Rock", "Paper", "Scissors"]
    
    @State private var currentMove: String = ["Rock", "Paper", "Scissors"].randomElement() ?? "Rock"
    @State private var currentGoal: Bool = Bool.random()
    @State private var score = 0
    @State private var playerResponse = "Rock"
    @State private var results = ""
    @State private var displayAlert: Bool = false
    @State private var numberOfPlays = 0
    @State private var lastMove = ""
    @State private var lastGoal = true
    
    @ViewBuilder private var movePicker: some View {
        Text("Your choice...")
            .foregroundColor(.blue)
        Picker("Your Choice", selection: $playerResponse) {
            ForEach(moves, id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(.segmented)
    }
    
    @ViewBuilder private var twoButtons: some View {
        HStack {
            Spacer()
            
            Button(action: {
                determineResult(choice: playerResponse)
            }, label: {
                Text("Play")
                    .modifier(ModifyButtons())
            })
                .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            Button(action: {
                prepareNewGame()
                score = 0
                numberOfPlays = 0
            }, label: {
                Text("Restart")
                    .modifier(ModifyButtons())
            })
                .buttonStyle(PlainButtonStyle())
         
        }
        
        Spacer()
        
    }
    
    @ViewBuilder private var popAlert: some View {
        self.alert(results, isPresented: $displayAlert) {
            Button("Continue", action: prepareNewGame)
            
            if numberOfPlays.isMultiple(of: 3) && numberOfPlays != 0 {
                Button("Restart") {
                    prepareNewGame()
                    numberOfPlays = 0
                    score = 0
                }
            }
            
        } message: {
            Text("Number of Plays: \(numberOfPlays).")
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                
                Group {
                    Group1(score: score)
                }
                
                Group {
                    Group2(currentMove: currentMove, currentGoal: currentGoal)
                }
                
                Group {
                    movePicker
                }
                
                Group {
                    twoButtons
                }
                
               popAlert
            }
            
        }
        .navigationTitle("Rock, Paper, Scissors")
    }
    
    private func determineResult(choice: String) {
        
        switch (currentMove) {
        case "Rock" :
            if choice == "Rock" {
                results = "Tie"
            } else if choice == "Paper" {
                results = "Win"
            } else if choice == "Scissors" {
                results = "Lose"
            }
            
        case "Paper" :
            if choice == "Rock" {
                results = "Lose"
            } else if choice == "Paper" {
                results = "Tie"
            } else if choice == "Scissors" {
                results = "Win"
            }
        case "Scissors" :
            if choice == "Rock" {
                results = "Win"
            } else if choice == "Paper" {
                results = "Lose"
            } else if choice == "Scissors" {
                results = "Tie"
            }
        default:
            results = "?"
            print("ERROR")
        }
        
        if !currentGoal {
            
            if results == "Win" {
                results = "Lose"
            } else if results == "Lose" {
                results = "Win"
            }
        }
        
        if results == "Win" {
            score += 1
            numberOfPlays += 1
        } else if results == "Lose" {
            score -= 1
            numberOfPlays += 1
        }
        
        displayAlert = true
    }
    
    private func prepareNewGame() {
        
        repeat {
            currentMove = moves[Int.random(in: 0..<3)]
            currentGoal = Bool.random()
        } while (currentMove == lastMove) || (currentGoal == lastGoal)
        
        playerResponse = "Rock"
        
        lastMove = currentMove
        lastGoal = currentGoal
    }
    
    private struct Group1: View {
        var score: Int
        
        var body: some View {
            Text("Your Score")
                .foregroundColor(.blue)
            Text("\(score)")
                .foregroundColor(.black)
        }
    }

    private struct Group2: View {
        var currentMove: String
        var currentGoal: Bool
        
        var body: some View {
            Text("Play this Move")
                .foregroundColor(.blue)
            Text(currentMove)
                .foregroundColor(.black)
            Text("Play to...")
                .foregroundColor(.blue)
            Text(currentGoal ? "Win" : "Lose")
                .foregroundColor(.black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
