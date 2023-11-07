//
//  UndeadAttackers.swift
//  SecurityMeter
//
//  Created by Conner Yoon on 10/30/23.
//

import Foundation
enum ZombieType : Codable {
   case shambler, undead_elite, undead_ranged
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
   func createHorde(_ hordeID : HordeID)->any Undead{
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
