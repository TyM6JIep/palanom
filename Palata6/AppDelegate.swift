import UIKit
import SwiftyVK
import moa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SwiftyVKDelegate {
    
    var window: UIWindow?
    let appId = "5793464"
    let scopes: Scopes = [.groups]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        VK.setUp(appId: appId, delegate: self)
        VK.sessions?.default.logIn(
            onSuccess: { info in
                Settings.instance.token = info["access_token"]
            },
            onError: { error in
                print("SwiftyVK: authorize failed with", error)
            }
        )
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = MainController()
        self.window!.makeKeyAndVisible()
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: Constants.navigationBarTintColor,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: Constants.navigationBarTitleSize)
        ]
        UINavigationBar.appearance().barTintColor = Constants.navigationBarBarTintColor
        
        return true
    }
    
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        return scopes
    }
    
    func vkNeedToPresent(viewController: VKViewController) {
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            rootController.present(viewController, animated: true, completion: nil)
        }
    }
    
    func vkTokenCreated(for sessionId: String, info: [String : String]) {
        print("token created in session \(sessionId) with info \(info)")
        Settings.instance.token = info["access_token"]
    }
    
    func vkTokenUpdated(for sessionId: String, info: [String : String]) {
        print("token updated in session \(sessionId) with info \(info)")
        Settings.instance.token = info["access_token"]
    }
    
    func vkTokenRemoved(for sessionId: String) {
        print("token removed in session \(sessionId)")
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let app = options[.sourceApplication] as? String
        VK.handle(url: url, sourceApplication: app)
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        VK.handle(url: url, sourceApplication: sourceApplication)
        return true
    }
    
    #if os(iOS)
    func vkWillPresentView() -> UIViewController {
        return UIApplication.shared.delegate!.window!!.rootViewController!
    }
    #endif
}
