import UIKit //元から入っているフレームワーク（外枠的なやつ）
import Firebase
import GoogleMaps
import GooglePlaces
import FloatingPanel

//ViewControllerクラスはUIViewController・・・を継承している
//GPSの位置情報や電子コンパスの機能を使いたい場合はCLLocationManagerDelegate
class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var locationManager = CLLocationManager() //CLLocationManagerを定義
    var fpc = FloatingPanelController() //FlotingPanelを定義
    lazy var mapView = GMSMapView() //lazyって何？？　インポートしたGooglemapsを定義してる
    var latitude: String? //緯度は”String型だと定義している”
    var longitude: String? //経度は”String型だと定義している”
    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        let contentVC = TopHalfModalViewController() //TopHalfModalViewControllerへ遷移
        contentVC.vc = self //これは何？
        fpc.set(contentViewController: contentVC) //fpcをセットする？（contentViewControllerはcontentVCを使用する）
        fpc.layout = MyFloatingPanelLayout() //fpcのレイアウトはMyFloatingPanelLayoutを使う
        fpc.isRemovalInteractionEnabled = true //
        pinImage.isHidden = false //タップされたらpinの非表示を解除する
        self.present(fpc, animated: true, completion: nil) //
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let picture = UIImage(named: "plus") //"Plusという画像を使用する"
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
        print(getCenterPoint())
        
    }
    
    
    
    func getCenterPoint() -> CLLocationCoordinate2D {
        return mapView.projection.coordinate(for: mapView.center)
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

//フローティングパネルのレイアウト
class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [.tip: FloatingPanelLayoutAnchor(absoluteInset: 90.0, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}



