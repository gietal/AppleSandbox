// Copyright © Microsoft Corporation 2016

import Foundation

public extension FileManager {
    
    /**
     Determines if a file exists at the given URL.
     
     - parameter fileURL: The file URL.
     
     - returns: true if the file exists, otherwise false.
     */
    public func fileExistsAtURL(_ fileURL: URL) -> Bool {
        return fileExists(atPath: fileURL.path)
    }
    
    /**
     Determines if a directory exists at the given URL.
     
     - parameter directoryURL: The directory URL.
     
     - returns: true if the directory exists, otherwise false.
     */
    public func directoryExistsAtURL(_ directoryURL: URL) -> Bool {
        return directoryExistsAtPath(directoryURL.path)
    }
    
    /**
     Determines if a directory exists at the given path.
     
     - parameter path: The directory path.
     
     - returns: true if the directory exists, otherwise false.
     */
    public func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory: ObjCBool = false
        if !fileExists(atPath: path, isDirectory:&isDirectory) {
            return false
        }
        return isDirectory.boolValue
    }
    
    /**
     Determines if the file is a symbolic link.
     
     - parameter path: The file path.
     
     - returns: true if symbolic link, otherwise false.
     */
    public func isSymbolicLinkAtURL(_ url: URL) -> Bool {
        return isSymbolicLinkAtPath(url.path)
    }
    
    /**
     Determines if the file is a symbolic link.
     
     - parameter path: The file path.
     
     - returns: true if symbolic link, otherwise false.
     */
    public func isSymbolicLinkAtPath(_ path: String) -> Bool {
        guard let fileAttributes = try? attributesOfItem(atPath: path) else {
            return false
        }
        guard let fileType = fileAttributes[FileAttributeKey.type] as? String else {
            return false
        }
        
        return fileType == FileAttributeType.typeSymbolicLink.rawValue
    }
    
    /**
     Determines the absolute destination path of the symbolic link.
     
     - parameter path: The symbolic link file path.
     
     - throws: Throws if the path is not a symbolic link.
     
     - returns: The absolute destination path of the symbolic link.
     */
    public func absoluteDestinationOfSymbolicLinkAtURL(_ url: URL) throws -> URL  {
        enum ErrorType: Error {
            case invalidURL
        }
        
        let absoluteDestinationPath = try absoluteDestinationOfSymbolicLinkAtPath(url.path)
        return URL(fileURLWithPath: absoluteDestinationPath)
    }
    
    /**
     Determines the absolute destination path of the symbolic link.
     
     - parameter path: The symbolic link file path.
     
     - throws: Throws if the path is not a symbolic link.
     
     - returns: The absolute destination path of the symbolic link.
     */
    public func absoluteDestinationOfSymbolicLinkAtPath(_ path: String) throws -> String  {
        let destinationPath = try destinationOfSymbolicLink(atPath: path)
        if NSString(string: destinationPath).isAbsolutePath {
            return destinationPath
        }
        let parentPath = NSString(string: path).deletingLastPathComponent
        return NSString(string: parentPath).appendingPathComponent(destinationPath)
    }
    
    /**
     Gets the relationship.
     
     - parameter directoryURL: The directory URL.
     - parameter itemURL:      The item URL.
     
     - returns: The NSURLRelationship.
     */
    public func getRelationship(directoryURL: URL, itemURL: URL) -> FileManager.URLRelationship? {
        var relationship = FileManager.URLRelationship.other
        do {
            try getRelationship(&relationship, ofDirectoryAt: directoryURL, toItemAt: itemURL)
            return relationship
        } catch {
            return nil
        }
        
    }
    
    /**
     Gets the absolute relationship which includes file URL's that do not exist.
     
     - parameter directoryURL: The directory URL.
     - parameter itemURL:      The item URL.
     
     - returns: The NSURLRelationship.
     */
    public func getAbsoluteRelationship(directoryURL: URL, itemURL: URL) -> FileManager.URLRelationship? {
        enum ErrorType: Error {
            case invalidURL
        }
        
        var absoluteItemURL = itemURL
        if !fileExistsAtURL(absoluteItemURL) {
            let parentURL = absoluteItemURL.deletingLastPathComponent()
            absoluteItemURL = parentURL
        }
        return getRelationship(directoryURL: directoryURL, itemURL: absoluteItemURL)
    }
    
    /**
     Determinies if the file URL is related.
     
     - parameter itemURL:      The item URL.
     - parameter directoryURL: The directory URL.
     
     - returns: true if related, otherwise false.
     */
    public func isFileURLRelated(_ itemURL: URL, directoryURL: URL) -> Bool {
        guard let relationship = getAbsoluteRelationship(directoryURL: directoryURL, itemURL: itemURL) else {
            return false
        }
        switch relationship {
        case .other:
            return false
        case .same, .contains:
            return true
        }
    }
    
    /**
     Determines if the item URL parent is directory URL.
     
     - parameter itemURL:      The item URL.
     - parameter directoryURL: The directory URL.
     
     - returns: true if the directory URL is the parent URL.
     */
    public func isParentURL(_ itemURL: URL, directoryURL: URL) -> Bool {
        let parentURL = itemURL.deletingLastPathComponent()
        guard let relationship = getAbsoluteRelationship(directoryURL: directoryURL, itemURL: parentURL) else {
            return false
        }
        switch relationship {
        case .other, .contains:
            return false
        case .same:
            return true
        }
    }
    
}
