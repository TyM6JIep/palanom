import UIKit

class PalataBaseController: UIViewController, UINavigationBarDelegate {
    
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var isLoaded = false
    var isShowLoader = false
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showActivityIndicatory() {
        if isShowLoader {
            return
        }
        container.frame = CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size)
        container.backgroundColor = Constants.loaderBackgroundColor
        
        loadingView.frame = CGRect(x:0,y:0,width:80,height:80)
        loadingView.center = container.center
        loadingView.backgroundColor = Constants.loaderViewBackgroundColor
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        actInd.frame = CGRect(x:0,y:0,width:40,height:40)
        actInd.activityIndicatorViewStyle = .whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
        
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        view.addSubview(container)
        
        actInd.startAnimating()
        isShowLoader = true
    }
    
    func hideActivityIndicatory() {
        actInd.stopAnimating()
        actInd.removeFromSuperview()
        loadingView.removeFromSuperview()
        container.removeFromSuperview()
        isShowLoader = false
    }
    
    @objc func back() {
        if let navCntrl = navigationController {
            navCntrl.setNavigationBarHidden(false, animated: false)
            navCntrl.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

