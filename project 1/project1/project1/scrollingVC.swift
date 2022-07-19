import UIKit

class scrollingVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrollBar: UINavigationItem!
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var fullSize: CGSize!
    var index: Int!
        
    var landscopeNowCount: Int = 0
    
    var landscope: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        componentsInit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func componentsInit() {
        
        fullSize = UIScreen.main.bounds.size
        self.view.backgroundColor = UIColor.black
        
        setScroll()
        
        setPageControl()
        
        for index in 0...(landscope.count-1) {
            
            let imgView = UIImageView()
            
            guard let url = URL(string: landscope[index]) else {
                return
            }
            imgView.image = UIImage(data: try! Data(contentsOf: url))
            
            imgView.frame = CGRect(x: 0, y: 0, width: fullSize.width, height: fullSize.width * 0.75)
            imgView.center = CGPoint(x: fullSize.width * (0.5 + CGFloat(index)),
                                    y: fullSize.height * 0.5)
            scrollView.addSubview(imgView)
            
        }
        
        scrollBar.title = String(format: "%d/%d", landscopeNowCount+1, landscope.count)
        scrollBar.titleView?.tintColor = UIColor.cyan
    }
    
    private func setScroll() {
        scrollView = UIScrollView()
        
        scrollView.frame = CGRect(x: 0, y: 20, width: fullSize.width, height: fullSize.height - 20)
        scrollView.contentSize = CGSize(width: fullSize.width * CGFloat(landscope.count), height: fullSize.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.bounces = true
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        self.view.addSubview(scrollView)
    }
    
    private func setPageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: fullSize.width*0.85, height: 50))
        
        pageControl.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.9)
        
        pageControl.numberOfPages = landscope.count
        pageControl.currentPage = landscopeNowCount
        
        pageControl.currentPageIndicatorTintColor = UIColor.cyan
        pageControl.pageIndicatorTintColor = UIColor.gray
        
        pageControl.addTarget(self, action:
                            #selector(scrollingVC.pageChanged),
                            for: .valueChanged)
        
        self.view.addSubview(pageControl)
    }
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = page
        scrollBar.title = String(format: "%d/%d", page+1, landscope.count)
        scrollBar.titleView?.tintColor = UIColor.cyan
    }
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
}
