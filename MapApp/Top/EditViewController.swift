//
//  EditViewController.swift
//  MapApp
//
//  Created by 桑原佑輔 on 2021/04/24.
//

import UIKit
import GoogleMapsUtils
import Firebase
import GoogleMaps
import GooglePlaces


class EditViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var editMapView: UIView!
    lazy var mapView = GMSMapView()
    var longitude : String = ""
    var latitude : String = ""
    var locationManager = CLLocationManager()
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var storeName: UITextField!
    @IBOutlet weak var smokingCafe: UITextField!
    @IBOutlet weak var openHour: UITextField!
    @IBOutlet weak var closeHour: UITextField!
    @IBOutlet weak var tel: UITextField!
    var cancelBarButtonItem : UIBarButtonItem!
    var sendBarButtonItem : UIBarButtonItem!
    var POItem : POIItem = POIItem(position:CLLocationCoordinate2DMake(0,0), storeName: "", smokingSpace: "", openHour: "", closeHour: "", tel:"", id: "")
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        //アラート生成
        //UIAlertControllerのスタイルがalert
        let alert: UIAlertController = UIAlertController(title: "この場所を削除しますか？", message:  "削除したデータは元には戻りません", preferredStyle:  UIAlertController.Style.alert)
        // 確定ボタンの処理
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // キャンセルボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            print("キャンセル")
        })
        let confirmAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertAction.Style.destructive, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            Firestore.firestore().collection("map").document(self.POItem.id).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    self.dismiss(animated: true, completion: nil)
                }
            }
            print("確定")
        })
        
        //UIAlertControllerにキャンセルボタンと確定ボタンをActionを追加
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        //実際にAlertを表示する
        present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(POItem.position.latitude) , longitude: Double(POItem.position.longitude) , zoom: 10.0)
        
        mapView = GMSMapView.map(withFrame: CGRect(origin: .zero, size: editMapView.bounds.size), camera: camera)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: Double(POItem.position.latitude) , longitude:Double(POItem.position.longitude) )
        marker.map = mapView
        mapView.delegate = self
        
        self.editMapView.addSubview(mapView)
        self.editMapView.sendSubviewToBack(mapView)
        self.editMapView.isUserInteractionEnabled = false
        
        
        deleteButton.layer.cornerRadius = 16.0
        deleteButton.layer.borderWidth = 1
        deleteButton.layer.borderColor = UIColor.systemRed.cgColor
        
        self .storeName.text = POItem.storeName //編集画面にデータベース内にあるピンのデータを表示する
        self.smokingCafe.text = POItem.smokingSpace
        self.openHour.text = POItem.openHour
        self.closeHour.text = POItem.closeHour
        self.tel.text = POItem.tel
        
        cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(_:)))
        sendBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(saveBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = sendBarButtonItem
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        
    }
    @objc func cancelButtonTapped(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func saveBarButtonTapped(_ sender:UIBarButtonItem){
        let mapModel:MapModel = MapModel()
        mapModel.storeName = self.storeName.text!
        mapModel.smokingSpace = self.smokingCafe.text!
        mapModel.openHour = self.openHour.text!
        mapModel.closeHour = self.closeHour.text!
        mapModel.tel = self.tel.text!
        //
        //
        if storeName.text?.count ==  0{
            alert(message: "店名が未入力です")
            return
        }
        //
        Firestore.firestore().collection("map").document(POItem.id).updateData([
            "storeName": mapModel.storeName,
            "smokingSpace": mapModel.smokingSpace,
            "openHour": mapModel.openHour,
            "closeHour": mapModel.closeHour,
            "tel": mapModel.tel,
            
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
    // Do any additional setup after loading the view.
}



