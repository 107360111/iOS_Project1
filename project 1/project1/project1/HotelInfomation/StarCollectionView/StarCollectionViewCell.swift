import UIKit

class StarCollectionViewCell: UICollectionViewCell {

    @IBOutlet var star: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        componentsInit()
    }
    
    private func componentsInit() {
        star.contentMode = .scaleAspectFit
        star.tintColor = #colorLiteral(red: 0.9254901961, green: 0.7803921569, blue: 0.2, alpha: 1)
    }
    
    func setCell() {
        star.image = UIImage(systemName: "star.fill")
    }
}
