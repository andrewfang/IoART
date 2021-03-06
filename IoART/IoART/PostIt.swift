//
//  PostIt.swift
//  IoART
//
//  A post it contains the color that it is, along with the text
//  contained in that post it.
//
//  Created by Andrew Fang on 4/19/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//
import UIKit

class PostIt {
    // Instance Vars
    var color: UIColor!
    var text: String!
    
    // MARK: - Contstructors
    init() {
        self.color = UIColor.appYellow()
        self.text = ""
    }
    
    init(color: UIColor) {
        self.color = color
        self.text = ""
    }
    
    // Encodes itself to be sent over HTTP
    func convertToURL() -> String {
        let text = self.text.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        let components = CGColorGetComponents(self.color.CGColor)
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        return "{type:text, text:\(text), red:\(red), green:\(green), blue:\(blue)}"
    }
}