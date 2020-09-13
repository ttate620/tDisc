//
//  GameManagement.swift
//  MySecondApp
//
//  Created by Tiffany Tate on 7/28/20.
//  Copyright © 2020 Tiffany Tate. All rights reserved.
//

import Foundation
import UIKit

class GameListView{
    var GAMES: [GameViewModel] = []
    func getGames(userID:Int,  completion: @escaping ([GameViewModel]?) -> ()) {
        GameAPI().getUserGames(userID:userID){games in
            if games == nil {completion(nil)}
            for game in games! {
                self.GAMES.append(GameViewModel.init(game:game))
            }
            completion(self.GAMES)
            
        }
    }
    func get(userID:Int, completionHandler: @escaping ([GameViewModel]?)->Void ) {
        GameAPI().getUserGames(userID:userID){games in
            if games == nil {completionHandler(nil)}
            for game in games! {
                self.GAMES.append(GameViewModel.init(game:game))
            }
            completionHandler(self.GAMES)
            
        }
        
    }
}

struct Game: Codable {
    var pk: Int
    var course: Course
    var user: UserViewModel
    var scoreList: String
    var score: Int
    var date_created: String
    var date_edited: String

}
struct GameViewModel {
    var game: Game
    init(game:Game){
        self.game = game
    }
    var pk:Int {
        return self.game.pk
    }
    var course:Course {
        return self.game.course
    }
    var score_list:Array<String> {
        let string1 = self.game.scoreList
        let stringwithoutquotes = string1.replacingOccurrences(of:"\"", with: " ")
        let removebracket1 = stringwithoutquotes.replacingOccurrences(of:"[", with: "")
        let removebracket2 = removebracket1.replacingOccurrences(of:"]", with: "")
        let removecommas = removebracket2.replacingOccurrences(of: ",", with: " ")
        let array = removecommas.split(separator: " ").map { String($0) }
        return array
    }
    var score:Int {
        return self.game.score
    }
    var date_created:String {
        return self.game.date_created
    }
    var date_edited:String {
        return self.game.date_edited
    }
    
}


class GameAPI {
    var createGame_url = "http://127.0.0.1:8000/games/create/"
    var saveGame_url = "http://127.0.0.1:8000/games/update/"
    var userGames_url = "http://127.0.0.1:8000/games/"
    var getGame_url = "http://127.0.0.1:8000/games/"
    var deleteGame_url = "http://127.0.0.1:8000/games/delete/"
    
    func getUserGames(userID:Int, completion: @escaping ([Game]?) -> () ) {
        let url = URL(string: userGames_url + "USER-ID=\(userID)/")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data,
             let response = response as? HTTPURLResponse,
             error == nil else {
                print("error", error ?? "Unknown error")
                DispatchQueue.main.async { completion(nil)}
                return
            }
     
            guard (200 ... 299) ~= response.statusCode else {
                 print("statusCode should be 2xx, but is \(response.statusCode)")
                 print("response = \(response)")
                 if response.statusCode <= 499 || response.statusCode >= 400 {
                     DispatchQueue.main.async {completion(nil)}
                     return
                 }
                 DispatchQueue.main.async {completion(nil)}
                 return
            }
            DispatchQueue.main.async {
                    do {
                        let games = try JSONDecoder().decode([Game].self, from:data!)
                        completion(games)
                    }
                    catch {
                        print("error ", error)
                    }
            }
        }
        
        task.resume()
    
    }
    
    
    func saveGame(gameID:Int, hole:Int, score:Int,  completion: @escaping (Game?) -> ()) {
        let url = URL(string: saveGame_url)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        let parameters = "gameID=\(gameID)&hole=\(hole)&score=\(score)"
        request.httpBody = parameters.data(using:String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data,
            let response = response as? HTTPURLResponse,
            error == nil else {
               print("error", error ?? "Unknown error")
                DispatchQueue.main.async {completion(nil)}
               return
            }
        
               guard (200 ... 299) ~= response.statusCode else {
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    if response.statusCode <= 499 || response.statusCode >= 400 {
                        DispatchQueue.main.async {completion(nil)}
                        return
                    }
                    DispatchQueue.main.async {completion(nil)}
                    return
               }
               DispatchQueue.main.async {
                    do {
                        let game = try JSONDecoder().decode(Game.self, from:data!)
                        completion(game)
                    }
                    catch {
                        print("error ", error)
                    }
            }
           }
           
           task.resume()
        
    }
    func getGame(gameID:Int, completion: @escaping (Game?) -> ()) {
           let url = URL(string: getGame_url + "GAME-ID=\(gameID)/")!
           var request = URLRequest(url: url)
           request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
           request.httpMethod = "GET"
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard let _ = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
                   print("error", error ?? "Unknown error")
                   DispatchQueue.main.async { completion(nil)}
                   return
               }
        
               guard (200 ... 299) ~= response.statusCode else {
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    if response.statusCode <= 499 || response.statusCode >= 400 {
                        DispatchQueue.main.async {completion(nil)}
                        return
                    }
                    DispatchQueue.main.async {completion(nil)}
                    return
               }
               DispatchQueue.main.async {
                       do {
                           let game = try JSONDecoder().decode(Game.self, from:data!)
                           completion(game)
                       }
                       catch {
                           print("error ", error)
                       }
               }
           }
           
           task.resume()
    }
    func createGame(courseID:Int, userID:Int,  completion: @escaping (Game?) -> ()) {
        let url = URL(string: createGame_url)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters = "courseID=\(courseID)&userID=\(userID)"
        request.httpBody = parameters.data(using:String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data,
             let response = response as? HTTPURLResponse,
             error == nil else {
                print("error", error ?? "Unknown error")
                DispatchQueue.main.async { completion(nil)}
                return
            }

        guard (200 ... 299) ~= response.statusCode else {
             print("statusCode should be 2xx, but is \(response.statusCode)")
             print("response = \(response)")
             if response.statusCode <= 499 || response.statusCode >= 400 {
                 DispatchQueue.main.async {completion(nil)}
                 return
             }
             DispatchQueue.main.async {completion(nil)}
             return
        }
            DispatchQueue.main.async {
                do {
                    let game = try JSONDecoder().decode(Game.self, from:data!)
                    completion(game)
                }
                catch {
                    print("error ", error)
                }
            }
        }
        task.resume()
        
    }
    
    func deleteGame(gameID:Int, completion: @escaping (Bool) -> ()) {
        let url = URL(string: deleteGame_url)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters = "gameID=\(gameID)"
        request.httpBody = parameters.data(using:String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data,
             let response = response as? HTTPURLResponse,
             error == nil else {
                print("error", error ?? "Unknown error")
                DispatchQueue.main.async { completion(false)}
                return
            }

        guard (200 ... 299) ~= response.statusCode else {
             print("statusCode should be 2xx, but is \(response.statusCode)")
             print("response = \(response)")
             if response.statusCode <= 499 || response.statusCode >= 400 {
                 DispatchQueue.main.async {completion(false)}
                 return
             }
             DispatchQueue.main.async {completion(false)}
             return
        }
            DispatchQueue.main.async {
                do {
                    completion(true)
                }
            }
        }
        task.resume()
        
    }
}
