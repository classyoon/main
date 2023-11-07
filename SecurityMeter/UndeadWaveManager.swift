//
//  UndeadWaveManager.swift
//  SecurityMeter
//
//  Created by Conner Yoon on 9/25/23.
//

import Foundation


class UndeadWaveManager : ObservableObject {
   @Published var director : DifficultyDirector = DifficultyDirector()
   var creator : Undead_Horde_Factory = Undead_Horde_Factory()
   @Published var exterior : [any Undead] = []
   var maxDistance = 101
   var battlePossible : Bool {
      for attacker in exterior {
         if attacker.distance <= 0 {
            return true
         }
      }
      return false
   }
   func advanceDay() {
      exterior = exterior.filter { $0.distance < maxDistance }
      for i in exterior.indices {
         exterior[i].executeBehavior()
      }
      
      director.advanceDay()
      checkAttackDirector()
   }
   
   func checkAttackDirector(){
      print("Check")
      if director.spawntime == true {
         exterior.append(creator.createHorde(director.attacker_size))
         director.adapt()
         director.resetSpawnTimer()
      }
   }
}

