//
//  main.swift
//  linechatGraph
//
//  Created by gietal on 10/13/18.
//  Copyright © 2018 gietal. All rights reserved.
//
// todo
// - use regex
// - handle multiline messages as 1 message

import Foundation


let processors: [MessageProcessor] = [FrequencyProcessor(), WordProcessor()]
var you: String = ""
var currentDate = DateComponents()
let gregorianCalendar = Calendar(identifier: .gregorian) // assume day 1 = sunday
var foundStartDate = false
var endDate = ""
var lastMessageItem = MessageItem(sender: .me, date: currentDate, message: "")
var unhandledMultiLineMessage = 0

func parseCurrentDate(str: String) -> DateComponents? {
    let regex = try! NSRegularExpression(pattern: "[0-9]+[\\/(]", options: []) // this regex will include the trailing / and (
    let nsstr = str as NSString
    let parsedDateString = regex.matches(in: str, options: [], range: NSRange(location: 0, length: nsstr.length)).map { (result) -> String in
        let rr = NSRange(location: result.range.location, length: result.range.length-1)
        return String(nsstr.substring(with: rr))
    }
    
    guard parsedDateString.count == 3 else {
        return nil
    }
    guard let year = Int(parsedDateString[0]),
        let month = Int(parsedDateString[1]),
        let day = Int(parsedDateString[2]) else {
            return nil
    }
    
    var component = DateComponents(calendar: gregorianCalendar, timeZone: TimeZone.current)
    component.year = year
    component.month = month
    component.day = day
    component.weekday = gregorianCalendar.component(.weekday, from: gregorianCalendar.date(from: component)!)
//    let formatter = DateFormatter()
//    formatter.dateFormat = "yyyy/MM/dd"
//    formatter.date(from: str)!
    return component
}

func parseMessageItem(str: [String.SubSequence]) -> MessageItem? {
    // a normal message sohuld at least have a time and sender
    guard str.count >= 2 else {
        return nil
    }
    var sentTime = currentDate
    let timeStr = str[0].split(separator: ":")
    sentTime.hour = Int(timeStr[0])
    sentTime.minute = Int(timeStr[1])
    let sender: MessageItem.Sender = str[1] == you ? .you : .me
    
    let message = str.count < 3 ? "" : String(str[2])
    return MessageItem(sender: sender, date: sentTime, message: message)
}

func handleLine(line: String) {
    if line.starts(with: "Chat history") {
        let index = line.index(line.startIndex, offsetBy: 18)
        you = String(line[index...])
        print("chat history with: \(you)")
    } else if line.starts(with: "Saved on") {
        let index = line.index(line.startIndex, offsetBy: 10)
        endDate = String(line[index...])
        
    } else {
        guard line.count > 0 else {
            return
        }
        
        // TODO: use regex
        
        // check if this is the date info
        let splitted = line.split(separator: "\t")
        if splitted.count == 1 {
            // this is possibly the date
            if let parsedDate = parseCurrentDate(str: String(splitted[0])) {
                currentDate = parsedDate
                if !foundStartDate {
                    print("start date: \(splitted)")
                    print("end date: \(endDate)")
                    foundStartDate = true
                }
                return
            }
        }
        
        // check if this has time info
        if let firstTabIndex = line.firstIndex(of: "\t") {
            let formatter = DateFormatter()
            formatter.dateFormat = "kk:mm"
            if formatter.date(from: String(line[line.startIndex..<firstTabIndex])) == nil {
                // this is a message continuation
                let item = MessageItem(sender: lastMessageItem.sender, date: lastMessageItem.date, message: line)
                processors.forEach({ $0.process(message: item) })
                lastMessageItem = item
                unhandledMultiLineMessage += 1
                return
            }
            
            // this is a normal message
            
            if let item = parseMessageItem(str: splitted) {
                processors.forEach({ $0.process(message: item) })
                lastMessageItem = item
            } else {
                print("[UNHANDLED LINE] \(line)")
            }
            
        } else {
            // this line is a message continuation
            let item = MessageItem(sender: lastMessageItem.sender, date: lastMessageItem.date, message: line)
            processors.forEach({ $0.process(message: item) })
            lastMessageItem = item
            unhandledMultiLineMessage += 1
        }
        
        
        
        
    }
}

////////// main //////////

let filepath = "/Users/gietal/dev/sandbox/AppleSandbox/linechatGraph/linechatGraph/full.txt"

do {
    let content = try String(contentsOfFile: filepath, encoding: .utf8)
    
    content.enumerateLines(invoking: { (line, _) in
        handleLine(line: line)
    })
} catch {
    print("error reading file \(filepath): \(error)")
    exit(1)
}

print("unhandled multiline message: \(unhandledMultiLineMessage)")
// print results
print("")
processors.forEach({ $0.printOutput() })

