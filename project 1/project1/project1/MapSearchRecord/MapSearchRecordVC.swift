import UIKit
import CoreLocation

protocol MapSearchRecordVCDelegate: AnyObject {
    func setMapRegion(lat: CLLocationDegrees, lng: CLLocationDegrees)
    func recordDidClear()
}

class MapSearchRecordVC: UIViewController {

    @IBOutlet var popupView: UIView!
    @IBOutlet var tableView: UITableView!
    
    weak var delegate: MapSearchRecordVCDelegate?
    
    private var name: [String] = []
    private var vic: [String] = []
    private var lat: [Double] = []
    private var lng: [Double] = []
    
    convenience init(name: [String] = [], vic: [String] = [], lat: [Double] = [], lng: [Double] = []) {
        self.init()
        self.name = name
        self.vic = vic
        self.lat = lat
        self.lng = lng
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        componentsInit()
    }
    
    private func componentsInit() {
                
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
    }
    
    func showOn(VC: UIViewController) {
        self.modalPresentationStyle = .overFullScreen
        let transition = CATransition()
        transition.duration = 0.1
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.window?.layer.add(transition, forKey: kCATransition)
        VC.present(self, animated: false) {
            self.popupView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.popupView.alpha = 0
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0.0, animations: {
                self.popupView.alpha = 1
                self.popupView.transform = CGAffineTransform.identity
            })
        }
    }

    private func dismissPopupView() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromTop
        
        view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func dismissView(){
        dismissPopupView()
    }
        
    @IBAction func clearData(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "cell")
        tableView.reloadData()
        dismissPopupView()
        delegate?.recordDidClear()
    }
        
}

extension MapSearchRecordVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        let reversename: [String] = name.reversed()
        let reversevic: [String] = vic.reversed()
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            //設定主標題為name，字體顏色為黑(black)，字體大小為17.0
            content.attributedText = NSAttributedString(string: reversename[indexPath.row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)])
            //設定副標題為vic，字體顏色為橘(orange)，字體大小為16.0
            content.secondaryAttributedText = NSAttributedString(string: reversevic[indexPath.row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])
   
            content.textProperties.adjustsFontSizeToFitWidth = true
            content.textProperties.minimumScaleFactor = 0.85
            content.textProperties.alignment = .natural
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = reversename[indexPath.row]
            cell.textLabel?.textColor = .black
            
            cell.detailTextLabel?.text = reversevic[indexPath.row]
            cell.detailTextLabel?.textColor = .orange
            
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.textLabel?.minimumScaleFactor = 0.85
            cell.textLabel?.textAlignment = .natural
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reverselat: [Double] = lat.reversed()
        let reverselng: [Double] = lng.reversed()
        dismissPopupView()
        delegate?.setMapRegion(lat: reverselat[indexPath.row], lng: reverselng[indexPath.row])
    }
}
