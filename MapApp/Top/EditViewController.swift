//
//  EditViewController.swift
//  MapApp
//
//  Created by 桑原佑輔 on 2021/04/24.
//

import UIKit
import GoogleMapsUtils
import Firebase


class EditViewController: UIViewController {
    
    @IBOutlet weak var deleteButton: UIButton!
    var cancelBarButtonItem : UIBarButtonItem!
    var sendBarButtonItem : UIBarButtonItem!
    var POItem : POIItem = POIItem(position:CLLocationCoordinate2DMake(0,0), storeName: "", smokingSpace: "", openHour: "", closeHour: "", tel:"", id: "")
    
    @IBOutlet weak var storeName: UITextField!
    @IBAction func deleteButtonTapped(_ sender: Any) {
        Firestore.firestore().collection("map").document(POItem.id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteButton.layer.cornerRadius = 16.0
        deleteButton.layer.borderWidth = 1
        deleteButton.layer.borderColor = UIColor.systemRed.cgColor
        
        self .storeName.text = POItem.storeName
        
        cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(_:)))
        sendBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(saveBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = sendBarButtonItem
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        
        //        selectButton.layer.cornerRadius = 16.0
        
        print("add")
        print(POItem.storeName)
        print(Double(POItem.position.latitude))
        
        // Do any additional setup after loading the view.
    }
    @objc func cancelButtonTapped(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func saveBarButtonTapped(_ sender:UIBarButtonItem){
        let mapModel:MapModel = MapModel()
        mapModel.storeName = self.storeName.text!
//                mapModel.smokingSpace = self.smokingSpace.text!
//                mapModel.openHour = self.openHour.text!
//                mapModel.closeHour = self.closeHour.text!
//                mapModel.tel = self.tel.text!
//
//
//                if storeName.text?.count ==  0{
//                    alert(message: "店名が未入力です")
//                    return
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
    
    
    // Do any additional setup after loading the view.
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


