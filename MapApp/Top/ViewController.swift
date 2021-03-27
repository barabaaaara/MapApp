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
    var zoomLevel: String?
    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
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
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(34.994742, 135.766125)
        marker.title = "Me"
        marker.map = mapView
        
        let docRef = Firestore.firestore().collection("map")
        
        Firestore.firestore().collection("map").getDocuments { (snaps, error) in
        }
        docRef.getDocuments{ (document, error) in
            if let error = error{
                print(error)
            }
            guard let document = document else { return }
            for document in document.documents {
                let map = MapModel()
                let zahyo = CLLocationCoordinate2D.init(latitude: 34.994742, longitude: 135.766125)
                //                self.putMarker(title: "テスト", coordinate: zahyo, iconName: "テスト２")
                //                guard case map.coordinate = document.data()["zahyo"] as? GeoPoint else {
                //                    print("failzahyo"); return  }
                
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if !UserDefaults.standard.bool(forKey: "agreeBefore"){
        let vc = UINavigationController(rootViewController: AgreeViewController())
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true, completion: nil)
            
//        }
    }
        

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let picture = UIImage(named: "plus") //"Plusという画像を使用する"
        self.registerButton.setImage(picture, for:.normal)
        registerButton.layer.cornerRadius = 20.0 //ボタンの角を丸くする（幅の半分ぐらいが良い）
        registerButton.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        registerButton.layer.shadowColor = UIColor.black.cgColor
        registerButton.layer.shadowOpacity = 0.3
        registerButton.layer.shadowRadius = 12
        
        pinImage.isHidden = true
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        let contentVC = TopHalfModalViewController() //TopHalfModalViewControllerへ遷移
        contentVC.vc = self //これは何？
        fpc.set(contentViewController: contentVC) //fpcをセットする？（contentViewControllerはcontentVCを使用する）
        fpc.layout = MyFloatingPanelLayout() //fpcのレイアウトはMyFloatingPanelLayoutを使う
        fpc.isRemovalInteractionEnabled = true //
        pinImage.isHidden = false //タップされたらpinの非表示を解除する
        self.present(fpc, animated: true, completion: nil) //
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
    
    //    起動したら現在地を取得し、表示する（アプリ起動時に現在地が表示される）
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 17.0)
        self.mapView.animate(to: camera)
        
        locationManager.stopUpdatingLocation()
    }

    func getCenterPoint() -> CLLocationCoordinate2D {
        return mapView.projection.coordinate(for: mapView.center)
    }
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



