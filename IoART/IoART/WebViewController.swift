//
//  WebViewController.swift
//  IoART
//
//  Created by Andrew Fang on 4/20/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate {
    
    var linkUrl:NSURL!
    @IBOutlet weak var navBarView:UIView!
    @IBOutlet weak var webView:UIWebView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var forwardButton:UIButton!
    @IBOutlet weak var backButton:UIButton!
    @IBOutlet weak var refreshButton:UIButton!
    @IBOutlet weak var urlTextField:UITextField!
    
    var appColor = UIColor.appYellow()
    
    // MARK: - Actions
    
    @IBAction func goBack() {
        self.webView.goBack()
    }
    
    @IBAction func goForward() {
        self.webView.goForward()
    }
    
    @IBAction func refresh() {
        self.webView.reload()
    }
    
    private func configureNavButtons() {
        self.backButton.enabled = self.webView.canGoBack
        self.forwardButton.enabled = self.webView.canGoForward
    }
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        self.urlTextField.delegate = self
        let swipeG = UIPanGestureRecognizer(target: self, action: #selector(self.moveCircleSender(_:)))
        self.circleView.addGestureRecognizer(swipeG)
        self.circleView.backgroundColor = UIColor.appYellow()
        self.forwardButton.tintColor = UIColor.whiteColor()
        self.backButton.tintColor = UIColor.whiteColor()
        self.refreshButton.tintColor = UIColor.whiteColor()
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string:"http://www.google.com")!))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.circleView.backgroundColor = self.appColor
        self.navBarView.backgroundColor = self.appColor
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(textField: UITextField) {
        if let text = textField.text {
            if text.containsString(".") && !text.containsString(" ") {
                var httpText:String
                if (!text.containsString("http")) {
                    httpText = "http://".stringByAppendingString(text)
                } else {
                    httpText = text
                }
                if let url = NSURL(string: httpText) {
                    self.webView.loadRequest(NSURLRequest(URL: url))
                }
            } else {
                let cleanText = text.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                if let url = NSURL(string: "https://www.google.com/webhp?hl=en#hl=en&q=\(cleanText)") {
                    self.webView.loadRequest(NSURLRequest(URL: url))
                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        self.linkUrl = request.mainDocumentURL
        self.urlTextField.text = request.mainDocumentURL?.absoluteString
        return true
    }
    
    // MARK: Moving Circle + Webview
    private var originalCircleCenter: CGPoint!
    private var originalWebCenter: CGPoint!
    func moveCircleSender(recognizer: UIPanGestureRecognizer) {
        
        if (recognizer.state == .Began) {
            // Save the start position
            self.originalCircleCenter = self.circleView.center
            self.originalWebCenter = self.webView.center
        } else if (recognizer.state == .Changed) {
            
            // Move relative to the start position
            let translation = recognizer.translationInView(self.circleView)
            self.circleView.center.x = self.originalCircleCenter.x + translation.x
            self.circleView.center.y = self.originalCircleCenter.y + translation.y
            self.webView.center.x = self.originalWebCenter.x + translation.x
            self.webView.center.y = self.originalWebCenter.y + translation.y
        } else if (recognizer.state == .Ended) {
            
            let velocity = recognizer.velocityInView(self.circleView)
            
            // If it hasn't moved far enough, bring it back
            if (velocity.y > -500 ) {
                UIView.animateWithDuration(0.3, animations: {
                    self.circleView.center = self.originalCircleCenter
                    self.webView.center = self.originalWebCenter
                })
            } else {
                // Send off the post request here
                // TODO: Change this!
                NetworkingManager.sharedInstance.sendHTTPPostPostIt("{type:web, link:\(self.linkUrl.absoluteString)}")
                
                // Send the circle flying
                UIView.animateWithDuration(0.3, animations: {
                    
                    self.circleView.center.x = self.originalCircleCenter.x + velocity.x
                    self.circleView.center.y = self.originalCircleCenter.y + velocity.y
                    self.webView.center.x = self.originalWebCenter.x + velocity.x
                    self.webView.center.y = self.originalWebCenter.y + velocity.y
                    }
                    , completion: { done in
                        // Fade in a "new" circle
                        self.circleView.alpha = 0.0
                        self.circleView.center = self.originalCircleCenter
                        self.webView.alpha = 0.0
                        self.webView.center = self.originalWebCenter
                        UIView.animateWithDuration(0.3, animations: {
                            self.circleView.alpha = 1.0
                            self.webView.alpha = 1.0
                        })
                })
            }
        }
    }
    
    
    
}
