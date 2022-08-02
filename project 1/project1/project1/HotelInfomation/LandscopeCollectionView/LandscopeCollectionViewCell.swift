import UIKit
import SDWebImage

class LandscopeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var landscope: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        componentsInit()
    }
    
    private func componentsInit() {
        landscope.contentMode = .scaleAspectFit
        landscope.image = UIImage(named: "loading")
    }
    
    func setCell(url: String) {
        
        landscope.contentMode = .scaleAspectFit
        landscope.image = UIImage(named: "loading")
        
        guard let url = URL(string: url) else {return}

        DispatchQueue.main.async {
            self.landscope.sd_setImage(with: url)
        }
    }
    
}
