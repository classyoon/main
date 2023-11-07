//
//  BattleManager.swift
//  SecurityMeter
//
//  Created by Conner Yoon on 10/30/23.
//

import Foundation
class BattleManager : ObservableObject {
    var hordesInRange: [any Undead] = []
    
    func checkForBattleWithUndead(exterior: [any Undead]) {
        // Filter the hordes that are in range
        hordesInRange = exterior.filter { $0.distance <= 0 }
       
    }
    func getAttackingZombies()->[ZombieType: Int]{
        var totalComposition: [ZombieType: Int] = [.shambler: 0, .undead_elite: 0, .undead_ranged: 0]

        // Go through each horde in range
        for horde in hordesInRange {
            // Add the composition of the current horde to the total composition
            for (type, number) in horde.composition {
                totalComposition[type, default: 0] += number
            }
        }
        return totalComposition
    }
    func startBattle() {
        
    }

    
}
