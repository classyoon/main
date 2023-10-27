//
//  UndeadWaveManager.swift
//  SecurityMeter
//
//  Created by Conner Yoon on 9/25/23.
//

import Foundation

class UndeadWaveManager : ObservableObject {
   @Published var director : AttackDirector = AttackDirector()
   var creator : Undead_Horde_Factory = Undead_Horde_Factory()
   @Published var exterior : [any Attacker] = []
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
      if exterior.count < 1 {
         exterior.append(creator.createHorde(.small))
      }
      exterior = exterior.filter { $0.distance < maxDistance }
      for i in exterior.indices {
         exterior[i].executeBehavior()
      }
      
      director.advanceDay()
      checkAttackDirector()
   }
   
   func checkAttackDirector(){
      if director.spawntime == true {
         exterior.append(creator.createHorde(director.attacker_size))
         director.resetSpawnTimer()
      }
   }
}

protocol Attacker : Codable {
   var speed : Int {get set}
   var distance : Int {get set}
   var status : Attacker_Behavior {get set}
   var delayTimer : Int {get set}
   var patience : Int {get set}
}
extension Attacker {
   mutating func executeBehavior(){
      if delayTimer > 0 {
         status = .delayed
      }
      switch status {
      case .delayed :
         delayed()
      case .fleeing :
         leave()
      case .normal :
         advance()
      case .searching_camp :
         searchCamp()
      default : break
      }
   }
   mutating func delayed(){
      if delayTimer > 0 {
         delayTimer -= 1
      }
      else{
         status = .normal
      }
   }
   mutating func advance(){
      if distance-speed <= 0{
         distance = 0
         actInRange(playerVisible: false)
      }else{
         distance -= speed
      }
   }
   mutating func searchCamp(){
      if patience <= 0{
         status = .fleeing
      }else{
         patience -= 1
      }
   }
   mutating func agitate(){
      speed += 2
   }
   mutating func leave(){
      distance += speed
   }
   mutating func actInRange(playerVisible: Bool) {
      if playerVisible {
         status = .seiging
      } else {
         status = .searching_camp
         if patience < 0 {
            status = .fleeing
         }else{
            patience -= 1
         }
      }
   }
   
}
enum ZombieType : Codable {
   case shambler, undead_elite, undead_ranged
}
enum Attacker_Behavior : Codable {
   case delayed, normal, agitated, fleeing, searching_camp, seiging
}

class AttackDirector : ObservableObject {
   enum AttackerDirectorAction : Codable {
      case standard, challenging, easing_off, reprieve, boss_fight
   }
   var history : [AttackResult] = []
   @Published var currentBehavior : AttackerDirectorAction = .standard
   @Published var dayCount : Int = 0
   @Published var playerTimeToPrepare = 10
   @Published var timeLeftBeforeSpawningAttack = 10
   @Published var timeInBehavior = 0
   var spawntime : Bool {
      timeLeftBeforeSpawningAttack <= 0
   }
   
   var attacker_size = HordeID.small
   func advanceDay(){
      print("Advance director")
      if dayCount%10 == 0 {
         resetSpawnTimer()
         adjustWaveSize()
         adapt()
      }
      dayCount += 1
      timeInBehavior += 1
   }
   func adjustWaveSize() {
//      print("Adjust")
//      let recentResults = history.suffix(5)  // consider the last 5 results
//      let recentDeaths = recentResults.map { $0.playerPeopleDeaths }
//      let averageDeaths = recentDeaths.isEmpty ? 0 : recentDeaths.reduce(0, +) / recentDeaths.count
//      
//      
//      if averageDeaths > 10 {
//         currentBehavior = .easing_off
//         attacker_size = .small
//      } else if averageDeaths > 5 {
//         currentBehavior = .standard
//         attacker_size = .medium
//      } else {
//         currentBehavior = .challenging
//         attacker_size = .large
//      }
   }
   func changeBehavior(_ to : AttackerDirectorAction){
      currentBehavior = to
      timeInBehavior = 0
   }
   func adapt(){
      print("Adapt")
      if timeInBehavior >= 20 && currentBehavior == .standard {
            // Generate a random number (0 or 1)
            let randomNumber = Int.random(in: 0...1)
            
            // Use the random number to decide the next behavior
            if randomNumber == 0 {
                changeBehavior(.challenging)
            } else {
                changeBehavior(.easing_off)
            }
        }
        
        if timeInBehavior >= 10 && currentBehavior == .challenging {
            changeBehavior(.standard)
        }
        
        if timeInBehavior >= 10 && currentBehavior == .easing_off {
            changeBehavior(.standard)
        }

      switch currentBehavior {
      case .standard:
         break
      case .challenging:
         playerTimeToPrepare -= 2
      case .easing_off:
         playerTimeToPrepare += 2
      case .reprieve:
         playerTimeToPrepare = (playerTimeToPrepare+2) * 2
      case .boss_fight:
         playerTimeToPrepare = playerTimeToPrepare / 2
      }
   }
   func resetSpawnTimer(){
      timeLeftBeforeSpawningAttack = playerTimeToPrepare
   }
}

struct AttackResult : Codable {
   var playerPeopleDeaths : Int
   var date : Int
   var typeAttack : HordeID
}
enum HordeID : Codable {
   case small, medium, large
}
protocol Undead : Attacker {
   var composition : [ZombieType:Int] {get set}
   var hordeID : HordeID {get set}
}

class Small_Horde : Undead_Horde {
   init() {
      super.init(hordeID : .small, composition : [.shambler : Int.random(in: 10...20)])
   }
   
   required init(from decoder: Decoder) throws {
      fatalError("init(from:) has not been implemented")
   }
}
class Medium_Horde : Undead_Horde {
   init() {
      super.init(hordeID : .medium, composition : [.shambler : Int.random(in: 20...30)])
   }
   
   required init(from decoder: Decoder) throws {
      fatalError("init(from:) has not been implemented")
   }
}
class Large_Horde : Undead_Horde {
   init() {
      super.init(hordeID : .large, composition : [.shambler : Int.random(in: 40...50)])
   }
   required init(from decoder: Decoder) throws {
      fatalError("init(from:) has not been implemented")
   }
}
class Undead_Horde : Undead {
   var hordeID: HordeID
   var composition: [ZombieType : Int]//Save
   var speed: Int = 10//Save
   var status: Attacker_Behavior = .normal//Save
   var distance: Int = 100//Save
   var delayTimer : Int = 0//Save
   var patience = 2//Save
   init(hordeID : HordeID,  composition : [ZombieType : Int]){
      self.hordeID = hordeID
      self.composition = composition
   }
}
class Undead_Horde_Factory {
   func createHorde(_ hordeID : HordeID)->any Attacker{
      switch hordeID {
      case .large :
         return Large_Horde()
      case .medium:
         return Medium_Horde()
      case .small:
         return Small_Horde()
      }
   }
}
