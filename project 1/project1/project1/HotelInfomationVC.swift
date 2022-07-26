import UIKit

class HotelInfomationVC: UIViewController {
    
    @IBOutlet var starCollectionView: UICollectionView!
    @IBOutlet var landscopeCollectionView: UICollectionView!
    @IBOutlet var hotelImageView: UIImageView!
    @IBOutlet var hotelName: UILabel!
    @IBOutlet var hotelVic: UILabel!
    @IBOutlet var landscopeCount: UILabel!
    
    var name: String = ""
    var vic: String = ""
    var photo: String = ""
    var star: Int = 0
    var landscope: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        componentsInit()
    }
    
    private func componentsInit() {
        hotelName.text = name
        hotelVic.text = vic
        landscopeCount.text = String(format: "景觀圖(%d)", landscope.count)
        hotelImageView.image = UIImage(systemName: "link")
        
        showImage(url: photo)
        
        let cellNibStar = UINib(nibName: "starCollectionVC", bundle: nil)
        starCollectionView.register(cellNibStar, forCellWithReuseIdentifier: "firCell")
        
        let cellNibLandscope = UINib(nibName: "ImageCollectionVC", bundle: nil)
        landscopeCollectionView.register(cellNibLandscope, forCellWithReuseIdentifier: "secCell")
    }
    
    private func showImage(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.hotelImageView.image = loadedImage
                }
            }
        }
    }
    
}

extension HotelInfomationVC: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case starCollectionView:
            return star
        default:
            return landscope.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case starCollectionView:
            
            let firstcell = collectionView.dequeueReusableCell(withReuseIdentifier: "firCell", for: indexPath) as! starCollectionVC
            
            firstcell.setCell()
            
            return firstcell
        default:

            let secondcell = collectionView.dequeueReusableCell(withReuseIdentifier: "secCell", for: indexPath) as! ImageCollectionVC
            
            secondcell.setCell(url: landscope[indexPath.row])
            
            return secondcell
        }
    }
}

extension HotelInfomationVC: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        switch collectionView {
        case landscopeCollectionView:
                        
            let VC = scrollingVC(landscope: landscope, landscopeNowCount: indexPath.row)
            
            navigationController?.pushViewController(VC, animated: true)
        default:
            print("無效點擊")
        }
    }
}

extension HotelInfomationVC: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case landscopeCollectionView:
            let width = Int((collectionView.bounds.size.width)/2)
            let height = Int(CGFloat(width))
            return CGSize(width: width, height: height)
        default:
            return CGSize(width: 25, height: 25)
        }
    }
}
