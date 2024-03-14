//
//  ContentView.swift
//  RPSBrainTrainer
//
//  Created by Jordan Burns on 3/12/24.
//


//Your challenge is to make a brain training game that challenges players to win or lose at rock, paper, scissors.
//So, very roughly:
//
//Each turn of the game the app will randomly pick either rock, paper, or scissors.
//Each turn the app will alternate between prompting the player to win or lose.
//The player must then tap the correct move to win or lose the game.
//If they are correct they score a point; otherwise they lose a point.
//The game ends after 10 questions, at which point their score is shown.
//So, if the app chose “Rock” and “Win” the player would need to choose “Paper”, but if the app chose “Rock” and “Lose” the player would need to choose “Scissors”.
//
//To solve this challenge you’ll need to draw on skills you learned in tutorials 1 and 2:
//
//Start with an App template, then create a property to store the three possible moves: rock, paper, and scissors.
//You’ll need to create two @State properties to store the app’s current choice and whether the player should win or lose.
//You can use Int.random(in:) to select a random move. You can use it for whether the player should win too if you want, but there’s an even easier choice: Bool.random() is randomly true or false. After the initial value, use toggle() between rounds so it’s always changing.
//Create a VStack showing the player’s score, the app’s move, and whether the player should win or lose. You can use if shouldWin to return one of two different text views.
//The important part is making three buttons that respond to the player’s move: Rock, Paper, or Scissors.
//Use the font() modifier to adjust the size of your text. If you’re using emoji for the three moves, they also scale. Tip: You can ask for very large system fonts using .font(.system(size: 200)) – they’ll be a fixed size, but at least you can make sure they are nice and big!

import SwiftUI

struct ContentView: View {
    static let moves = ["rock\n✊🏽", "paper\n✋🏽", "scissors\n✌🏽"]
    @State private var computerMove = moves[Int.random(in: 0..<3)]
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var currentQuestionNumber = 1
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var showingEndScreen = false
    
    let numberOfQuestions = 10
    
    var body: some View {
        ZStack{
            RadialGradient(colors: [.orange, .red, .purple], center: .center, startRadius: 100, endRadius: 500)
            .ignoresSafeArea()
            VStack{
                Spacer()
                Text("RPS Brain Trainer")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
                Text("The computer played")
                    .font(.system(size: 20))
                Button(computerMove) {}
                    .frame(minWidth: 100)
                    .padding(10)
                    .background(.thinMaterial)
                    .clipShape(.rect(cornerRadius: 20))
                    .font(.system(size: 20))
                
                VStack(spacing: 10) {
                    Text("Tap the correct move to \(shouldWin ? "win" : "lose") this round")
                        .font(.subheadline.weight(.heavy))
                        .font(.system(size: 26))
                    HStack {
                        ForEach(0..<3) { number in
                            Button {
                                moveTapped(ContentView.moves[number])
                            } label: {
                                Text(ContentView.moves[number])
                                    .font(.system(size: 30))
                            }
                            .frame(minWidth: 100)
                            .padding(10)
                            .background(.thinMaterial)
                            .clipShape(.rect(cornerRadius: 20))
                        }
                    }
                }
                Spacer()
                Spacer()
                
            }
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
            }
        .alert("Game over. Your final score is \(score) out of \(numberOfQuestions)", isPresented: $showingEndScreen) {
            Button("Play Again",action: resetGame)
        }
    }
    
    func moveTapped(_ userMove: String) {
        var userGetsPoint = false
        currentQuestionNumber += 1
        
        if shouldWin {
            if computerMove == "rock\n✊🏽" && userMove == "paper\n✋🏽" {
                userGetsPoint = true
            }
            else if computerMove == "paper\n✋🏽" && userMove == "scissors\n✌🏽" {
                userGetsPoint = true
            }
            else if computerMove == "scissors\n✌🏽" && userMove == "rock\n✊🏽" {
                userGetsPoint = true
            }
        }
        if !shouldWin {
            if computerMove == "rock\n✊🏽" && userMove == "scissors\n✌🏽" {
                userGetsPoint = true
            }
            else if computerMove == "paper\n✋🏽" && userMove == "rock\n✊🏽" {
                userGetsPoint = true
            }
            else if computerMove == "scissors\n✌🏽" && userMove == "paper\n✋🏽" {
                userGetsPoint = true
            }
        }
        
        if userGetsPoint {
            score += 1
            scoreTitle = "Correct"
        } else {
            score -= 1
            scoreTitle = "Incorrect"
        }
        
        if currentQuestionNumber > numberOfQuestions {
            showingEndScreen = true
            showingScore = false
        }
        
        showingScore = true
        
    }
    func askQuestion() {
        computerMove = ContentView.moves[Int.random(in: 0..<3)]
        shouldWin.toggle()
    }
    func resetGame() {
        score = 0
        currentQuestionNumber = 0
        askQuestion()
    }
}

#Preview {
    ContentView()
}
