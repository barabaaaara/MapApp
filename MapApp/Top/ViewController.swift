//
//  ViewController.swift
//  MapApp
//
//  Created by 桑原佑輔 on 2021/02/21.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import FloatingPanel

class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var locationManager = CLLocationManager()
    lazy var mapView = GMSMapView()
    @IBOutlet weak var pinImage: UIImageView!
    var fpc = FloatingPanelController()
    @IBOutlet weak var registerButton: UIButton!
    @IBAction func mapTapped(_ sender: UILongPressGestureRecognizer) {
    }
    @IBAction func registerButtonTapped(_ sender: Any) {
        let contentVC = TopHalfModalViewController()
        fpc.set(contentViewController: contentVC)
        fpc.layout = MyFloatingPanelLayout()
        fpc.isRemovalInteractionEnabled = true
        pinImage.isHidden = false
        
        self.present(fpc, animated: true, completion: nil)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let picture = UIImage(named: "plus")
        self.registerButton.setImage(picture, for:.normal)
        registerButton.layer.cornerRadius = 20.0
        registerButton.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        registerButton.layer.shadowColor = UIColor.black.cgColor
        registerButton.layer.shadowOpacity = 0.3
        registerButton.layer.shadowRadius = 12
        
        pinImage.isHidden = true
        
    }
    
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
        self.view.sendSubviewToBack(mapView)
        //        self.view.bringSubviewToFront(mapView)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.latitude, zoom: 17.0)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        
        self.mapView.animate(to: camera)
        
        
        
        
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return newImage
        }
        
        
        locationManager.stopUpdatingLocation()
    }
    
    //    @IBAction func save(_ sender: Any) {
    //        let db = Firestore.firestore()
    //
    //        db.collection("map").document("79qzrWdUkhvI84Nd8BfQ").delete() { err in
    //            if let err = err {
    //                print("Error removing document: \(err)")
    //            } else {
    //                print("Document successfully removed!")
    //            }
    //        }
    //
    //
    //    }
    
}

class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 90.0, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}



