//
//  Utilities.swift
//  MySecondApp
//
//  Created by Tiffany Tate on 7/22/20.
//  Copyright © 2020 Tiffany Tate. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    static func PasswordValidation() {
        
    }
    static func styleTextField(_ textfield:UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha:1).cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
    }
    
    static func styleButton(_ button:UIButton) {
        button.backgroundColor = .green
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
    }
   
}
