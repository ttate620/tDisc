//
//  UserUtilities.swift
//  MySecondApp
//
//  Created by Tiffany Tate on 8/24/20.
//  Copyright © 2020 Tiffany Tate. All rights reserved.
//

import Foundation
import UIKit

class Switcher {
    
    static func updateRootVC(){
        
        let status = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        var rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
        var navController = UINavigationController(rootViewController: rootVC)
        if(status == true){
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") 
            navController = UINavigationController(rootViewController: rootVC)
        }
        let scene = UIApplication.shared.connectedScenes.first
        if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            sd.window?.rootViewController = navController
            sd.window?.makeKeyAndVisible()
        }
    }
    
}
