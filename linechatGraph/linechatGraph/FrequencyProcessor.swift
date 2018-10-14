//
//  counterProcessor.swift
//  linechatGraph
//
//  Created by gietal on 10/13/18.
//  Copyright © 2018 gietal. All rights reserved.
//

import Foundation
class FrequencyProcessor: MessageProcessor {
    
    var year = [Int: [Int]]()
    var month = [Int: [Int]]()
    var weekday = [Int: [Int]]()
    var hour = [Int: [Int]]()
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    init() {
        // init predetermined maps
        for i in 1...months.count {
            month[i] = [0,0]
        }
        for i in 1...24 {
            hour[i] = [0,0]
        }
        for i in 1...weekdays.count {
            weekday[i] = [0,0]
        }
    }
    
    func initYearMap(message: MessageItem) {
        // we cant predetermine year
        if year[message.date.year!] == nil {
            year[message.date.year!] = [0,0]
        }
    }
    
    func process(message: MessageItem) {
        initYearMap(message: message)
        
        year[message.date.year!]![message.sender.rawValue] += 1
        month[message.date.month!]![message.sender.rawValue] += 1
        weekday[message.date.weekday!]![message.sender.rawValue] += 1
        hour[message.date.hour!]![message.sender.rawValue] += 1
    }
    
    func printOutput() {
        
        let me = MessageItem.Sender.me.rawValue
        let you = MessageItem.Sender.you.rawValue
        
        print("year, me, you")
        for k in year.keys.sorted() {
            print("\(k), \(year[k]![me]), \(year[k]![you])")
        }
        print("")
        
        print("month, me, you")
        for k in month.keys.sorted() {
            print("\(months[k-1]), \(month[k]![me]), \(month[k]![you])")
        }
        print("")
        
        print("weekday, me, you")
        for k in weekday.keys.sorted() {
            print("\(weekdays[k-1]), \(weekday[k]![me]), \(weekday[k]![you])")
        }
        print("")
        
        print("hour, me, you")
        for k in hour.keys.sorted() {
            print("\(k), \(hour[k]![me]), \(hour[k]![you])")
        }
        print("")
    }
}
