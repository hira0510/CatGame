//
//  MenuGoWebViewController.swift
//  AnimalInfo
//
//  Created by  on 2020/5/26.
//  Copyright © 2021 1. All rights reserved.
//

import UIKit
import WebKit

enum MenuGoWebProtocol {
    case http
    case other
    case key
}

class MenuGoWebViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var navHiddenButtonItem: UIBarButtonItem!

    public var mUrls: String = ""
    public var mType: MenuGoWebProtocol = .http
    public var dismissHandler: (() -> ())?
    private var mWkWebView: WKWebView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        initWebView()
        loadURL(urlString: mUrls)
        navHiddenButtonItem.title = ""
        navHiddenButtonItem.isEnabled = false
    }

    private func initWebView() {
        self.view.addSubview(mWkWebView)
        mWkWebView.navigationDelegate = self
        mWkWebView.translatesAutoresizingMaskIntoConstraints = false

        mWkWebView.topAnchor.constraint(equalTo: self.navBar.bottomAnchor).isActive = true
        mWkWebView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mWkWebView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mWkWebView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

    private func loadURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        mWkWebView.customUserAgent = "iPhoneInWebView"
        mWkWebView.load(request)
    }

    @IBAction func didClickHidden(_ sender: UIBarButtonItem) {
        FireBaseManager.shard.reportFirebase(domain: "Web", msg: "點擊", text: "收起")
        mWkWebView.topAnchor.constraint(equalTo: self.topView.bottomAnchor).isActive = true
    }

    @IBAction func didClickDismissBtn(_ sender: UIBarButtonItem) {
        FireBaseManager.shard.reportFirebase(domain: "Web", msg: "點擊", text: "返回")
        dismissHandler?()
        self.dismiss(animated: true, completion: nil)
    }
}

extension MenuGoWebViewController: WKNavigationDelegate, WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let str = navigationAction.request.url?.absoluteString, mType == .key else {
            decisionHandler(.allow)
            return
        }
        if str.contains("a9") || str.contains("appstore") || str.contains("dbfs4") || str.contains("mdsv") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.navHiddenButtonItem.title = "收起"
                self.navHiddenButtonItem.isEnabled = true
            }
        } else {
            guard let url = URL(string: str) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        decisionHandler(.allow)
    }
}
