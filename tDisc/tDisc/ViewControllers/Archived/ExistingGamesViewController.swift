//
//  ExistingGamesViewController.swift
//  MySecondApp
//
//  Created by Tiffany Tate on 7/30/20.
//  Copyright © 2020 Tiffany Tate. All rights reserved.
//

import UIKit

class ExistingGamesViewController: UIViewController {

    @IBOutlet weak var ExistingGameTableView: UITableView!
    var gameList =  GameListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = UserDefaults.standard.object(forKey:"token") as! Int
        self.gameList.get(userID:userID, completionHandler: { games in
            self.ExistingGameTableView.reloadData()
        })
        self.ExistingGameTableView.delegate = self
        self.ExistingGameTableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stats", style: .plain, target: self, action: #selector(stats))
    }
    @objc func stats() {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StatsViewController") as! StatsViewController
//        vc.modalPresentationStyle = .popover
//        self.present(vc, animated:true, completion:nil)
    }
}
extension ExistingGamesViewController: UITableViewDelegate {
    func tableView(_ ExistingGameTableView:UITableView, didSelectRowAt indexPath:IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScoreViewController") as! ScoreViewController
        vc.course_model = CourseViewModel(course: self.gameList.GAMES[indexPath.row].course)
        vc.game_model = self.gameList.GAMES[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension ExistingGamesViewController: UITableViewDataSource {
    func tableView(_ ExistingGameTableView: UITableView, numberOfRowsInSection section: Int) -> Int{

        return self.gameList.GAMES.count
    }
    func tableView(_ ExistingGameTableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ExistingGameTableView.dequeueReusableCell(withIdentifier: "ExistingGameCell") as! ExistingGameCell
        cell.gameLabel?.text = "\(String(self.gameList.GAMES[indexPath.row].course.name))  played on  \(String(self.gameList.GAMES[indexPath.row].date_edited))"
        return cell

    }
}
class ExistingGameCell: UITableViewCell {
    @IBOutlet weak var gameLabel: UILabel!
    
}
