//
//  DetailModalViewController.swift
//  MapApp
//
//  Created by 長谷侑弥 on 2021/04/07.
//

import UIKit
import FloatingPanel
import GoogleMapsUtils
import GoogleMobileAds

class DetailModalViewController: UIViewController {
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var businessHour: UILabel!
    @IBOutlet weak var tel: UILabel!
    var bannerView: GADBannerView!
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let contentVC = EditViewController()
        contentVC.POItem = POItem
        let navi = UINavigationController(rootViewController: contentVC)
        navi.modalPresentationStyle = .overCurrentContext
        self.present( navi, animated: true, completion: nil)
        
    }
    
    var POItem : POIItem = POIItem(position:CLLocationCoordinate2DMake(0,0), storeName: "", smokingSpace: "", openHour: "", closeHour: "", tel:"", id: "")
    
    
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
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
   
}
