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
    }
    
    // MARK: - UITextField Delegate
    func textFieldDidEndEditing(textField: UITextField) {
        self.postIt.text = textField.text
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
    

}

