//
//  WordProcessor.swift
//  linechatGraph
//
//  Created by gietal on 10/13/18.
//  Copyright © 2018 gietal. All rights reserved.
//

import Foundation
class WordProcessor: MessageProcessor {
    var words = [String: [UInt]]()
    let delimiters: CharacterSet = [" ", ".", ",", "\"", "\t", "?", "!", ":", "(", ")"]
    let topWordCount = 20
    
    func process(message: MessageItem) {
        for w in message.messageLowered.components(separatedBy: delimiters) {
            if w.isEmpty {
                continue
            }
            
            // ignore number
            if Int(w) != nil {
                continue
            }
            
            if words[w] == nil {
                words[w] = [0, 0]
            }
            
            words[w]![message.sender.rawValue] += 1
        }
    }
    
    func printOutput() {
        print("word, me, you, total")
        let me = MessageItem.Sender.me.rawValue
        let you = MessageItem.Sender.you.rawValue
        var i = 0
        for (w, _) in words.sorted(by: { $0.value[me] + $0.value[you] > $1.value[me] + $1.value[you] }) {
            let myCount = words[w]![me]
            let yourCount = words[w]![you]
            print("\(w), \(myCount), \(yourCount), \(myCount + yourCount)")
            
            
            // only print the top n words
            i += 1
            if i == topWordCount {
                break
            }
        }
    }
}
