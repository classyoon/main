//
//  UndeadWaveManager.swift
//  SecurityMeter
//
//  Created by Conner Yoon on 9/25/23.
//

import Foundation

class UndeadWaveManager : ObservableObject {
    var exterior : [any Attacker] = []
    func advanceDay(){
        for var attacker in exterior {
            switch attacker.status {
            case .delayed:
                <#code#>
            case .normal:
                <#code#>
            case .agitated:
                <#code#>
            case .fleeing:
                <#code#>
            case .lingering:
                <#code#>
            case .seiging:
                <#code#>
            }
        }
    }
}

protocol Attacker : Codable {
    var speed : Int {get set}
    var distance : Int {get set}
    var status : Attacker_Behavior {get set}
}
extension Attacker {
    func normalBehavior(){
        
    }
}
enum ZombieType : Codable {
    case shambler, undead_elite, undead_ranged
}
enum Attacker_Behavior : Codable {
    case delayed, normal, agitated, fleeing, lingering, seiging
    /*
     Delayed - Cease advancing
     Normal - Default
     Agitated - Grows in severity
     Fleeing - Leave the area
     Lingering - Lingers at the player camp
     Seiging - Lingers at the player camp but put a timer on when the player must fight them.
     */
}
enum AttackerDirectorAction : Codable {
    case standard, challanging, easing_off, reprieve, difficulty_spike
        /*
         standard - the director will not change anything about the current difficulty of the game
         challenging - the director will gradually make the game harder
         easing_off - the director will gradually make the game easier
         reprieve - the director will make the game a lot easier very fast
         difficulty_spike - the director will make the game a lot harder very fast
         */
}
enum HordeID : Codable {
    case small, medium, large
        /*
         standard - the director will not change anything about the current difficulty of the game
         challenging - the director will gradually make the game harder
         easing_off - the director will gradually make the game easier
         reprieve - the director will make the game a lot easier very fast
         difficulty_spike - the director will make the game a lot harder very fast
         */
}
protocol Undead : Attacker {//This is a protocol in case we want to have different kinds of attacking factions
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
struct HordeData : Codable {
    var name : String
    var composition: [ZombieType : Int]
    var status: Attacker_Behavior
    var distance: Int = 100
    var speed: Int = 10//Savev
}
class Undead_Horde : Undead {
    var hordeID: HordeID
    var composition: [ZombieType : Int]//Save
    var speed: Int = 10//Save
    var status: Attacker_Behavior = .normal//Save
    var distance: Int = 100//Save
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
    func specialSpawnHorde(_ hordeID : HordeID)->any Attacker{
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
