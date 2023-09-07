//
//  RecordManager.swift
//  lumberJack
//
//  Created by admin on 07.09.2023.
//

import Foundation

struct ScoreRecord: Codable {
    var score: Int
    var name: String
}

class RecordManager {
    
    static let shared = RecordManager()
    
    private let userDefaults = UserDefaults.standard
    private let key = "scoreRecords"
    
    func isNewRecord(score: Int) -> Bool{
        if userDefaults.object(forKey: "record") != nil {
            let record = userDefaults.object(forKey: "record") as! Int
            if score > record  {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    // Добавить новую запись рекорда
    func addScoreRecord(score: Int, name: String) {
        var scoreRecords = getScoreRecords()
        let newRecord = ScoreRecord(score: score, name: name)
        scoreRecords.append(newRecord)
        
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(scoreRecords) {
            userDefaults.set(encodedData, forKey: key)
        }
        if userDefaults.object(forKey: "record") != nil {
            let record = userDefaults.object(forKey: "record") as! Int
            if score > record  {
                userDefaults.set(score, forKey: "record")
            }
        } else {
            userDefaults.set(score, forKey: "record")
        }
    }
    
    // Получить таблицу рекордов
    func getScoreRecords() -> [ScoreRecord] {
        if let data = userDefaults.data(forKey: key) {
            let decoder = JSONDecoder()
            if let scoreRecords = try? decoder.decode([ScoreRecord].self, from: data) {
                return scoreRecords
            }
        }
        return []
    }
    
}
