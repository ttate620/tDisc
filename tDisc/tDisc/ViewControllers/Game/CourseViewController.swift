//
//  CourseViewController.swift
//  MySecondApp
//
//  Created by Tiffany Tate on 7/15/20.
//  Copyright © 2020 Tiffany Tate. All rights reserved.
//

import UIKit
import SwiftUI




class CourseViewController: UIViewController {
    @IBOutlet weak var courseTableView: UITableView!
    var courseList =  CourseListView()
    var filteredCourses:[CourseViewModel] = []
    lazy var searchController: UISearchController = {
        let s = UISearchController(searchResultsController: nil)
        s.searchResultsUpdater = self
        s.obscuresBackgroundDuringPresentation = false
        s.searchBar.placeholder = "Search Courses ... "
        s.searchBar.sizeToFit()
        s.searchBar.searchBarStyle = .prominent
        s.searchBar.scopeButtonTitles = ["All", "Rochester", "Buffalo" ]
        s.searchBar.delegate = self
        return s
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        self.courseTableView.delegate = self
        self.courseTableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Find Course", style: .plain, target: self, action: #selector(findCourse))
        courseList.get(completionHandler: { courses in
            self.courseTableView.reloadData()
        })
    }
    @objc func findCourse() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        vc.annotaionLocations = getAnnotationLocations()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getAnnotationLocations() -> Array<(Dictionary<String, Any>)> {
        var annotationLocations = Array<(Dictionary<String, Any>)>()
        for course in self.courseList.COURSES {
            annotationLocations.append(["title": course.name ,"rating": String(course.rating), "latitude": course.latitude, "longitude" : course.longitude, "course_id":course.pk ] )
        }
        return annotationLocations
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All"){
        filteredCourses = courseList.COURSES.filter({ (course) -> Bool in
            let doesCategoryMatch = (scope == "All") || (scope == course.city)
            if isSearchBarEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && course.name.lowercased().contains(searchText.lowercased())
            }
        })
        courseTableView.reloadData()
    }

    func isSearchBarEmpty()-> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func isFiltering() -> Bool {
        let searchBarScopeFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty() || searchBarScopeFiltering)
    }
}


/* Table and Table Cell behavior */
/* ******************************************************************************************************************************************* */
extension CourseViewController: UITableViewDelegate {
    func tableView(_ courseTableView:UITableView, didSelectRowAt indexPath:IndexPath) {
        let course = self.courseList.COURSES[indexPath.row]
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
}
extension CourseViewController: UITableViewDataSource {
    func tableView(_ courseTableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if isFiltering() {
            return filteredCourses.count
        }
        return self.courseList.COURSES.count
    }
    func tableView(_ courseTableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = courseTableView.dequeueReusableCell(withIdentifier: "course_cell") as! CourseCell
        var displayList = [CourseViewModel]()
        if isFiltering() {
            displayList = filteredCourses
        } else {displayList = courseList.COURSES}
        
        let courseLocation = displayList[indexPath.row].city + ", " + displayList[indexPath.row].state
        let courseName = displayList[indexPath.row].name
        cell.courseNameLabel.text = courseName
        cell.courseRatingLabel.text = courseLocation

        return cell
   
    }
}

class CourseCell: UITableViewCell {
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseRatingLabel: UILabel!
    
}

// SearchBar //
extension CourseViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int ) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
extension CourseViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
}
