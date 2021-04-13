import UIKit //元から入っているフレームワーク（外枠的なやつ）
import Firebase
import GoogleMaps
import GooglePlaces
import FloatingPanel
import GoogleMapsUtils

//ViewControllerクラスはUIViewController・・・を継承している
//GPSの位置情報や電子コンパスの機能を使いたい場合はCLLocationManagerDelegate
class ViewController: UIViewController {
    
    var locationManager = CLLocationManager() //CLLocationManagerを定義
    var fpc = FloatingPanelController() //FlotingPanelを定義
    var mapView = GMSMapView() //lazyって何？？　インポートしたGooglemapsを定義してる
    var latitude: String? //緯度は”String型だと定義している”
    var longitude: String? //経度は”String型だと定義している”
    var zoomLevel: String?
    var spotModels: [MapModel] = []//MapModelが複数ある配列をspotModelsとして定義
    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var registerButton: UIButton!
    private var clusterManager: GMUClusterManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.titleLabel?.adjustsFontSizeToFitWidth = true
        mapView.delegate = self
        //初期値はApple本社
        let camera = GMSCameraPosition.camera(withLatitude: 37.3318, longitude: -122.0312, zoom: 20.0)
        mapView = GMSMapView.map(withFrame: CGRect(origin: .zero, size: view.bounds.size), camera: camera)
        mapView.settings.myLocationButton = true //右下のボタン追加する
        self.mapView.padding = UIEdgeInsets (top: 0, left: 0, bottom: 50, right: 30) //ボタンの位置は調整できないが内面の幅（padding）で調整ができる。
        mapView.isMyLocationEnabled = true
        
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                           renderer: renderer)
        
        // Register self to listen to GMSMapViewDelegate events.
        clusterManager.setMapDelegate(self)
        
        // User Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        getSpots()

        self.view.addSubview(mapView)
        self.view.sendSubviewToBack(mapView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !UserDefaults.standard.bool(forKey: "agreeBefore"){
            let vc = UINavigationController(rootViewController: AgreeViewController())
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true, completion: nil)
            
        }
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
        self.present(fpc, animated: true, completion: nil) //フローティングパネルで表示する
    }
    
    func getSpots(){
        Firestore.firestore().collection("map")
            
            .addSnapshotListener { querySnapshot, error in //変更があったらリアルタイムで更新する
                guard let snapshot = querySnapshot else { // querySnapshotがあったらsnapshotに代入する
                    print("Error fetching document: \(error!)")//なかったらエラー文出して処理を打ち切る
                    return
                }
                snapshot.documents.forEach{document in //受け取った全てのdocumetsに対してforEach構文を使う。そのうちの一つをdocumentとして定義する
                    let map = MapModel() //MapModelをインスタンス化。使える状態にする。たい焼きみたいなやつ（あくまでも型を作っている状態で下記に実際にデータをいれる）
                    map.storeName = document.data()["storeName"] as? String ?? ""
                    map.smokingSpace = document.data()["smokingSpace"] as? String ?? ""
                    map.openHour = document.data()["openHour"] as? String ?? ""
                    map.closeHour = document.data()["closeHour"] as? String ?? ""
                    map.tel = document.data()["tel"] as? String ?? ""
                    map.coordinate = document.data()["zahyo"] as? GeoPoint
                    self.spotModels.append(map)
                }
                print(self.spotModels)
                self.generateCluster(MapModels:self.spotModels)
            }
    }
    
    func generateCluster(MapModels:[MapModel]){
        MapModels.forEach { (Mapmodel) in
            let item = POIItem(position: CLLocationCoordinate2DMake(Mapmodel.coordinate?.latitude ?? 0, Mapmodel.coordinate?.longitude ?? 0), storeName: Mapmodel.storeName, smokingSpace: Mapmodel.smokingSpace, openHour: Mapmodel.openHour, closeHour: Mapmodel.closeHour, tel: Mapmodel.tel)
            clusterManager.add(item)
            print(item.position)
        }
        clusterManager.cluster()
    }
    

    func getCenterPoint() -> CLLocationCoordinate2D {
        return mapView.projection.coordinate(for: mapView.center)
    }
}
extension ViewController: GMSMapViewDelegate {}
extension ViewController: CLLocationManagerDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("idle")
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        //  タップしたマーカーかクラスターの位置までマップの中心に移動させる
        mapView.animate(toLocation: marker.position)
        // check if a cluster icon was tapped　タップしたのがクラスターだったら
        if marker.userData is GMUCluster {
            // zoom in on tapped cluster　カメラをズームさせる
            mapView.animate(toZoom: mapView.camera.zoom + 5)
            return true
        }
        self.pinImage.isHidden = true
        let contentVC = DetailModalViewController() //TopHalfModalViewControllerへ遷移
        contentVC.vc = self //これは何？
        fpc.set(contentViewController: contentVC) //fpcをセットする？（contentViewControllerはcontentVCを使用する）
        fpc.layout = DetailFloatingPanelLayout() //fpcのレイアウトはMyFloatingPanelLayoutを使う
        fpc.isRemovalInteractionEnabled = true //
        self.dismiss(animated: true, completion: nil)
        self.present(fpc, animated: true, completion: nil) //フローティングパネルで表示する
        return false
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 17.0)
        self.mapView.animate(to: camera)
        locationManager.stopUpdatingLocation()
    }
}

//フローティングパネルのレイアウト
class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [.tip: FloatingPanelLayoutAnchor(fractionalInset: 0.2, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}

class DetailFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [.tip: FloatingPanelLayoutAnchor(fractionalInset: 0.3, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}



