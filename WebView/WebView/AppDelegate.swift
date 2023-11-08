//
//  AppDelegate.swift
//  WebView
//
//  Created by gietal on 9/15/23.
//

import Cocoa
import WebKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!

    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

class ViewController: NSViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func awakeFromNib() {
    }
    override func viewDidLoad() {
        let request = URLRequest(url: Bundle.main.url(forResource: "eula", withExtension: "html")!)
        webView.load(request)
        
//        let url = Bundle.main.url(forResource: "eula", withExtension: "html", subdirectory: "")!
//        webView.loadFileURL(url, allowingReadAccessTo: url)
//        let request = URLRequest(url: url)
//        webView.load(request)
//        let req = URLRequest(url: URL(string: "https://www.google.com")!)
//        webView.load(req)
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        print("button pressed")
    }
}

