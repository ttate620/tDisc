//
//  OptionsViewController.swift
//  MySecondApp
//
//  Created by Tiffany Tate on 7/29/20.
//  Copyright © 2020 Tiffany Tate. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    @IBOutlet weak var NewGameButton: UIButton!
    @IBOutlet weak var ExistingGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func NewGameSelect(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CourseViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func ExistingGameSelect(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExistingGameViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
