//
//  ContentView.swift
//  BetterRest
//
//  Created by Jordan Burns on 3/12/24.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from:components) ?? .now
    }
    
    var sleepMessage: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)

            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Int64(hour + minute), estimatedSleep: sleepAmount, coffee: Int64(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
             return "Your ideal bedtime is \(sleepTime.formatted(date: .omitted, time: .shortened))"
        } catch {
            
            return "Sorry, there was a problem calculating your bedtime."
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                } header : {
                    Text("When do you want to wake up?")
                        .font(.headline)
                }
                
                
                Section {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                } header: {
                    Text("Desired amount of sleep")
                        .font(.headline)
                }
                .font(.headline)
                
                Section {
                    Picker("^[\(coffeeAmount) cup](inflect: true)", selection: $coffeeAmount) {
                        ForEach(0..<21) {
                            Text("^[\($0) cup](inflect: true)")
                        }
                    }
                } header : {
                    Text("Daily coffee intake")
                        .font(.headline)
                }
                .font(.headline)
                
                Text(sleepMessage)
                    .font(.title3)
            }
            .navigationTitle("BetterRest")
        }
    }
}

#Preview {
    ContentView()
}
