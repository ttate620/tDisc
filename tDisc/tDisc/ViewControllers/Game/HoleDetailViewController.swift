//
//  HoleDetailViewController.swift
//  MySecondApp
//
//  Created by Tiffany Tate on 7/21/20.
//  Copyright © 2020 Tiffany Tate. All rights reserved.
//

import UIKit

class HoleDetailViewController: UIViewController {
   
    @IBOutlet weak var holeNumberLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var DistanceLabel: UILabel!
    @IBOutlet weak var parTextLabel: UILabel!
    @IBOutlet weak var scoreStepper: UIStepper!
    @IBOutlet weak var myScore: UILabel!
    
    
    var holeNum:Int?
    var gameID:Int?
    var course_model:CourseViewModel?
    var game_model:GameViewModel?
    var myScoreVar:String?
    convenience init(holeNum:Int, gameID:Int?, course_model:CourseViewModel) {
        self.init()
        self.holeNum = holeNum
        self.gameID = gameID
        self.course_model = course_model
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreStepper.wraps = true
        scoreStepper.autorepeat = true
        let courseName = self.course_model?.name
        let distance = self.course_model!.distance_list[self.holeNum!-1]
        let par = self.course_model!.par_list[self.holeNum!-1]
        courseNameLabel.text = courseName
        holeNumberLabel.text = "Hole \(String(self.holeNum!))"
        parTextLabel.text = "Par \(par)"
        DistanceLabel.text = "\(distance) ft."
        
        GameAPI().getGame(gameID: self.gameID!, completion: { (game) in
            if game == nil {
                Alert().gameIsNil(vc:self)
            } else {
                self.game_model =  GameViewModel(game:game!)
                guard let scorelist = self.game_model?.score_list else {return}
                self.myScoreVar = scorelist[self.holeNum!-1]
                self.myScore.text = self.myScoreVar
                if self.myScoreVar == "0" {
                    self.scoreStepper.value = Double(par)! - 1
                } else {
                    self.scoreStepper.value = Double(self.myScoreVar!)!
                }
            }
        })
        
        
        
    }
    @IBAction func scoreStepperChanged(_ sender: UIStepper) {
        myScore.text = "\(Int(sender.value).description)"
        saveGame(score:Int(sender.value))
        
    }
    
    
    func saveGame(score:Int) {
        GameAPI().saveGame(gameID: self.gameID!, hole: self.holeNum!, score: score) { (game) in
            if game == nil {
                Alert().saveGameAlert(vc: self)
            } else {
                self.game_model =  GameViewModel(game:game!)
            }
        }
    }

}
