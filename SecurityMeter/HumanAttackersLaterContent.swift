//
//  HumanAttackersLaterContent.swift
//  SecurityMeter
//
//  Created by Conner Yoon on 10/5/23.
//

import Foundation
enum HumanAttackerType : Codable {
    case raiders, melee, ranged
}
protocol Human : Attacker {
    var composition : [HumanAttackerType:Int] {get set}
}
