//
//  ViewController.swift
//  FolderAndFileAccess
//
//  Created by gietal on 10/29/20.
//

import Cocoa

class ViewController: NSViewController {

    @IBAction func startPressed(_ sender: NSButton) {
//        nonSandboxMethod()
        sandboxMethod()
    }
    
    let mainTokenId = "1"
    let subTokenId = "2"
    
    func enumerateFolder(url: URL) {
        do {
            let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants)
            for c in contents {
                textView.string += "\(c.path) | "
                
                do {
                    if c.lastPathComponent == "Downloads" || c.lastPathComponent == "Documents" || c.lastPathComponent == "Desktop" {
//                        storeToken(url: c, id: subTokenId)
//                        startAccessForToken(id: subTokenId)
                    }
                    let fileAttributes: NSDictionary = try fileManager.attributesOfItem(atPath: c.path) as NSDictionary
                    let size = UInt(fileAttributes.fileSize())
                    
                    textView.string += "\(size) bytes\n"
                    
                } catch {
                    textView.string += "\(error.localizedDescription)\n"
                }
                
                
                
            }
        } catch {
            textView.string = error.localizedDescription
        }
    }
    func nonSandboxMethod() {
        let url = URL(fileURLWithPath: "/Users/gietal/Downloads", isDirectory: true)
//        let url = URL(fileURLWithPath: "/Users/gietal/dev/ext", isDirectory: true)
        
        enumerateFolder(url: url)
    }
    func sandboxMethod() {
        let folderPanel = NSOpenPanel()
        folderPanel.canChooseDirectories = true
        folderPanel.canChooseFiles = false
        folderPanel.directoryURL = URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
        folderPanel.styleMask.remove(.resizable)
        folderPanel.allowsMultipleSelection = false
        
        folderPanel.prompt = "pick a folder"
        
        if folderPanel.runModal() == NSApplication.ModalResponse.OK {
            if let url = folderPanel.url {
//                storeToken(url: url, id: mainTokenId)
//                startAccessForToken(id: mainTokenId)
                
                let url2 = url.appendingPathComponent("Downloads", isDirectory: true)
                enumerateFolder(url: url2)
                
            }
        } else {
            textView.string = "cancelled"
            
        }
    }
    @IBOutlet var textView: NSTextView!
    let fileManager = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension ViewController {
    //
    // Stores security scoped resource access token in user defaults.
    //
    public func storeToken(url: URL, id: String) -> Bool {
        do {
            let data = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            UserDefaults.standard.set(data, forKey: id)
            return true
        } catch {
            return false
        }
    }
    
    //
    // Retrieves scoped resource access token from user defaults and starts secured access.
    //
    public func startAccessForToken(id: String) -> Bool {
        guard let data = UserDefaults.standard.data(forKey: id) else {
            return false
        }
        
        do {
            var stale = Bool()
            let url = try URL(resolvingBookmarkData: data, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &stale)
            
            if stale {
                UserDefaults.standard.removeObject(forKey: id)
                return false;
            }
            
            let result = url.startAccessingSecurityScopedResource()
            return result
        } catch {
            return false
        }
    }
    
    public func RemoveToken(id: String)  -> Bool {
        UserDefaults.standard.removeObject(forKey: id)
        return true
    }
    
    //
    // Relinqueshes access to a security scoped resource.
    //
    public func relinquishAccess(id: String) -> Bool {
        do {
            guard let data = UserDefaults.standard.data(forKey: id) else {
                return false
            }
            var stale = Bool()
            let url = try URL(resolvingBookmarkData: data, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &stale)
            
            url.stopAccessingSecurityScopedResource()
            return true
            
        } catch {
            return false
        }
    }
}
