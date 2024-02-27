//
//  ClockStruct.swift
//  HotDamnClockApp
//
//  Created by frozenfung on 2024/1/7.
//

import Foundation

struct Clock: Codable {
    var city: String
    
    static let KEY = "worldClocks"
    static func saveWorldClocks(savedClock: Clock) {
        var clocks = self.loadWorldClocks() ?? []
        var isClockExisted = false
        for clock in clocks {
            if savedClock.city == clock.city {
                isClockExisted = true
            }
        }
        
        if isClockExisted {
            return
        }
        
        clocks.append(savedClock)
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(clocks) else { return }
        UserDefaults.standard.set(data, forKey: Clock.KEY)
    }
    
    static func loadWorldClocks() -> [Clock]? {
        guard let data = UserDefaults.standard.data(forKey: Clock.KEY) else { return nil }
        print("loadWorldClocks")
        let decoder = JSONDecoder()
        return try? decoder.decode([Clock].self, from: data)
    }
    
    static func removeWorldClocks(removedClock: String) {
        var clocks:[Clock] = []
        clocks = Clock.loadWorldClocks()!
        print("clocks.count: \(clocks.count)")
        for (i, clock) in clocks.enumerated() {
            if removedClock == clock.city {
                clocks.remove(at: i)
            }
        }

        UserDefaults.standard.removeObject(forKey: Clock.KEY)
        
        for clock in clocks {
            Clock.saveWorldClocks(savedClock: clock)
        }
    }
}
