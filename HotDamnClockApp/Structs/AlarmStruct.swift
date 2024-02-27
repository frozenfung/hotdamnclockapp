//
//  AlarmStruct.swift
//  HotDamnClockApp
//
//  Created by frozenfung on 2024/1/14.
//

import Foundation
import UIKit

let Days:[String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

struct Alarm: Codable, Identifiable {
    var id = UUID()
    var meridium: String
    var time: String
    var toggle: Toggle
    var title: String?
    var days: [String]
    var sound: String
    var notificationIdentifier: [String]?
    
    static let KEY = "Alarms"
    
    static func saveAlarms(_ savedAlarm: Alarm) {
        var alarms = self.loadAlarms() ?? []
        var sa = savedAlarm
        if sa.toggle == .ON {
            sa.registerNotification()
        }
        alarms.append(sa)
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(alarms) else { return }
        UserDefaults.standard.set(data, forKey: Alarm.KEY)
    }
    
    static func loadAlarms() -> [Alarm]? {
        guard let data = UserDefaults.standard.data(forKey: Alarm.KEY) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([Alarm].self, from: data).sortByTime()
    }
    
    static func deleteAlarm(_ alarmId: UUID) {
        var remainAlarms:[Alarm] = []
        remainAlarms = Alarm.loadAlarms()!
        remainAlarms = remainAlarms.filter { alarm in
            if alarm.id != alarmId {
                return true
            } else {
                alarm.unregisterNotification()
                return false
            }
        }
        UserDefaults.standard.removeObject(forKey: Alarm.KEY)
        remainAlarms.forEach { Alarm.saveAlarms($0) }
    }
    
    static func updateAlarm(_ alarmId: UUID, newAlarm: Alarm) {
        Alarm.deleteAlarm(alarmId)
        Alarm.saveAlarms(newAlarm)
    }
    
    private mutating func registerNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Alarm Notification"
        content.body = self.title ?? "Alarm"
        let sound = "\(self.sound).caf"
        content.sound = UNNotificationSound(named: UNNotificationSoundName.init(sound))
        content.interruptionLevel = .timeSensitive
        
        var weekdays:[Int] = []
        for day in days {
            if Days.contains(day) {
                weekdays.append(Days.firstIndex(of: day)!)
            }
        }
        
        if weekdays.count == 0 {
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.weekday = Date().dayNumberOfWeek()!
            if self.meridium == "PM" {
                dateComponents.hour = Int(self.time.split(separator: ":").first!)! + 12
            } else {
                dateComponents.hour = Int(self.time.split(separator: ":").first!)
            }
            dateComponents.minute = Int(self.time.split(separator: ":").last!)
            
            // Create the trigger as a repeating event.
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents, repeats: false)
            
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if error != nil {
                    // Handle any errors.
                }
            }
            
            self.notificationIdentifier = [uuidString]
        } else {
            self.notificationIdentifier = weekdays.map { weekday in
                var dateComponents = DateComponents()
                dateComponents.calendar = Calendar.current
                dateComponents.weekday = weekday + 1
                if self.meridium == "PM" {
                    dateComponents.hour = Int(self.time.split(separator: ":").first!)! + 12
                } else {
                    dateComponents.hour = Int(self.time.split(separator: ":").first!)
                }
                dateComponents.minute = Int(self.time.split(separator: ":").last!)
                
                // Create the trigger as a repeating event.
                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: dateComponents, repeats: true)
                
                let uuidString = UUID().uuidString
                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                
                // Schedule the request with the system.
                UNUserNotificationCenter.current().add(request) { (error) in
                    if error != nil {
                        // Handle any errors.
                    }
                }
                
                return uuidString
            }
        }
    }
    
    private func unregisterNotification() {
        if let ni = self.notificationIdentifier {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ni)
        }
    }
}

extension Array where Element == Alarm {
    func sortByTime() -> [Alarm] {
        let arr = self
        return arr.sorted {
            var firstTime:Int
            var secondTime:Int
            
            if $0.meridium == "PM" {
                firstTime = Int($0.time.replacingOccurrences(of: ":", with: ""))!+1200
            } else {
                firstTime = Int($0.time.replacingOccurrences(of: ":", with: ""))!
            }
            
            if $1.meridium == "PM" {
                secondTime = Int($1.time.replacingOccurrences(of: ":", with: ""))!+1200
            } else {
                secondTime = Int($1.time.replacingOccurrences(of: ":", with: ""))!
            }
            
            return firstTime < secondTime
        }
    }
}

enum Toggle: Codable {
    case ON
    case OFF
}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
