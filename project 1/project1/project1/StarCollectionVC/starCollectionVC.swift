import UIKit

class starCollectionVC: UICollectionViewCell {

    @IBOutlet var star: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCell(){
        star.image = UIImage(named: "iconStar")
    }
}
