//
//  ProfileViewController.swift
//  MySecondApp
//
//  Created by Tiffany Tate on 8/21/20.
//  Copyright © 2020 Tiffany Tate. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var RecentGamesTable: UITableView!
    @IBOutlet weak var NumGamesPlayedLabel: UILabel!
    @IBOutlet weak var NewGameButton: UIButton!
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var ProfileButton: UIButton!
    var gameList =  GameListView()
    var userID = UserDefaults.standard.object(forKey : "token") as? Int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RecentGamesTable.dataSource = self
        self.RecentGamesTable.delegate = self
        NumGamesPlayedLabel.text = "Games Played : \(String(self.gameList.GAMES.count)) "
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(Logout))
        self.gameList.get(userID:userID!, completionHandler: { games in
            if games == nil {
                Alert().loadProfile(vc:self)
            }
            else {
                self.RecentGamesTable.reloadData()
                
            }
    
        })
    }

    @objc func Logout() {
        UserDefaults.standard.removeObject(forKey:"token")
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        Switcher.updateRootVC()
    }
    @IBAction func NewGameButtonClicked(_ sender: Any) {
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "CourseViewController") as! CourseViewController
         self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func SearchButtonClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CourseViewController") as! CourseViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func ProfileButtonClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
/* Table and Table Cell behavior */
/* ************************************************************ */

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ RecentGamesTable:UITableView, didSelectRowAt indexPath:IndexPath) {
        let selectedGame = self.gameList.GAMES[indexPath.row]
        let selectedCourse = self.gameList.GAMES[indexPath.row].course
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        vc.course_model = CourseViewModel(course: selectedCourse)
        vc.game_model = selectedGame
        self.navigationController?.pushViewController(vc, animated: true)
  
    }
}
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ RecentGamesTable: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.gameList.GAMES.count
    }
    func tableView(_ RecentGamesTable:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RecentGamesTable.dequeueReusableCell(withIdentifier: "RecentGamesCell") as! RecentGameCell
        let game = self.gameList.GAMES[indexPath.row]
        cell.dateLabel.text = game.date_created
        cell.courseNameLabel.text = game.course.name
        cell.scoreLabel.text = "Score : \(String(game.score)) "
        return cell
   
    }
    func tableView(_ RecentGamesTable: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
       return "Previously Played"
    }
    func tableView(_ RecentGamesTable: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let gameID = self.gameList.GAMES[indexPath.row].pk
            GameAPI().deleteGame(gameID:gameID,  completion: { (complete) in
                if !complete {
                    Alert().deleteGame(vc: self)
                }
            })
            self.gameList.GAMES.remove(at: indexPath.row)
            RecentGamesTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}



class RecentGameCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    
}
