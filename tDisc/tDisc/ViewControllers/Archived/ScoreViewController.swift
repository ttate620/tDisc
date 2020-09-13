//
//  ScoreViewController.swift
//  MySecondApp
//
//  Created by Tiffany Tate on 7/17/20.
//  Copyright © 2020 Tiffany Tate. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
    
    @IBOutlet weak var scoreTableView: UITableView!
    var course_model:CourseViewModel?
    var game_model:GameViewModel?
    convenience init(course_model: CourseViewModel, game_model: GameViewModel) {
        self.init()
        self.course_model = course_model
        self.game_model = game_model
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGameData()
        self.scoreTableView.delegate = self
        self.scoreTableView.dataSource = self
        
        
    }
    func getGameData(){
        GameAPI().getGame(gameID: self.game_model!.pk, completion: { (game) in
            self.game_model =  GameViewModel(game:game!)
        })
    }
    
    
     func backAction() -> Void {
        self.navigationController?.popViewController(animated: true)
     }


}

/* Table and Table Cell behavior */
/* ******************************************************************************************************************************************* */
extension ScoreViewController: UITableViewDelegate {
    func tableView(_ scoreTableView:UITableView, didSelectRowAt indexPath:IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HoleDetailViewController") as! HoleDetailViewController
        vc.holeNum = indexPath.row + 1
        vc.gameID = self.game_model?.pk
        vc.course_model = self.course_model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension ScoreViewController: UITableViewDataSource {
    func tableView(_ scoreTableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.course_model!.num_of_holes
      
    }
    func tableView(_ scoreTableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let score_cell = scoreTableView.dequeueReusableCell(withIdentifier: "score_cell") as! ScoreCell
        score_cell.HoleNumberLabel.text = "Hole " + String(indexPath.row + 1)
        return score_cell
   
    }
}
class ScoreCell: UITableViewCell {
    
    @IBOutlet weak var HoleNumberLabel: UILabel!
    

    
}
