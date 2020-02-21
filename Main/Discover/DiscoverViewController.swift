//
//  DiscoverViewController.swift
//  APCC
//
//  Created by Yusheng Xu on 2/19/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit
import WebKit
class DiscoverViewController: UIViewController {

    var webView: WKWebView!
    
    var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: view.frame)
//        webView.navigationDelegate = self
//        webView.uiDelegate = self
        view.backgroundColor = .white
        title = "Discover"
        navigationController?.navigationBar.largeTitleTextAttributes =
        [.foregroundColor: UIColor.themeColor]
        
        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false
        //let url = URL(fileURLWithPath: Bundle.main.path(forResource: "apcc", ofType: "html")!)
        let url = URL(string: "https://apcc.byuh.edu/")!
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
    }

}

extension DiscoverViewController : WKNavigationDelegate, WKUIDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }
}
