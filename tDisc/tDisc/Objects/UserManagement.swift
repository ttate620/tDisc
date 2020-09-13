//
//  UserManagement.swift
//  MySecondApp
//
//  Created by Tiffany Tate on 7/27/20.
//  Copyright © 2020 Tiffany Tate. All rights reserved.
//

import Foundation
import UIKit

var loginIn_url = "http://127.0.0.1:8000/api/accounts/login/"
var register_url = "http://127.0.0.1:8000/api/accounts/register/"
struct UserViewModel: Codable {
    var pk: Int
    var username: String
    var email: String
}


class UserAPI {
    func registerUser(firstname: String, lastname:String, username: String, email:String, password:String, completion: @escaping ([String:String]) -> ()) {
        let url = URL(string: register_url)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
         let parameters = "first name=\(firstname)&last name=\(lastname)&username=\(username)&email=\(email)&password=\(password)"
         request.httpBody = parameters.data(using:String.Encoding.utf8)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data,
             let response = response as? HTTPURLResponse,
             error == nil else {
             print("error", error ?? "Unknown error")
                DispatchQueue.main.async { completion(["error":"true", "status":"Unknown Error"])}
             return
        }

        guard (200 ... 299) ~= response.statusCode else {
             print("statusCode should be 2xx, but is \(response.statusCode)")
             print("response = \(response)")
             if response.statusCode <= 499 || response.statusCode >= 400 {
                 DispatchQueue.main.async {completion(["error":"true","status":"Email already exists"])}
                 return
             }
             DispatchQueue.main.async {completion(["error":"true","status":"Unknown Error"])}
             return
        }
            DispatchQueue.main.async {completion(["error":"false","status":"true"])}
        }
        task.resume()
        
    }
    func loginUser(username: String, email: String, password: String, completion: @escaping ([String:String]) -> () ) {
        
       let url = URL(string: loginIn_url)!
       var request = URLRequest(url: url)
       request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
       request.httpMethod = "POST"
       let parameters = "username=\(username)&email=\(email)&password=\(password)"
        request.httpBody = parameters.data(using:String.Encoding.utf8)
       

       let task = URLSession.shared.dataTask(with: request) { data, response, error in
           guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
                print("error", error ?? "Unknown error")
                DispatchQueue.main.async { completion(["status":"false"])}
                return
           }

           guard (200 ... 299) ~= response.statusCode else {                    
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                if response.statusCode <= 499 || response.statusCode >= 400 {
                    DispatchQueue.main.async {completion(["status":"false"])}
                    return
                }
                DispatchQueue.main.async {completion(["status":"false"])}
                return
           }

           let responseString = String(data: data, encoding: .utf8)
           
        
        DispatchQueue.main.async {completion(["status":"true", "body": responseString!])}
       }

       task.resume()
    }
}
