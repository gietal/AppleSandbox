//  Copyright © 2016 Microsoft. All rights reserved.

import Foundation
import Cocoa

extension NSWindow {
    
    /*
     For debugging purposes
     Print the collection behaviour and style mask of a window
     */
    public func debugPrintWindowStyle() {
        Swift.print("-------------------------------------")
        Swift.print("Collection Behaviour: ")
        Swift.print(".canJoinAllSpaces: \(self.collectionBehavior.contains(.canJoinAllSpaces))")
        Swift.print(".moveToActiveSpace: \(self.collectionBehavior.contains(.moveToActiveSpace))")
        Swift.print(".managed: \(self.collectionBehavior.contains(.managed))")
        Swift.print(".transient: \(self.collectionBehavior.contains(.transient))")
        Swift.print(".stationary: \(self.collectionBehavior.contains(.stationary))")
        Swift.print(".participatesInCycle: \(self.collectionBehavior.contains(.participatesInCycle))")
        Swift.print(".fullScreenPrimary: \(self.collectionBehavior.contains(.fullScreenPrimary))")
        Swift.print(".fullScreenAuxiliary: \(self.collectionBehavior.contains(.fullScreenAuxiliary))")
        if #available(OSX 10.11, *) {
            Swift.print(".fullScreenAllowsTiling: \(self.collectionBehavior.contains(.fullScreenAllowsTiling))")
        } else {
            // Fallback on earlier versions
        }
        if #available(OSX 10.11, *) {
            Swift.print(".fullScreenDisallowsTiling: \(self.collectionBehavior.contains(.fullScreenDisallowsTiling))")
        } else {
            // Fallback on earlier versions
        }
        Swift.print("")
        Swift.print("Style Mask:")
        Swift.print(".borderless: \(self.styleMask.contains(.borderless))")
        Swift.print(".titled: \(self.styleMask.contains(.titled))")
        Swift.print(".closable: \(self.styleMask.contains(.closable))")
        Swift.print(".miniaturizable: \(self.styleMask.contains(.miniaturizable))")
        Swift.print(".resizable: \(self.styleMask.contains(.resizable))")
        Swift.print(".texturedBackground: \(self.styleMask.contains(.texturedBackground))")
        Swift.print(".unifiedTitleAndToolbar: \(self.styleMask.contains(.unifiedTitleAndToolbar))")
        Swift.print(".fullScreen: \(self.styleMask.contains(.fullScreen))")
        Swift.print(".fullSizeContentView: \(self.styleMask.contains(.fullSizeContentView))")
        Swift.print(".utilityWindow: \(self.styleMask.contains(.utilityWindow))")
        Swift.print(".docModalWindow: \(self.styleMask.contains(.docModalWindow))")
        Swift.print(".nonactivatingPanel: \(self.styleMask.contains(.nonactivatingPanel))")
        Swift.print(".hudWindow: \(self.styleMask.contains(.hudWindow))")
        Swift.print("-------------------------------------")
    }
}
