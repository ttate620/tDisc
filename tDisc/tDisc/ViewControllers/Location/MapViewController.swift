//
//  MapViewController.swift
//  MySecondApp
//
//  Created by Tiffany Tate on 8/25/20.
//  Copyright © 2020 Tiffany Tate. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class MapViewController: UIViewController {
    
    @IBOutlet weak var MapView: MKMapView!
    let locationManager = CLLocationManager()
    let regionInMeters:Double = 5000
    var annotaionLocations:Array<(Dictionary<String, Any>)>?
    var pointAnnotations:[MKAnnotation]=[]
    convenience init(annotaionLocations: Array<(Dictionary<String, Any>)>) {
        self.init()
        self.annotaionLocations = annotaionLocations
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
        checkLocationServices()
        createAnnotations(locations: self.annotaionLocations!)
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            checkLocationAuth()
        } else {
            let alert = UIAlertController(title: "Location Services", message: "Please enable device location services", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    func checkLocationAuth() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            MapView.showsUserLocation = true
            centerUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            let alert = UIAlertController(title: "Location Services", message: "Please enable location services", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            let alert = UIAlertController(title: "Location Services", message: "Please enable location services", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    func centerUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            MapView.setRegion(region, animated: true)
        }
    }
    
    func createAnnotations(locations: [[String:Any]]) {
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = location["title"] as? String
            annotation.subtitle = "Rating \(location["rating"] ?? "Unknown")"
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(location["latitude"] as! Float), longitude: CLLocationDegrees(location["longitude"] as! Float))
            pointAnnotations.append(annotation)
            MapView.addAnnotation(annotation)
        }
    }
}


extension MapViewController : MKMapViewDelegate {
    func mapView(_ MapView: MKMapView, didSelect view: MKAnnotationView) {
        if !((view.annotation?.coordinate.longitude == MapView.userLocation.coordinate.longitude) && (view.annotation?.coordinate.latitude == MapView.userLocation.coordinate.latitude)) {
            print("self : \(view.annotation?.coordinate)")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AnnotationView") as! AnnotationView
            vc.course_name = view.annotation?.title as? String
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        MapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuth()
    }
}

