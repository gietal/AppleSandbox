//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

public enum WindowLevel {
    case normal
    case floating
    case modalPanel
    case utility
    
    var level: Int {
        switch(self) {
        case .normal:
            return value(forLevelKey: .normalWindow)
        case .floating:
            return value(forLevelKey: .floatingWindow)
        case .modalPanel:
            return value(forLevelKey: .modalPanelWindow)
        case .utility:
            return value(forLevelKey: .utilityWindow)
        }
        
    }
    
    fileprivate func value(forLevelKey key: CGWindowLevelKey) -> Int {
        return Int(CGWindowLevelForKey(key))
    }
}

fileprivate func value(forLevelKey key: CGWindowLevelKey) -> Int {
    return Int(CGWindowLevelForKey(key))
}

let window = NSWindow()

// window is an NSWindow instance
window.level = Int(CGWindowLevelForKey(.normalWindow))

var dict = [
    "baseWindow" : value(forLevelKey: .baseWindow),
    "minimumWindow" : value(forLevelKey: .minimumWindow),
    "desktopWindow" : value(forLevelKey: .desktopWindow),
    "backstopMenu" : value(forLevelKey: .backstopMenu),
    "normalWindow" : value(forLevelKey: .normalWindow),
    "floatingWindow" : value(forLevelKey: .floatingWindow),
    "tornOffMenuWindow" : value(forLevelKey: .tornOffMenuWindow),
    "dockWindow" : value(forLevelKey: .dockWindow),
    "mainMenuWindow" : value(forLevelKey: .mainMenuWindow),
    "statusWindow" : value(forLevelKey: .statusWindow),
    "modalPanelWindow" : value(forLevelKey: .modalPanelWindow),
    "popUpMenuWindow" : value(forLevelKey: .popUpMenuWindow),
    "draggingWindow" : value(forLevelKey: .draggingWindow),
    "screenSaverWindow" : value(forLevelKey: .screenSaverWindow),
    "maximumWindow" : value(forLevelKey: .maximumWindow),
    "overlayWindow" : value(forLevelKey: .overlayWindow),
    "helpWindow" : value(forLevelKey: .helpWindow),
    "utilityWindow" : value(forLevelKey: .utilityWindow),
    "desktopIconWindow" : value(forLevelKey: .desktopIconWindow),
    "cursorWindow" : value(forLevelKey: .cursorWindow),
    "assistiveTechHighWindow" : value(forLevelKey: .assistiveTechHighWindow),
    "numberOfWindowLevelKeys" : value(forLevelKey: .numberOfWindowLevelKeys),
]
var sorted = dict.flatMap({ $0}).sorted(by: { (lhs, rhs) -> Bool in
    lhs.value < rhs.value
})

for item in sorted {
    print("\(item.key): \(item.value)")
}




