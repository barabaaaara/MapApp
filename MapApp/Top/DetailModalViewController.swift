//
//  DetailModalViewController.swift
//  MapApp
//
//  Created by 長谷侑弥 on 2021/04/07.
//

import UIKit
import FloatingPanel

class DetailModalViewController: UIViewController {
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var businessHour: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var kokoku: UIView!
    
    var fpc = FloatingPanelController() //フローティングパネルのフレームワークの定義
    var vc: ViewController = ViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        editButton.layer.cornerRadius = 16.0
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

}
