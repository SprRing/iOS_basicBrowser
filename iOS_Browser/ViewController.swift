//
//  ViewController.swift
//  iOS_Browser
//
//  Created by Yen Shou on 3/19/21.
//

import UIKit
import WebKit
import RealmSwift

class ViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate {

    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tabButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var urlTextField: UITextField!
    //@IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var canvas: UIView!
    
    var webView: WKWebView!
    var bookmarks = [Bookmark]()
    var tabs = [Tab]()
    var webViews = [WKWebView]()
    var selectedTab: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBookmarks()
        loadTabs()
        loadWebView()
        urlTextField.delegate = self
        webView.navigationDelegate = self
    }
    
    /*override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let urlString: String = "https://www.apple.com"
        loadWebSite(urlString, true, true)
    }*/
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        urlTextField.text = webView.url?.absoluteString
        
        let tab = tabs[selectedTab]
        let realm = try! Realm()
        try! realm.write {
            tab.title = webView.title!
            tab.url = (webView.url?.absoluteString)!
        }
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
    
    func loadWebSite(_ input: String, _ isURLDomain: Bool, _ isURLPreprocessed: Bool){
        var encodedURL: String = input
        if (!isURLPreprocessed){
            if (isURLDomain) {
                if (encodedURL.starts(with: "http://")){
                    encodedURL = String(encodedURL.dropFirst(7))
                }
                else if (encodedURL.starts(with: "https://")){
                    encodedURL = String(encodedURL.dropFirst(8))
                }
                encodedURL = "https://" + encodedURL.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            }
            else{
                encodedURL = "https://www.google.com/search?dcr=0&q=" + encodedURL.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            }
        }
        
        let url: URL = URL(string: "\(encodedURL)")!
        let urlRequest: URLRequest = URLRequest (url: url)
        webView.load(urlRequest)
        urlTextField.text = encodedURL.lowercased()
        let tab: Tab = tabs[selectedTab]
        let realm = try! Realm()
        try! realm.write {
            tab.initialURL = encodedURL.lowercased()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        let input: String = (urlTextField.text?.trimmingCharacters(in: .whitespaces))!
        if (!input.isEmpty){
            if (input.hasPrefix("https") || input.hasPrefix("http")) {
                loadWebSite(input, true, true)
            }
            else{
                loadWebSite(input, false, false)
            }
        }
        return true
    }
    
    func configureWebView() -> WKWebView {
        let webConfig = WKWebViewConfiguration()
        let frame = CGRect(x:0.0, y:95.0, width:390.0, height:673.0)
        let localwebView = WKWebView(frame: frame, configuration: webConfig)
        localwebView.navigationDelegate = self
        return localwebView
    }
    
    func loadBookmarks(){
        let realm = try! Realm()
        let results = realm.objects(Bookmark.self)
        bookmarks.removeAll()
        for result in results{
            bookmarks.append(result)
        }
    }
    
    func loadTabs() {
        let realm = try! Realm()
        let results = realm.objects(Tab.self)
        for result in results{
            webViews.append(configureWebView())
            tabs.append(result)
        }
        selectedTab = 0
    }
    
    func loadWebView() {
        webView?.removeFromSuperview()
        webView = webViews[selectedTab]
        canvas.addSubview(webView)
        if (webView.url == nil && !tabs[selectedTab].url.isEmpty){
            loadWebSite(tabs[selectedTab].url, true, true)
        }
        else {
            urlTextField.text = webView.url?.absoluteString
        }
    }

    @IBAction func addButtonClicked(_ sender: Any) {
        if let url = webView.url?.absoluteString{
            let realm = try! Realm()
            let newBookmark: Bookmark = Bookmark(value: ["url": url, "title":webView.title])
            try! realm.write{
                realm.add(newBookmark, update: .all)
            }
            loadBookmarks()
        }
    }
    
    func deleteTab(_ tab: Tab, _ tabIndex: Int){
        let realm = try! Realm()
        try! realm.write {
            realm.delete(tab)
        }
        tabs.remove(at: tabIndex)
        webViews.remove(at: tabIndex)
        if (selectedTab == tabIndex) {
            selectedTab = tabIndex - 1
            loadWebView()
            navigationController?.popViewController(animated: true)
        }
        else if (selectedTab > tabIndex) {
            selectedTab = selectedTab - 1
        }
    }
    
    func addTab(_ tab: Tab){
        tabs.append(tab)
        print(tab)
        selectedTab = tabs.count - 1
        webViews.append(configureWebView())
        loadWebView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Bookmarks"){
            let bookmarksViewController = segue.destination as! BookmarksTableViewController
            bookmarksViewController.bookmarks = self.bookmarks
            bookmarksViewController.delegate = self
        }
        else {
            let tabsViewController = segue.destination as! TabsTableViewController
            tabsViewController.tabs = self.tabs
            tabsViewController.delegate = self
            tabsViewController.selectTab = selectedTab
        }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func forwardButtonClicked(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func reloadButtonClicked(_ sender: Any) {
        webView.reload()
    }
    
}

