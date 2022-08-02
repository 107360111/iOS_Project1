import UIKit
import SDWebImage

class HotelInfomationVC: UIViewController {
    
    @IBOutlet var starCollectionView: UICollectionView!
    
    @IBOutlet weak var landscopeCollectionView: UICollectionView!
    @IBOutlet var hotelImageView: UIImageView!
    @IBOutlet var hotelName: UILabel!
    @IBOutlet var hotelVic: UILabel!
    @IBOutlet var landscopeCount: UILabel!
    
    private var name: String = ""
    private var vic: String = ""
    private var photo: String = ""
    private var star: Int = 0
    private var landscope: [String] = []
    
    convenience init(name: String, vic: String, photo: String, star: Int, landscope: [String]) {
        self.init()
        self.name = name
        self.vic = vic
        self.photo = photo
        self.star = star
        self.landscope = landscope
        
    }
    
    
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
        
        let cellNibStar = UINib(nibName: "StarCollectionViewCell", bundle: nil)
        starCollectionView.register(cellNibStar, forCellWithReuseIdentifier: "firstCell")
        
        let cellNibLandscope = UINib(nibName: "LandscopeCollectionViewCell", bundle: nil)
        landscopeCollectionView.register(cellNibLandscope, forCellWithReuseIdentifier: "secondCell")
    }
    
    private func showImage(url: String) {
        guard let url = URL(string: url) else { return }
        
        DispatchQueue.main.async { 
            self.hotelImageView.sd_setImage(with: url)
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
            guard let firstCell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCell", for: indexPath) as? StarCollectionViewCell else {
                fatalError()
            }
            
            firstCell.setCell()
            return firstCell
            
        case landscopeCollectionView:
            guard let secondCell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondCell", for: indexPath) as? LandscopeCollectionViewCell else {
                fatalError()
            }
            
            secondCell.setCell(url: landscope[indexPath.row])
            return secondCell
            
        default:
            return LandscopeCollectionViewCell()
        }
    }
}

extension HotelInfomationVC: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        switch collectionView {
        case starCollectionView:
            print("無效點擊")
            
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
        case starCollectionView:
            return CGSize(width: 50, height: 50)
            
        case landscopeCollectionView:
            return CGSize(width: 120, height: 120)

        default:
            return CGSize(width: 0, height: 0)
        }
    }
}
