//
//  DiscoverViewController.swift
//  APCC
//
//  Created by Yusheng Xu on 2/19/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit
import WebKit
import SafariServices
class DiscoverViewController: UIViewController {

    var webView: WKWebView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: view.frame)
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
        webView.navigationDelegate = self
        webView.uiDelegate = self
//        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "apcc", ofType: "html")!)
//        guard let path = Bundle.main.path(forResource: "Style", ofType: "css") else { return }
//        let cssString = try! String(contentsOfFile: path).trimmingCharacters(in: .whitespacesAndNewlines)
//        let jsString = "var style = document.createElement('style'); style.innerHTML = '\(cssString)'; document.head.appendChild(style);"
//        webView.evaluateJavaScript(jsString, completionHandler: nil)
        //let url = URL(string: "https://apcc.byuh.edu/")!
        let path = Bundle.main.path(forResource: "apcc", ofType: "html")!
        let url = URL(fileURLWithPath: path)
        let request = URLRequest(url: url)
        self.webView.load(request)
        
    }
    


}

extension DiscoverViewController : WKNavigationDelegate, WKUIDelegate{
    func openURl(url: URL) {
        let safari = SFSafariViewController(url: url)
        safari.preferredBarTintColor = #colorLiteral(red: 0.5490196078, green: 0, blue: 0.05490196078, alpha: 1)
        safari.preferredControlTintColor = .white
        safari.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        present(safari, animated: true, completion: nil)
    }
//    func webView(_ webView: WKWebView,
//                 createWebViewWith configuration: WKWebViewConfiguration,
//                 for navigationAction: WKNavigationAction,
//        windowFeatures: WKWindowFeatures) -> WKWebView? {
//            if navigationAction.targetFrame == nil {
//                var url = navigationAction.request.url
//                if url.description.lowercaseString.rangeOfString("http://") != nil || url.description.lowercaseString.rangeOfString("https://") != nil || url.description.lowercaseString.rangeOfString("mailto:") != nil  {
//                    UIApplication.shared.Application.openURL(url)
//                }
//            }
//            return nil
//    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            print("here link Activated!!!")
            if let url = navigationAction.request.url {
                openURl(url: url)
            }
            decisionHandler(.cancel)
        }
        else {
            decisionHandler(.allow)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       
        let path = Bundle.main.path(forResource: "styles", ofType: "css")!

        let javaScriptStr = "var link = document.createElement('link'); link.href = '\(path)'; link.rel = 'stylesheet'; document.head.appendChild(link)"
        webView.evaluateJavaScript(javaScriptStr)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
       
    }
}
