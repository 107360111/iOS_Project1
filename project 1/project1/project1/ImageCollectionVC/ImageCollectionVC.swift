import UIKit

class ImageCollectionVC: UICollectionViewCell {
    
    @IBOutlet var landscope: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCell(url: String){

        guard let url = URL(string: url) else {
            return
        }

        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.landscope.image = loadedImage
                }
            }
        }
    }
    
}
