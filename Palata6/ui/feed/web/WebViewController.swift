import UIKit

class WebViewController: PalataBaseController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var url: URL?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationBar()
        
        webView.delegate = self
        
        showActivityIndicatory()
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
    
    func initNavigationBar() {
        let item = navigationItem
        item.title = "Просмотр записи"
        item.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        hideActivityIndicatory()
    }
}
