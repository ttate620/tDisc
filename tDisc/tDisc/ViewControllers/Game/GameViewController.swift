//
//  GameViewController.swift
//  MySecondApp
//
//  Created by Tiffany Tate on 8/24/20.
//  Copyright © 2020 Tiffany Tate. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    var course_model:CourseViewModel?
    var game_model:GameViewModel?
    @IBOutlet weak var HoleTable: UITableView!
    @IBOutlet weak var CourseNameLabel: UILabel!
    @IBOutlet weak var CurrentScoreLabel: UILabel!
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var ProfileButton: UIButton!
    
    convenience init(course_model: CourseViewModel, game_model: GameViewModel) {
        self.init()
        self.course_model = course_model
        self.game_model = game_model
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadGame()
        self.HoleTable.dataSource = self
        self.HoleTable.delegate = self
        self.HoleTable.rowHeight = 100.0
        HoleTable.reloadData()
        self.CourseNameLabel.text = self.course_model?.name
        self.CurrentScoreLabel.text = "Score \(String(self.game_model!.score))"
    
    }
    override func viewWillAppear(_ animated: Bool) {
        GameAPI().getGame(gameID: self.game_model!.pk, completion: { (game) in
            if game == nil {Alert().updateGame(vc:self)}
            else {
                self.game_model =  GameViewModel(game:game!)
                self.CurrentScoreLabel.text = "Score \(String(self.game_model!.score))"
            }
        })
        
    }
    
    @IBAction func SearchButtonClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CourseViewController") as! CourseViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func ProfileButtonClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func reloadGame(){ GameAPI().getGame(gameID: self.game_model!.pk, completion: { (game) in self.game_model =  GameViewModel(game:game!)})
    }
}



/* Table and table cell */
extension GameViewController: UITableViewDelegate {
    func tableView(_ HoleTable:UITableView, didSelectRowAt indexPath:IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HoleDetailViewController") as! HoleDetailViewController
        vc.holeNum = indexPath.row + 1
        vc.gameID = self.game_model?.pk
        vc.course_model = self.course_model
        self.navigationController?.pushViewController(vc, animated: true)
  
    }
}
extension GameViewController: UITableViewDataSource {
    func tableView(_ HoleTable: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.course_model!.num_of_holes
    }
    func tableView(_ HoleTable:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HoleTable.dequeueReusableCell(withIdentifier: "HoleGameCell") as! HoleGameCell
        cell.HoleNumLabel.text = "Hole \(String(indexPath.row + 1))"
        cell.ParLabel.text = "Par \(self.course_model!.par_list[indexPath.row])"
        cell.DistanceLabel.text = "Distance: \(self.course_model!.distance_list[indexPath.row]) ft."
        
        return cell
   
    }
    func tableView(_ HoleTable: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
       return "Course Holes"
    }
}
class HoleGameCell: UITableViewCell {
    
    @IBOutlet weak var HoleNumLabel: UILabel!
    @IBOutlet weak var ParLabel: UILabel!
    @IBOutlet weak var DistanceLabel: UILabel!
    
}
