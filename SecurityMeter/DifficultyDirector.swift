//
//  DifficultyDirector.swift
//  SecurityMeter
//
//  Created by Conner Yoon on 10/30/23.
//

import Foundation
class DifficultyDirector: ObservableObject {
    enum Behavior: Codable {
        case standard, challenging, easing_off, reprieve, boss_fight
    }

    enum Constants {
        static let minPreparationTime = 2
        static let maxPreparationTime = 20
        static let maxPreparationTimeReprieve = 10
        static let minPreparationTimeBossFight = 1
        static let challengeIncrement = 2
        static let easingIncrement = 2
        static let minRepreiveTime = 2
        static let repreiveMultiplier = 3
        static let boss_fightDivider = 3
        static let attackerThreshold = 0.5
        static let dayDecrement = 1
    }

    var history: [AfterBattleReport] = []
    @Published var currentBehavior: Behavior = .standard {
        didSet {
            applyBehavior()
        }
    }
    @Published var timeToPrepareForNext = 10
    @Published var timeBeforeSpawning = 20
    var spawntime: Bool {
        timeBeforeSpawning == 0
    }
    var attacker_size = HordeID.small

    // Add a difficulty factor
    var difficultyFactor: Double = 1.0

    func advanceDay() {
        print("Advance director")
        timeBeforeSpawning -= Constants.dayDecrement
        adapt()
    }

    private func applyBehavior() {
        switch currentBehavior {
        case .standard:
            break
        case .challenging:
            if timeToPrepareForNext > Constants.minPreparationTime {
                timeToPrepareForNext -= Int(Double(Constants.challengeIncrement) * difficultyFactor)
            }
        case .easing_off:
            if timeToPrepareForNext < Constants.maxPreparationTime {
                timeToPrepareForNext += Int(Double(Constants.easingIncrement) * difficultyFactor)
            }
        case .reprieve:
            if timeToPrepareForNext < Constants.maxPreparationTimeReprieve {
                timeToPrepareForNext = (timeToPrepareForNext+Constants.minRepreiveTime) * Constants.repreiveMultiplier
            }
        case .boss_fight:
            if timeToPrepareForNext > Constants.minPreparationTimeBossFight {
                timeToPrepareForNext = timeToPrepareForNext / (Constants.boss_fightDivider * Int(difficultyFactor))
            }
        }
    }
    
    func adapt() {
        guard let lastReport = history.last else {
            return
        }
        
        if lastReport.playerDeaths > 0 {
            currentBehavior = .easing_off
        } else if lastReport.percentageOfAttackersDestroyed < Constants.attackerThreshold {
            currentBehavior = .challenging
        } else {
            currentBehavior = .standard
        }
    }

    func resetSpawnTimer() {
        timeBeforeSpawning = timeToPrepareForNext
    }
}
struct AfterBattleReport : Codable {
   var playerDeaths : Int
    var percentageOfAttackersDestroyed : Double
   var date : Int
   var typeAttack : HordeID
}
