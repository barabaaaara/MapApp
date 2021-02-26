//
//  ViewController.swift
//  MapApp
//
//  Created by 桑原佑輔 on 2021/02/21.
//

import UIKit
import Firebase
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var textFiled: UITextField!
    var locationManager = CLLocationManager()
    lazy var mapView = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初期値はApple本社
        let camera = GMSCameraPosition.camera(withLatitude: 37.3318, longitude: -122.0312, zoom: 20.0)
        mapView = GMSMapView.map(withFrame: CGRect(origin: .zero, size: view.bounds.size), camera: camera)
        mapView.settings.myLocationButton = true //右下のボタン追加する
        mapView.isMyLocationEnabled = true

        // User Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        self.view.addSubview(mapView)
        self.view.bringSubviewToFront(mapView)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.latitude, zoom: 17.0)
        self.mapView.animate(to: camera)
        
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func save(_ sender: Any) {
        let db = Firestore.firestore()
        
        db.collection("map").document("79qzrWdUkhvI84Nd8BfQ").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        
    }
    
}


