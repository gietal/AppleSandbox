//
//  DDLogHelper.swift
//  ModalSheet
//
//  Created by Gieta Laksmana on 8/2/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation
import CocoaLumberjackSwift

internal class DDLogHelper {
    
    internal class func initializeLogging() {
        // Configure console/xcode tracing/logging (debug builds only)
        
        DDASLLogger.sharedInstance().logFormatter = ShortDDLogFormatter()
        DDLog.addLogger(DDASLLogger.sharedInstance())
        
        setenv("XcodeColors", "YES", 0)
        DDTTYLogger.sharedInstance().logFormatter = ShortDDLogFormatter()
        DDTTYLogger.sharedInstance().colorsEnabled = true;
        DDLog.addLogger(DDTTYLogger.sharedInstance())
        
        
        // Enable verbose logging (debug builds only)
        
        defaultDebugLevel = DDLogLevel.All
        
    }
}

//  Copyright © 2015 Microsoft. All rights reserved.

import Foundation
import CocoaLumberjack
/**
 DDLogFormatter which logs level, date, time, filename, line number and the actual message.
 */
@objc public class FullDDLogFormatter: NSObject, DDLogFormatter {
    
    private let helper = FormatHelper()
    
    public func formatLogMessage(logMessage: DDLogMessage!) -> String! {
        let flag = helper.formatFlag(logMessage.flag)
        let date = helper.formatDate(logMessage.timestamp)
        let file = helper.formatFile(logMessage.file, line: logMessage.line)
        return "\(flag)|\(date)|\(file) \(logMessage.message)"
    }
}

/**
 DDLogFormatter which logs level, filename, line number and the actual message.
 */
@objc public class ShortDDLogFormatter: NSObject, DDLogFormatter {
    
    private let helper = FormatHelper()
    
    public func formatLogMessage(logMessage: DDLogMessage!) -> String! {
        let flag = helper.formatFlag(logMessage.flag)
        let file = helper.formatFile(logMessage.file, line: logMessage.line)
        return "\(flag)|\(file) \(logMessage.message)"
    }
}

private class FormatHelper {
    
    private let dateFormatter: NSDateFormatter
    
    private init() {
        // Configure the formatter to log in Gregorian calendar
        // and ISO 8601 datetime format.
        dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    }
    
    private func formatFlag(flag: DDLogFlag) -> String {
        switch flag {
        case DDLogFlag.Error: return "E"
        case DDLogFlag.Warning: return "W"
        case DDLogFlag.Info: return "I"
        case DDLogFlag.Debug: return "D"
        case DDLogFlag.Verbose: return "V"
        default: return "A"
        }
    }
    
    private func formatDate(date: NSDate) -> String {
        return dateFormatter.stringFromDate(date)
    }
    
    private func formatFile(file: String?, line: UInt) -> String {
        if let file = file {
            let filename = NSString(string: file).lastPathComponent
            return "\(filename):\(line)"
        } else {
            return "?:?"
        }
    }
}