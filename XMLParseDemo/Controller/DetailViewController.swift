//
//  DetailViewController.swift
//  XMLParseDemo
//
//  Created by Dnyaneshwar on 12/01/21.
//

import UIKit
import WebKit

class DetailViewController: UIViewController,WKNavigationDelegate {

    var webView : WKWebView!
    var albumURLStr : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let url = URL(string: self.albumURLStr!)
        let request = URLRequest(url: url!)
            webView = WKWebView(frame: self.view.frame)
            webView.navigationDelegate = self
            webView.load(request)
            self.view.addSubview(webView)
            self.view.sendSubviewToBack(webView)
    }
    
    //MARK:- WKNavigationDelegate

    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print("finish to load")
    }

}
