//
//  AddViewController.swift
//  MapApp
//
//  Created by 桑原佑輔 on 2021/03/07.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import FloatingPanel

class AddViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate{
    
    var fpc = FloatingPanelController() //FlotingPanelを定義
    
    @IBAction func selectButtonTapped(_ sender: Any) {
        let contentVC = SmokingAreaViewController() //TopHalfModalViewControllerへ遷移
        fpc.set(contentViewController: contentVC) //fpcをセットする？（contentViewControllerはcontentVCを使用する）
        fpc.layout = MyFloatingPanelLayout() //fpcのレイアウトはMyFloatingPanelLayoutを使う
        fpc.isRemovalInteractionEnabled = true //
        self.present(fpc, animated: true, completion: nil) //フローティングパネルで表示する
        
    }
    @IBOutlet weak var selectButton : UIButton!
    var cancelBarButtonItem : UIBarButtonItem!
    var sendBarButtonItem : UIBarButtonItem!
    var longitude : String = ""
    var latitude : String = ""
    var zoom :Float = 20.0
    
    var locationManager = CLLocationManager()
    lazy var mapView = GMSMapView()
    @IBOutlet weak var addMapView: UIView!
    @IBOutlet weak var storeName: UITextField!
    @IBOutlet weak var smokingSpace: UILabel!
    @IBOutlet weak var openHour: UITextField!
    @IBOutlet weak var closeHour: UITextField!
    @IBOutlet weak var tel: UITextField!
    let smokingAreaLabelArray = ["全面喫煙可能店","居酒屋・レストラン・カフェ等","バー・スナック・シガーバー等","喫煙専用室設置店"]
    let smokingAreaDescriptionArray = ["喫煙専用室","喫煙可能店","喫煙目的店","喫煙専用室"]
    let smokingAreaImageArray = ["喫煙専用室","喫煙可能店","喫煙目的店","喫煙専用室"]
    
    @IBOutlet weak var smokingAreaImage: UIImageView!
    @IBOutlet weak var smokingAreaLabel: UILabel!
    @IBOutlet weak var smokingAreaDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(longitude)
        print(latitude)
        
        
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(latitude) ?? 0, longitude: Double(longitude) ?? 0, zoom: zoom)
        
        
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
        
        
        if storeName.text?.count ==  0{
            alert(message: "店名が未入力です")
            return
            
        }
        
//        if smokingSpace.text ==  "選択されていません"{
//            alert(message: "カテゴリーが選択されていません")
//            return
//            
//        }
    
        
        Firestore.firestore().collection("map").document().setData([
            "storeName": mapModel.storeName,
            "smokingSpace": mapModel.smokingSpace,
            "openHour": mapModel.openHour,
            "closeHour": mapModel.closeHour,
            "tel": mapModel.tel,
            "zahyo": GeoPoint(latitude:Double(latitude) ?? 0, longitude: Double(longitude) ?? 0)
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    
 
    
    func alert (message: String){
        let dialog = UIAlertController(title: "タイトル", message:message, preferredStyle: .alert)
        //ボタンのタイトル
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //実際に表示させる
        self.present(dialog, animated: true, completion: nil)
    }
    
    
    
}

