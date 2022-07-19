import UIKit
import MapKit

class AnnotationClickVC: UIViewController {
    
    @IBOutlet var popupView: UIView!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var subtextLabel: UILabel!
    @IBOutlet weak var hotelInfo: UIButton!
    @IBOutlet weak var hotelGPS: UIButton!
    
    var name: String = ""
    var vic: String = ""
    
    var selectGPS: ((String) -> ())?
    var selectInfo: ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        componentsInit()
    }
    
    private func componentsInit() {
        textLabel.text = name
        
        subtextLabel.text = vic
        
        hotelInfo.layer.cornerRadius = 5.0
        hotelGPS.layer.cornerRadius = 5.0
        popupView.layer.cornerRadius = 5.0
        
        hotelInfo.backgroundColor = UIColor.init(red: 255/255.0, green: 213/255.0, blue: 128/255.0, alpha: 1)
        hotelGPS.backgroundColor = UIColor.init(red: 255/255.0, green: 213/255.0, blue: 128/255.0, alpha: 1)
        popupView.backgroundColor = UIColor.init(red: 85/255.0, green: 207/255.0, blue: 173/255.0, alpha: 1)
        
        hotelInfo.setImage(UIImage(named: "iconHotel"), for: .normal)
        
        hotelGPS.setImage(UIImage(named: "iconMap"), for: .normal)
    }
    
    func showOn(VC: UIViewController) {
        self.modalPresentationStyle = .overCurrentContext
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .fade
        VC.view.window?.layer.add(transition, forKey: kCATransition)
        VC.present(self, animated: false) {
            self.popupView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.popupView.alpha = 0
            UIView.animate(withDuration: 0.25) {
                self.popupView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.popupView.alpha = 1
            }
        }
    }
    
    private func dismissPopupView() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .fade
        view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismissPopupView()
    }
    
    @IBAction func hotelInfomation(_ btn: UIButton) {
        dismissPopupView()
        self.selectInfo!("旅館資訊")
    }

    @IBAction func hotelLocateGPS(_ btn: UIButton) {
        dismissPopupView()
        self.selectGPS!("旅館導航")
    }
}
