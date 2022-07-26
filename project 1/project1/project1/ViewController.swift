import UIKit
import MapKit
import Toast

class ViewController: UIViewController {

    var MapAPIData : MapAPI?
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var recordButton: UIButton!
    
    @IBOutlet var MapView: MKMapView!
    @IBOutlet var bartext: UINavigationItem!
    
    static var location:CLLocationManager? = nil
            
    var resetBool: Bool = true
    
    var registerSearch: String = ""
        
    var saveDataLat: [Double] = []
    var saveDataLng: [Double] = []
    var saveDataName: [String] = []
    var saveDataVic: [String] = []
    
    var recordDataLat: [Double] = []
    var recordDataLng: [Double] = []
    var recordDataName: [String] = []
    var recordDataVic: [String] = []
        
    var infoPho: String = ""
    var infoStar: Int = 0
    var infoLand: [String] = []
            
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if ViewController.location == nil {
            ViewController.location = CLLocationManager()
            ViewController.location?.requestWhenInUseAuthorization()
            ViewController.location?.startUpdatingLocation()
        }
        getDataFromAPI()
    }
        
    func resetData() {
        saveDataLat = []
        saveDataLng = []
        saveDataName = []
        saveDataVic = []
    }
    
    func transRecord(index: Int, str: String) {
        
        if recordDataName.isEmpty {
            self.recordDataLat.append(saveDataLat[index])
            self.recordDataLng.append(saveDataLng[index])
            self.recordDataName.append(saveDataName[index])
            self.recordDataVic.append(saveDataVic[index])
        } else {
            if !recordDataName.contains(str) {
                self.recordDataLat.append(saveDataLat[index])
                self.recordDataLng.append(saveDataLng[index])
                self.recordDataName.append(saveDataName[index])
                self.recordDataVic.append(saveDataVic[index])
            }
        }
    }
    
    func clearRecord() {
        recordDataLat = []
        recordDataLng = []
        recordDataName = []
        recordDataVic = []
    }
        
    private func getDataFromAPI() {
        if let url: URL = URL(string: "https://android-quiz-29a4c.web.app/") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request){ data, response, error in
                if let error = error {
                    print("\nAPI未成功上傳, 原因是：\(error.localizedDescription)\n")
                    return
                } else if let data = data {
                    print("\n成功接收API資料\n")
                    
                    DispatchQueue.main.async {
                        do {
                            self.MapAPIData = try JSONDecoder().decode(MapAPI.self, from: data)
                            self.MapView.reloadInputViews()
                            
                            self.setAnnotation()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    private func setAnnotation() {
        MapAPIData?.results.content.forEach { content in
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = CLLocationCoordinate2DMake(content.lat, content.lng)
                
            annotation.title = String(format: "%@", content.name)
            annotation.subtitle = String(format: "%@", content.vicinity)

            MapView.addAnnotation(annotation)
        }
    }
    
    private func clickAnnotation(strName: String, strVic: String, douLat: Double, douLng: Double) {
        MapAPIData?.results.content.forEach { content in
            if content.name.contains(strName){
                infoPho = content.photo
                infoStar = content.star
                infoLand = content.landscape
            }
        }
        let VC = AnnotationClickVC(name: strName, vic: strVic, lat: douLat, lng: douLng)
        VC.delegate = self as AnnotationClickVCDelegate
        VC.showOn(VC: self)
    }
    
    private func HotelInfo(name: String, vic: String) {
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(identifier: "HotelInfomation") as! HotelInfomationVC
        
        VC.name = name
        VC.vic = vic
        VC.photo = infoPho
        VC.star = infoStar
        VC.landscope = infoLand
        
        navigationController?.pushViewController(VC, animated: true)
    }
    
    private func GPSLocation(douLat: Double, douLng: Double) {
        // 終點座標
        let latLng = CLLocationCoordinate2DMake(douLat, douLng)
        let targetCoordinate = latLng
        
        // 初始化 MKPlacemark
        let targetPlacemark = MKPlacemark(coordinate: targetCoordinate)
        
        // 透過 targetPlacemark 初始化一個 MKMapItem
        let targetItem = MKMapItem(placemark: targetPlacemark)
        
        // 使用當前使用者當前座標初始化 MKMapItem
        let userMapItem = MKMapItem.forCurrentLocation()
        
        // 建立導航路線的起點及終點 MKMapItem
        let routes = [userMapItem,targetItem]
        
        // 我們可以透過 launchOptions 選擇我們的導航模式，例如：開車、走路等等...
        MKMapItem.openMaps(with: routes, launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving])
    }
        
    @IBAction func MapSearch(_ sender: Any) {
        resetData()
        let searchName = searchBar.text ?? ""
        
        if searchName.isEmpty  {
            view.makeToast("請輸入資料")
        } else {
            MapAPIData?.results.content.forEach { content in
    
                if content.name.contains(searchName) || content.vicinity.contains(searchName) {
                    saveDataLat.append(content.lat)
                    saveDataLng.append(content.lng)
                    
                    saveDataName.append(content.name)
                    saveDataVic.append(content.vicinity)
                }
            }
            if !saveDataName.isEmpty {
                let VC = MapSearchVC(name: saveDataName, vic: saveDataVic, lat: saveDataLat, lng: saveDataLng)
                VC.delegate = self as MapSearchVCDelegate
                
                VC.showOn(VC: self)
            } else {
                view.makeToast("查詢錯誤")
            }
        }
    }
    
    @IBAction func MapSearchRecord(_ sender: Any) {
        if recordDataName.isEmpty  {
            view.makeToast("無搜尋紀錄")
        } else {
            let VC = MapSearchRecordVC(name: recordDataName, vic: recordDataVic, lat: recordDataLat, lng: recordDataLng)
            VC.delegate = self as MapSearchRecordVCDelegate
            VC.showOn(VC: self)
        }
    }
    
    @IBAction func ResetData(_ sender: Any) {
        if resetBool == true {
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let center = MapView.userLocation.coordinate
            let region = MKCoordinateRegion(center: center, span: span)
            MapView.setRegion(region, animated: true)
            resetBool = false
        } else {
            MapView.showAnnotations(MapView.annotations, animated: true)
            resetBool = true
        }
}
}

extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let strName = ((view.annotation?.title) ?? "") ?? ""
        let strVic = ((view.annotation?.subtitle) ?? "") ?? ""
        let douLat = view.annotation?.coordinate.latitude ?? 0.0
        let douLng = view.annotation?.coordinate.longitude ?? 0.0
        clickAnnotation(strName: strName, strVic: strVic, douLat: douLat, douLng: douLng)
    }
}

extension ViewController: MapSearchVCDelegate {
    func setMapRegion(index: Int, lat: CLLocationDegrees, lng: CLLocationDegrees) {
        registerSearch = saveDataName[index]
        transRecord(index: index, str: registerSearch)
        
        let latLng = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MapView.regionThatFits(MKCoordinateRegion(center: latLng, span: span))
        
        self.MapView.setRegion(region, animated: true)
    }
}

extension ViewController: MapSearchRecordVCDelegate {
    func recordDidClear() {
        self.clearRecord()
        self.view.endEditing(true)
        self.view.makeToast("已清除記錄")
    }
        
    func setMapRegion(lat: CLLocationDegrees, lng: CLLocationDegrees) {
        
        let latLng = CLLocationCoordinate2DMake(lat, lng)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: latLng, span: span)
        self.MapView.setRegion(region, animated: true)
    }
}

extension ViewController: AnnotationClickVCDelegate {
    func transtoInfo(name: String, vic: String) {
        HotelInfo(name: name, vic: vic)
    }
    func transtoGPS(lat: Double, lng: Double) {
        GPSLocation(douLat: lat, douLng: lng)
    }
}
