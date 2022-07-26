import UIKit
import SDWebImage

class scrollingVC: UIViewController {

    @IBOutlet var scrollBar: UINavigationItem!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var pageControl: UIPageControl!
        
    var landscopeNowCount: Int = 0
    var landscope: [String] = []
    
    private var isInit: Bool = true
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        componentsInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isInit = false
        view.layoutIfNeeded()
        collectionView.setContentOffset(CGPoint(x: Int(UIScreen.main.bounds.size.width) * landscopeNowCount, y: 0), animated: false)
    }
        
    private func componentsInit() {
        collectionView.backgroundColor = UIColor.black
                
//        setPageControl()
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionViewFlowLayout.itemSize = UIScreen.main.bounds.size
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                
        collectionView.reloadData()
        
        scrollBar.title = String(format: "%d/%d", landscopeNowCount+1, landscope.count)
    }
    
//    private func setPageControl() {
//        pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width*0.85, height: 50))
//
//        pageControl.center = CGPoint(x: view.bounds.size.width * 0.5, y: view.bounds.size.height * 0.9)
//
//        pageControl.numberOfPages = landscope.count
//        pageControl.currentPage = landscopeNowCount
//
//        pageControl.currentPageIndicatorTintColor = UIColor.cyan
//        pageControl.pageIndicatorTintColor = UIColor.gray
//
//        pageControl.addTarget(self, action:
//                            #selector(scrollingVC.pageChanged),
//                            for: .valueChanged)
//
//        self.view.addSubview(pageControl)
//    }
//
//    @IBAction func pageChanged(_ sender: UIPageControl) {
//        var frame = collectionView.frame
//        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
//        frame.origin.y = 0
//
//        collectionView.scrollRectToVisible(frame, animated: true)
//    }
}

extension scrollingVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return landscope.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
        imageView.contentMode = .scaleAspectFit
        guard landscope.indices.contains(indexPath.row) else { return cell }
        imageView.sd_setImage(with: URL(string: landscope[indexPath.row]))
        cell.addSubview(imageView)
        cell.bringSubviewToFront(imageView)
        
        return cell
    }
}

extension scrollingVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == collectionView, !isInit else { return }
        let offsetX: CGFloat = scrollView.contentOffset.x
        
        let page: CGFloat = round(offsetX / UIScreen.main.bounds.size.width)
        landscopeNowCount = Int(page)
    }
}
