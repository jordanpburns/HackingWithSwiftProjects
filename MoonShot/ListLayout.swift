//
//  ListLayout.swift
//  MoonShot
//
//  Created by Jordan Burns on 3/20/24.
//

import SwiftUI

struct ListLayout: View {
    let astronauts: [String: Astronaut]
    let missions: [Mission]
    var body: some View {
        List(missions) { mission in
                NavigationLink {
                    MissionView(mission: mission, astronauts: astronauts)
                } label: {
                    HStack {
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding()
                        
                        VStack(alignment: .leading) {
                            Text(mission.displayName)
                                .font(.headline)
                                .foregroundStyle(.white.opacity(1))
                            Text(mission.formattedLaunchDate)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                }
                .listRowBackground(Color.darkBackground)
            }
        .listStyle(.plain)
        Text("All information about astronauts from Wikipedia via Hacking with Swift. license: https://creativecommons.org/licenses/by-sa/4.0/")
    }
}

#Preview {
    ListLayout(astronauts: Bundle.main.decode("astronauts.json"), missions: Bundle.main.decode("missions.json"))
}
