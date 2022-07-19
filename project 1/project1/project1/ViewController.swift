import UIKit
import MapKit
import Toast

class ViewController: UIViewController {

    var MapAPIData : MapAPI?
    
    @IBOutlet var infoButton: UIBarButtonItem!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var locationButton: UIButton!
    
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var recordButton: UIButton!
    
    @IBOutlet var MapView: MKMapView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var bartext: UINavigationItem!
    
    static var location:CLLocationManager? = nil
    
    var regLat: Double = 0.0
    var regLng: Double = 0.0
    var regName: String = ""
    var regVic: String = ""
    var regPho: String = ""
    var regStar: Int = 0
    var regLand: [String] = []
    
    var selectNum: Int = 0
    
    var recordNum: Int = 0
    
    var saveDataLat: [Double] = []
    var saveDataLng: [Double] = []
    var saveDataName: [String] = []
    var saveDataVic: [String] = []
    
    var recordDataLat: [Double] = []
    var recordDataLng: [Double] = []
    var recordDataName: [String] = []
    var recordDataVic: [String] = []
        
    var infoName: String = ""
    var infoVic: String = ""
    var infoPho: String = ""
    var infoStar: Int = 0
    var infoLand: [String] = []
        
    var annBool: Bool = false
    var resetDataBool: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.isHidden = true
        
        infoButton.isEnabled = false
        
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
    
    func transRecord(name: Int, str: String) {
        if recordDataName.isEmpty {
            self.recordDataLat.append(saveDataLat[name])
            self.recordDataLng.append(saveDataLng[name])
            self.recordDataName.append(saveDataName[name])
            self.recordDataVic.append(saveDataVic[name])
            
            recordNum += 1
        } else {
            if recordDataName.contains(str) {
            } else {
                self.recordDataLat.append(saveDataLat[name])
                self.recordDataLng.append(saveDataLng[name])
                self.recordDataName.append(saveDataName[name])
                self.recordDataVic.append(saveDataVic[name])
        
                recordNum += 1
            }
        }
    }
    
    func clearRecord() {
        recordDataLat = []
        recordDataLng = []
        recordDataName = []
        recordDataVic = []
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInfoPage" {
            let VC = segue.destination as! HotelInfomationVC
            
            VC.name = infoName
            VC.vic = infoVic
            VC.pho = infoPho
            VC.star = infoStar
            VC.landscope = infoLand
            
        }
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
                            
                            self.signData()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    private func signData() {
        MapAPIData?.results.content.forEach { content in
            regLat = content.lat
            regLng = content.lng
            regName = content.name
            regVic = content.vicinity

            
            self.addAnnotation()
        }
    }

    private func addAnnotation() {
        let annotation = MKPointAnnotation()

        let latLng = CLLocationCoordinate2DMake(regLat, regLng)
        
        annotation.coordinate = latLng
            
        annotation.title = String(format: "%@", regName)
        annotation.subtitle = String(format: "%@", regVic)

        MapView.addAnnotation(annotation)
    }
    
    private func clickAnnotation(strName: String, strVic: String, douLat: Double, douLng: Double) {
        if annBool == false {
            showOneAnn(strName: strName, strVic: strVic, douLat: douLat, douLng: douLng)
            
            MapAPIData?.results.content.forEach { content in
                regName = content.name
                regPho = content.photo
                regStar = content.star
                regLand = content.landscape
                
                if regName.contains(strName){
                    infoPho = regPho
                    infoStar = regStar
                    infoLand = regLand
                }
            }
            
            let VC = AnnotationClickVC()
            VC.name = strName
            VC.vic = strVic
                   
            self.searchButton.isHidden = true
            self.recordButton.isHidden = true
            self.locationButton.isHidden = true
            self.backButton.isHidden = false
            
            VC.selectInfo = {(name:String)->() in
                self.infoButton.isEnabled = true
                self.infoButton.title = "詳細資料"
                
                self.bartext.title = name
            
                self.infoName = strName
                self.infoVic = strVic
                
                self.annBool = true
            }
            
            VC.selectGPS = {(name:String)->() in
                self.bartext.title = name
                self.GPSLocation(douLat: douLat, douLng: douLng)
            }

            VC.showOn(VC: self)
        }
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
        
        annBool = true
    }
    
    private func showOneAnn(strName: String, strVic: String, douLat: Double, douLng: Double) {
        MapView.removeAnnotations(MapView.annotations)
        
        let annotation = MKPointAnnotation()
        let latLng = CLLocationCoordinate2DMake(douLat, douLng)
        annotation.coordinate = latLng
        annotation.title = String(format: "%@", strName)
        annotation.subtitle = String(format: "%@", strVic)
        MapView.addAnnotation(annotation)
    }
    
    @IBAction func BackButton(_ sender: Any) {
        MapView.removeOverlays(MapView.overlays)
        self.getDataFromAPI()
        
        bartext.title = "景點搜尋"
        
        infoButton.isEnabled = false
        self.infoButton.title = ""
        
        searchButton.isHidden = false
        recordButton.isHidden = false
        locationButton.isHidden = false
        backButton.isHidden = true
                        
        annBool = false
    }
        
    @IBAction func MapSearch(_ sender: Any) {
        let searchName = textField.text ?? ""
        resetData()
        
        if searchName.isEmpty  {
            view.makeToast("請輸入資料")
        } else {
        MapAPIData?.results.content.forEach { content in
            regLat = content.lat
            regLng = content.lng
            
            regName = content.name
            regVic = content.vicinity
            
            if regName.contains(searchName) || regVic.contains(searchName) {
                
                selectNum += 1
                
                saveDataLat.append(regLat)
                saveDataLng.append(regLng)
                
                saveDataName.append(regName)
                saveDataVic.append(regVic)
            }
        }
//        let VC = MapSearchVC(name: saveDataName, vic: saveDataVic, dataCount: selectNum)
        
        let VC = MapSearchVC()
        VC.name = saveDataName
        VC.vic = saveDataVic
        VC.dataCount = selectNum

        VC.showOn(VC: self)

        VC.selectHandler = {(name:Int)->() in
            if self.saveDataName.isEmpty {
                self.view.makeToast("查無結果")
            } else {
                let latLng = CLLocationCoordinate2DMake(self.saveDataLat[name], self.saveDataLng[name])
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: latLng, span: span)
                self.MapView.setRegion(region, animated: true)

                self.transRecord(name: name , str: self.saveDataName[name])
            }
        }
    }
    }
    
    @IBAction func MapSerachRecord(_ sender: Any) {
        if recordDataName.isEmpty {
            view.makeToast("無歷史記錄")
        } else {
//            let VC = MapSearchVC(name: recordDataName, vic: recordDataVic, dataCount: recordNum)
            
            let VC = MapSearchRecordVC()
            VC.name = recordDataName
            VC.vic = recordDataVic
            VC.dataCount = recordNum
            
            VC.showOn(VC: self)
            
            VC.selectHandler = {(name:Int)->() in
                let latLng = CLLocationCoordinate2DMake(self.recordDataLat[name], self.recordDataLng[name])
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: latLng, span: span)
                self.MapView.setRegion(region, animated: true)
            }
            
            VC.clearClick = {(clear:Bool)->() in
                self.clearRecord()

                self.view.makeToast("已清除記錄")
            }
        }
    }
    
    @IBAction func ResetData(_ sender: Any) {
        if resetDataBool == false {
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let center = MapView.userLocation.coordinate
            let region = MKCoordinateRegion(center: center, span: span)
            MapView.setRegion(region, animated: true)
            resetDataBool = true
        } else {
            MapView.showAnnotations(MapView.annotations, animated: true)
            resetDataBool = false
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
