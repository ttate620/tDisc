//
//  data.swift
//  MySecondApp
//
//  Created by Tiffany Tate on 7/15/20.
//  Copyright © 2020 Tiffany Tate. All rights reserved.
//

import Foundation
import SwiftUI

struct Course: Codable {
    var pk: Int
    var name: String
    var address: String
    var city: String
    var state: String
    var zip_code: String
    var rating: String
    var course_holes_set: [CourseHoles]
    var latitude: Float
    var longitude: Float
}
struct CourseHoles: Codable {
    var pk: Int
    var numberOfHoles: Int
    var parList: String
    var distList: String
}
class CourseListView{
    var COURSES: [CourseViewModel] = []
    func get(completionHandler: @escaping ([CourseViewModel])->Void ) {
        CourseAPI().getCourses{courses in
            for course in courses! {
                self.COURSES.append(CourseViewModel.init(course:course))
            }
            completionHandler(self.COURSES)
            
        }
        
    }
}
struct CourseViewModel {
    var course: Course
    init(course:Course){
        self.course = course
    }
    var pk:Int {
        return self.course.pk
    }
    var name:String {
        return self.course.name
    }
    var rating:String {
        return self.course.rating
    }
    var par_list:Array<String> {
        let string1 = self.course.course_holes_set[0].parList
        let stringwithoutquotes = string1.replacingOccurrences(of:"\"", with: " ")
        let removebracket1 = stringwithoutquotes.replacingOccurrences(of:"[", with: "")
        let removebracket2 = removebracket1.replacingOccurrences(of:"]", with: "")
        let removecommas = removebracket2.replacingOccurrences(of: ",", with: " ")
        let array = removecommas.split(separator: " ").map { String($0) }
        return array
    }
    var distance_list:Array<String> {
        let string1 = self.course.course_holes_set[0].distList
        let stringwithoutquotes = string1.replacingOccurrences(of:"\"", with: " ")
        let removebracket1 = stringwithoutquotes.replacingOccurrences(of:"[", with: "")
        let removebracket2 = removebracket1.replacingOccurrences(of:"]", with: "")
        let removecommas = removebracket2.replacingOccurrences(of: ",", with: " ")
        let array = removecommas.split(separator: " ").map { String($0) }
        return array
    }
    var num_of_holes:Int {
        return self.course.course_holes_set[0].numberOfHoles
    }
    var city:String {
        return self.course.city
    }
    var state:String {
        return self.course.state
    }
    var latitude: Float {
        return self.course.latitude
    }
    var longitude: Float {
        return self.course.longitude
    }
}

let courseDetail_urlString = "http://127.0.0.1:8000/courses/course/"
let courses_urlString = "http://127.0.0.1:8000/courses/courselist/"
class CourseAPI {
    func getCourseDetails(name:String, completion: @escaping (Course?) -> ()) {
        let url = URL(string: courseDetail_urlString)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters = "name=\(name)"
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
                        let course = try JSONDecoder().decode(Course.self, from:data!)
                        completion(course)
                    }
                    catch {
                        print("error ", error)
                    }
            }
           }
           
           task.resume()
        }
    

    
    func getCourses(completion: @escaping ([Course]?) -> ()) {
        guard let url = URL(string: courses_urlString) else {
            print("error url")
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("error ")
                DispatchQueue.main.async {
                completion(nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let courses = try JSONDecoder().decode([Course].self, from:data)
                    completion(courses)
                }
                catch {
                    print("error ", error)
                }  
            }
        }
    .resume()
    }
}
