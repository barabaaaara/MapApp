//
//  DetailModalViewController.swift
//  MapApp
//
//  Created by 長谷侑弥 on 2021/04/07.
//

import UIKit
import FloatingPanel
import GoogleMapsUtils

class DetailModalViewController: UIViewController {
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var businessHour: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var kokoku: UIView!
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let contentVC = EditViewController()
        contentVC.POItem = POItem
        let navi = UINavigationController(rootViewController: contentVC)
        navi.modalPresentationStyle = .overCurrentContext
        self.present( navi, animated: true, completion: nil)
        
    }
    
    var POItem : POIItem = POIItem(position:CLLocationCoordinate2DMake(0,0), storeName: "", smokingSpace: "", openHour: "", closeHour: "", tel:"")
    
    
    var fpc = FloatingPanelController() //フローティングパネルのフレームワークの定義
    var vc: ViewController = ViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        editButton.layer.cornerRadius = 16.0
        // Do any additional setup after loading the view.
        self .storeName.text = POItem.storeName
        self.tel.text = POItem.tel
        self.businessHour.text = POItem.openHour + "~" + POItem.closeHour
        print(POItem)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
