//
//  ContentView.swift
//  SecurityMeter
//
//  Created by Conner Yoon on 9/25/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var undeadWaveManager = UndeadWaveManager()

    func getBehavior(of : any Attacker)->String{
        switch of.status {
        case .agitated:
            return "Angry"
        case .delayed:
            return "Delayed"
        case .fleeing:
            return "Fleeing"
        case .normal:
            return "Normal"
        case .searching_camp:
            return "Searching Camp"
        case .seiging:
            return "Seiging"
            
        }
    }
    var body: some View {
        VStack {
            Text("Undead Wave Manager")
                .font(.largeTitle)
                .padding()

            HStack {
                Text("Battle Possible: ")
                Text("\(undeadWaveManager.battlePossible ? "Yes" : "No")")
            }
            Button(action: {
                undeadWaveManager.advanceDay()
            }) {
                Text("Advance Day")
            }

            VStack{
                Text("Time Before Spawn : \(undeadWaveManager.director.timeLeftBeforeSpawningAttack)")
                Text("Player Time : \(undeadWaveManager.director.playerTimeToPrepare)")
                
            }

            Button(action: {
                undeadWaveManager.exterior.append(undeadWaveManager.creator.createHorde(undeadWaveManager.director.attacker_size))

            }) {
                Text("Spawn Undead Wave")
            }

            List(undeadWaveManager.exterior.indices, id: \.self) { index in
                VStack{
                    VStack(alignment: .leading) {
                        Text("Attacker \(index+1):")
                        Text("Speed: \(undeadWaveManager.exterior[index].speed)")
                        Text("Distance: \(undeadWaveManager.exterior[index].distance)")
                        Text("Current Thought : \(getBehavior(of:undeadWaveManager.exterior[index]))")
                        Text("Delay Timer: \(undeadWaveManager.exterior[index].delayTimer)")
                        Text("Patience: \(undeadWaveManager.exterior[index].patience)")
                        
                    }
                    Button("Agitate"){
                        undeadWaveManager.exterior[index].agitate()
                    }
                    Button("Delay"){
                        undeadWaveManager.exterior[index].delayTimer += 2
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
