//
//  LoginViewController.swift
//  MySecondApp
//
//  Created by Tiffany Tate on 7/22/20.
//  Copyright © 2020 Tiffany Tate. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    @IBAction func SignUpButtonTapped(_ sender: Any) {
        let email = EmailTextField.text!
        let password = String(PasswordTextField.text!)
        let username = email
        UserAPI().loginUser(username: username, email: email, password: password){
            (result) in
            let status = result["status"]
            if status  == "false" {
                let alert = UIAlertController(title: "Invalid Login", message: "Invalid Login", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                self.EmailTextField.text! = " "
                self.PasswordTextField.text! = " "
            }
            else  {
                
                let response = self.convertToDictionary(text:result["body"]!) as! Dictionary<String,String>
                let token = Int(response["token"]!)
                let email = response["email"]!
                let _ = UserViewModel(pk: token!, username: email, email: email)
                UserDefaults.standard.set(token, forKey: "token")
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.synchronize()
                Switcher.updateRootVC()
            }
            
            
        }
    }

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    func setUpElements() {
        ErrorLabel.alpha = 0
        Utilities.styleTextField(EmailTextField)
        Utilities.styleTextField(PasswordTextField)
        
    }

}
