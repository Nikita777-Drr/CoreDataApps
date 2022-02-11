//
//  WebViewViewController.swift
//  URlSessionApp
//
//  Created by User on 07.02.2022.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    var selectedCourse:String?
    var courseUrl = ""
    
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createWebView()
    }
    fileprivate func createWebView() {
        title = selectedCourse
        
        if let url = URL(string: courseUrl){
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
        
        webView.allowsBackForwardNavigationGestures = true
    }
    

}
