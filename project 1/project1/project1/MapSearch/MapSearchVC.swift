import UIKit

protocol MapSearchVCDelegate: AnyObject {
    func sendBack(str: String)
}

class MapSearchVC: UIViewController {

    @IBOutlet var popupView: UIView!
    @IBOutlet var tableView: UITableView!

    var name: [String] = []
    var vic: [String] = []
    var dataCount: Int = 0
    
    var selectHandler: ((Int) -> ())?
    
    var delegate: MapSearchVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        componentsInit()
    }

    private func componentsInit() {
                
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
                
        tableView.reloadData()
        
//        delegate?.sendBack(str: "123")
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
}

extension MapSearchVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                        
        self.selectHandler!(indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.dismissPopupView()
    }
}

extension MapSearchVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if name.isEmpty {
            return 1
        }
        else {
            return name.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell")

        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseCell")
        }
        
        if name.isEmpty {
            cell!.textLabel?.text = String(format: "查詢錯誤")
            cell!.detailTextLabel?.text = String(format: "您未輸入正確字串")
            cell!.detailTextLabel?.textColor = UIColor.orange
        }
        else {
            cell!.textLabel?.text = String(format: "%@",name[indexPath.row])
            cell!.detailTextLabel?.text = String(format: "%@",vic[indexPath.row])
            cell!.detailTextLabel?.textColor = UIColor.orange
        }
        return cell!
        
//       let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell")
//
//        if name.isEmpty {
//            cell.textLabel?.text = String(format: "查詢錯誤")
//            cell.detailTextLabel?.text = String(format: "您未輸入正確字串")
//        }
//        else {
//            cell.textLabel?.text = String(format: "%d . %@", indexPath.row+1,name[indexPath.row])
//            cell.detailTextLabel?.text = String(format: "%@",vic[indexPath.row])
//        }
//        return cell
        
    }
}
