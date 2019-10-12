//
//  WebController.swift
//  Bookshelf
//
//  Created by zijia on 10/12/19.
//  Copyright © 2019 zijia. All rights reserved.
//

import UIKit
import WebKit
class WebController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var url: URL?
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Book Detail Web"
        guard let url = url else { return }
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }}
