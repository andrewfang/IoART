//
//  ChangeColorButton.swift
//  IoART
//
//  Created by Andrew Fang on 4/19/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class ChangeColorButton: UIButton {

    override func drawRect(rect: CGRect) {
        // Make the button round
        self.layer.cornerRadius = 15.0
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.0
     
        // When we tap on the button, we fade it out a bit so it looks like it's been tapped
        self.addTarget(self, action: #selector(ChangeColorButton.tapped), forControlEvents: .TouchDown)
        self.addTarget(self, action: #selector(ChangeColorButton.untapped), forControlEvents: .TouchUpInside)
        self.addTarget(self, action: #selector(ChangeColorButton.untapped), forControlEvents: .TouchDragOutside)
    }
    
    func tapped() {
        self.alpha = 0.5
    }
    
    func untapped() {
        self.alpha = 1.0
    }

}
