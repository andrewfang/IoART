//
//  ViewController.swift
//  IoART
//
//  Created by Andrew Fang on 4/19/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Data
    // The post it. This stores the color and text that will be sent to the server
    var postIt = PostIt()

    // MARK: - Outlets
    @IBOutlet weak var postitView: UIView!
    @IBOutlet weak var postitText: UITextView!
    
    // MARK: - Actions
    @IBAction func changePostItColor(sender: UIButton) {
        self.postitView.backgroundColor = sender.backgroundColor
        self.postIt.color = sender.backgroundColor
        // Change the "done button" color above the keyboard
        if let doneBar = self.postitText.inputAccessoryView as? UIToolbar {
            if let doneBarItems = doneBar.items {
                doneBarItems.last?.tintColor = sender.backgroundColor
            }
        }
    }
    
    // MARK: - View controller lifecycle
    override func viewDidLoad() {
        self.postitText.delegate = self
        self.postitText.inputAccessoryView = makeInputAccessoryView()
        self.postitText.tintColor = UIColor.whiteColor()
        
        let panG = UIPanGestureRecognizer(target: self, action: #selector(ViewController.movePostIt(_:)))
        self.postitView.addGestureRecognizer(panG)
    }
    
    // MARK: - UITextView Delegate
    func textViewDidChange(textView: UITextView) {
        self.postIt.text = textView.text
    }
    
    // Creates a bar above the keyboard that hides the keyboard
    func makeInputAccessoryView() -> UIToolbar{
        let toolbar = UIToolbar()
        toolbar.barStyle = .Default
        toolbar.sizeToFit()
        
        let flex = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(ViewController.hideKeyboard))
        done.tintColor = UIColor.appBlue()
        
        toolbar.setItems([flex, done], animated: false)
        return toolbar
    }
    
    func hideKeyboard() {
        self.postitText.endEditing(true)
    }
    
    // MARK: Moving PostIt
    private var originalPostItCenter: CGPoint!
    func movePostIt(recognizer: UIPanGestureRecognizer) {
        
        if (recognizer.state == .Began) {
            // Save the start position
            self.originalPostItCenter = self.postitView.center
        } else if (recognizer.state == .Changed) {
            
            // Move relative to the start position
            let translation = recognizer.translationInView(self.postitView)
            self.postitView.center.x = self.originalPostItCenter.x + translation.x
            self.postitView.center.y = self.originalPostItCenter.y + translation.y
        } else if (recognizer.state == .Ended) {
            
            let translation = recognizer.translationInView(self.postitView)
            let velocity = recognizer.velocityInView(self.postitView)
            
            // If it hasn't moved far enough, bring it back
            if (self.originalPostItCenter.y + translation.y > 0 && velocity.y > -500 ) {
                UIView.animateWithDuration(0.3, animations: {
                    self.postitView.center = self.originalPostItCenter
                })
            } else {
                // Send off the post request here
                NetworkingManager.sharedInstance.sendHTTPPostPostIt(self.postIt.convertToURL())
                
                // Send the post it flying
                UIView.animateWithDuration(0.3, animations: {
                    self.postitView.center.x = self.originalPostItCenter.x + velocity.x
                    self.postitView.center.y = self.originalPostItCenter.y + velocity.y
                    }
                    , completion: { done in
                        // Fade in a "new" post-it, which is just the old one cleared
                        self.postitView.alpha = 0.0
                        self.postitText.text = ""
                        self.postitView.center = self.originalPostItCenter
                        UIView.animateWithDuration(0.3, animations: {
                            self.postitView.alpha = 1.0
                            })
                })
            }
        }
    }

}

