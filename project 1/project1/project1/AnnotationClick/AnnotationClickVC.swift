import UIKit
import MapKit
import CoreLocation

protocol AnnotationClickVCDelegate: AnyObject {
    func transtoInfo(name: String, vic: String)
    
    func transtoGPS(lat: Double, lng: Double)
}

class AnnotationClickVC: UIViewController {
    
    @IBOutlet var popupView: UIView!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var subtextLabel: UILabel!
    @IBOutlet weak var hotelInfo: UIButton!
    @IBOutlet weak var hotelGPS: UIButton!
    
    weak var delegate: AnnotationClickVCDelegate?
    private var name: String = ""
    private var vic: String = ""
    private var lat: Double = 0.0
    private var lng: Double = 0.0
    
    
    convenience init(name: String = "", vic: String = "", lat: Double = 0.0, lng: Double = 0.0) {
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
        textLabel.text = name
        
        subtextLabel.text = vic
        
        hotelInfo.layer.cornerRadius = 10
        hotelGPS.layer.cornerRadius = 10
        popupView.layer.cornerRadius = 10
        
        hotelInfo.backgroundColor = UIColor.init(red: 255/255.0, green: 213/255.0, blue: 128/255.0, alpha: 1)
        hotelGPS.backgroundColor = UIColor.init(red: 255/255.0, green: 213/255.0, blue: 128/255.0, alpha: 1)
        popupView.backgroundColor = UIColor.init(red: 85/255.0, green: 207/255.0, blue: 173/255.0, alpha: 1)
        
        hotelInfo.setImage(UIImage(named: "iconHotel"), for: .normal)
        hotelGPS.setImage(UIImage(named: "iconMap"), for: .normal)
        
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
        
    @IBAction func hotelInfomation(_ btn: UIButton) {
        UserDefaults.standard.removeObject(forKey: "cell")
        dismissPopupView()
        delegate?.transtoInfo(name: name, vic: vic)
    }

    @IBAction func hotelLocateGPS(_ btn: UIButton) {
        UserDefaults.standard.removeObject(forKey: "cell")
        dismissPopupView()
        delegate?.transtoGPS(lat: lat, lng: lng)
    }
}
