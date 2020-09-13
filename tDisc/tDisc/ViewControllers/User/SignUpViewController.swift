//
//  SignUpViewController.swift
//  MySecondApp
//
//  Created by Tiffany Tate on 7/22/20.
//  Copyright © 2020 Tiffany Tate. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var SignUpButton: UIButton!

    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()

    }

    @IBAction func SignUpButtonTapped(_ sender: Any) {
        UserAPI().registerUser(firstname: FirstNameTextField.text!, lastname: LastNameTextField.text!, username:EmailTextField.text!, email: EmailTextField.text!, password: PasswordTextField.text!) {
            (result) in
            
            let error = result["error"]
            let status = result["status"]
            if error  == "true" {
                Alert().signUpAlert(vc: self, status: status!)
                
            }
            else  {
                
                let vc =
                self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func setUpElements() {
        ErrorLabel.alpha = 0
        Utilities.styleTextField(FirstNameTextField)
        Utilities.styleTextField(LastNameTextField)
        Utilities.styleTextField(EmailTextField)
        Utilities.styleTextField(PasswordTextField)
    }
    
}
