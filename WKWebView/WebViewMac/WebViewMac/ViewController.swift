//
//  ViewController.swift
//  WebViewMac
//
//  Created by gietal on 3/15/23.
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKNavigationDelegate, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // we can register many handlers
        print("got msg from \(message.name)")
        if message.name == "bridge", let dict = message.body as? NSDictionary {
            print("key1: \(dict["key1"])")
        }
    }
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        webView.configuration.userContentController.add(self, name: "bridge")
        webView.configuration.userContentController.add(self, name: "handler2")
        
        let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "html-css-template-pfnp")!
        webView.loadFileURL(url, allowingReadAccessTo: url)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

