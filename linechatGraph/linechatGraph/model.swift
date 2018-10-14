//
//  model.swift
//  linechatGraph
//
//  Created by gietal on 10/13/18.
//  Copyright © 2018 gietal. All rights reserved.
//

import Foundation
struct MessageItem {
    enum Sender: Int {
        case me = 0
        case you = 1
    }
    
    public init(sender: Sender, date: DateComponents, message: String) {
        self.sender = sender
        self.date = date
        self.message = message
        self.messageLowered = message.lowercased()
    }
    
    let sender: Sender
    let date: DateComponents
    let message: String
    let messageLowered: String
}

protocol MessageProcessor: class {
    func process(message: MessageItem)
    func printOutput()
}
