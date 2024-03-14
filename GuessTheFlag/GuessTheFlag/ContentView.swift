//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Jordan Burns on 3/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingEndScreen = false
    
    @State private var scoreTitle = ""
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
    @State private var countries = allCountries.shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var currentQuestionNumber = 1
    
    let numberOfQuestions = 8
    
    struct FlagImage: View {
        var country: String
        
        var body: some View {
            Image(country)
                .clipShape(.capsule)
                .shadow(radius: 5)
        }
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 260, endRadius: 500)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess The Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game Over. Your final score is \(score) out of \(numberOfQuestions)", isPresented: $showingEndScreen) {
            Button("Play Again", action: resetGame)
        }
    }
    func flagTapped(_ number: Int) {
        currentQuestionNumber += 1
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            countries.remove(at: correctAnswer)
        } else {
            scoreTitle = "Opps, that is the flag of \(countries[number])"
        }
        showingScore = true
        if currentQuestionNumber > numberOfQuestions {
            showingEndScreen = true
            showingScore = false
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    func resetGame() {
        score = 0
        currentQuestionNumber = 1
        countries = Self.allCountries
        askQuestion()
    }
}

#Preview {
    ContentView()
}
