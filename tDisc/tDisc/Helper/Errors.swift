//
//  Errors.swift
//  MySecondApp
//
//  Created by Tiffany Tate on 8/27/20.
//  Copyright © 2020 Tiffany Tate. All rights reserved.
//

import Foundation
import UIKit
class Alert {
    func signUpAlert(vc:UIViewController, status:String) {
        let alert = UIAlertController(title: "Error", message: "\(status)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        vc.present(alert, animated: true)
    }
    func gameIsNil(vc:UIViewController) {
        let alert = UIAlertController(title: "Unable to load", message: "Please try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        vc.present(alert, animated: true)
    }
    func updateGame(vc:UIViewController) {
        let alert = UIAlertController(title: "Unable to load game", message: "Please try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        vc.present(alert, animated: true)
    }
    func deleteGame(vc:UIViewController) {
        let alert = UIAlertController(title: "Delete", message: "Unable to delete game", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        vc.present(alert, animated: true)
    }
    func saveGameAlert(vc:UIViewController) {
        let alert = UIAlertController(title: "Unable to save", message: "Please try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        vc.present(alert, animated: true)
    }
    func loadProfile(vc:UIViewController) {
        let alert = UIAlertController(title: "Unable to load profile", message: "Please try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        vc.present(alert, animated: true)
    }
}
