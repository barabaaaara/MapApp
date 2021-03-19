//
//  TopHalfModalViewController.swift
//  MapApp
//
//  Created by 桑原佑輔 on 2021/02/27.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FloatingPanel

class TopHalfModalViewController: UIViewController{

    @IBOutlet weak var backButton: UIButton! //戻るボタンとの紐付け
    @IBOutlet weak var decideBotton: UIButton! //決定ボタンとの紐付け
    var fpc = FloatingPanelController() //フローティングパネルのフレームワークの定義
    var vc: ViewController = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.layer.cornerRadius = 16.0
        decideBotton.layer.cornerRadius = 16.0
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
//    戻るボタンを押したらモーダル遷移で戻る
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
//   決定ボタンを押したら、その地点での緯度と経度をViewControllerからaddViewControllerに渡す
    @IBAction func decideButtonTapped(_ sender: Any) {
        let contentVC = AddViewController() //addViewContorollerに遷移
        contentVC.longitude = vc.getCenterPoint().longitude.description
        contentVC.latitude = vc.getCenterPoint().latitude.description
        let navi = UINavigationController(rootViewController: contentVC)
        navi.modalPresentationStyle = .overCurrentContext
        self.present(navi, animated: true, completion: nil)
    }

    


}

//class AddFloatingPanelLayout: FloatingPanelLayout {
//    let position: FloatingPanelPosition = .bottom
//    let initialState: FloatingPanelState = .tip
//    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
//        return [
//            .tip: FloatingPanelLayoutAnchor(absoluteInset: 400.0, edge: .bottom, referenceGuide: .safeArea),
//        ]
//    }
//}
