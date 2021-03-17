//
//  AddViewController.swift
//  MapApp
//
//  Created by 桑原佑輔 on 2021/03/07.
//

import UIKit
import GoogleMaps
import GooglePlaces


class AddViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate{
    
    @IBOutlet weak var selectButton : UIButton!
    var cancelBarButtonItem : UIBarButtonItem!
    var sendBarButtonItem : UIBarButtonItem!
    var longitude : String = ""
    var latitude : String = ""
    var locationManager = CLLocationManager()
    lazy var mapView = GMSMapView()
    @IBOutlet weak var addMapView: UIView!
    
    
    @IBOutlet weak var storeName: UITextField!
    @IBOutlet weak var smokingSpace: UILabel!
    @IBOutlet weak var openHour: UITextField!
    @IBOutlet weak var closeHour: UITextField!
    @IBOutlet weak var tel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(longitude)
        print(latitude)
        
        //   地図の座標とズームレベルを受け取って地図を描画する

     
        
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(latitude) ?? 0, longitude: Double(longitude) ?? 0, zoom: 10.0)
        

        
        mapView = GMSMapView.map(withFrame: CGRect(origin: .zero, size: addMapView.bounds.size), camera: camera)
        
        //        ピンを立てる
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: Double(latitude) ?? 0, longitude:Double(longitude) ?? 0)
                marker.map = mapView
                mapView.delegate = self
        
        self.addMapView.addSubview(mapView)
        self.addMapView.sendSubviewToBack(mapView)
        self.addMapView.isUserInteractionEnabled = false
        
        
        cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(_:)))
        sendBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(saveBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = sendBarButtonItem
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        
        selectButton.layer.cornerRadius = 16.0
        
        print("add")
        
        // Do any additional setup after loading the view.
    }
    @objc func cancelButtonTapped(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func saveBarButtonTapped(_ sender:UIBarButtonItem){
        let mapModel:MapModel = MapModel()
        mapModel.storeName = self.storeName.text!
        mapModel.smokingSpace = self.smokingSpace.text!
        mapModel.openHour = self.openHour.text!
        mapModel.closeHour = self.closeHour.text!
        mapModel.tel = self.tel.text!
        
        
        
        //        必須項目のチェック
        //        OKだったら、保存
        //        NGだったら、保存せずアラートを出す
        
    }
    
    
    
    
}

