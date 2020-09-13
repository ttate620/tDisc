//
//  PopOverMapViewController.swift
//  MySecondApp
//
//  Created by Tiffany Tate on 8/25/20.
//  Copyright © 2020 Tiffany Tate. All rights reserved.
//

import UIKit
import CoreLocation

class AnnotationView: UIViewController {
    var course_name:String?
    var course_model:CourseViewModel?
    
    @IBOutlet weak var StartGameButton: UIButton!
    
    @IBOutlet weak var GetDirectionsButton: UIButton!
    convenience init(course_name:String) {
        self.init()
        self.course_name = course_name
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        CourseAPI().getCourseDetails(name:self.course_name!,  completion: { (course) in self.course_model =  CourseViewModel(course:course!)})
    }
    @IBAction func StartGameButtonClicked(_ sender: Any) {
        let course = self.course_model!
        GameAPI().createGame(courseID: course.pk , userID: UserDefaults.standard.object(forKey:"token") as! Int ) {
            (game) in
            let selectedGame = GameViewModel(game: game!)
            let selectedCourse = course
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
            vc.course_model = selectedCourse
            vc.game_model = selectedGame
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func getDirectionsButtonClicked(_ sender: Any) {
        print("get directions")
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(course_model?.latitude ?? 0), longitude: CLLocationDegrees(course_model?.longitude ?? 0))
        guard let url = URL(string:"http://maps.apple.com/?daddr=\(location.latitude),\(location.longitude)") else { return }
        UIApplication.shared.open(url)
    }

}
