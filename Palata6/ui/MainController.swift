import UIKit

class MainController: UITabBarController, UITabBarControllerDelegate {
    
    let titles: [String] = ["Паблики", "Лента", "Настройки"]
    var tabGroup: UINavigationController!
    var tabFeed: UINavigationController!
    var tabFavourite: UINavigationController!
    var tabSettings: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabGroup = UINavigationController(rootViewController: GroupController(title: titles[0]))
        tabFeed = UINavigationController(rootViewController: FeedController(title: titles[1]))
        tabSettings = UINavigationController(rootViewController: SettingsController(title: titles[2]))
        setNavigationBarSettings([tabGroup, tabFeed, tabSettings])
        
        initTabBar()
    }
    
    func setNavigationBarSettings(_ controllers: [UINavigationController]) {
        controllers.forEach({
            let bar = $0.navigationBar
            bar.barTintColor = Constants.navigationBarBarTintColor
            bar.tintColor = Constants.navigationBarTintColor
            bar.titleTextAttributes = [
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: Constants.navigationBarTitleSize)
            ]
            bar.isTranslucent = false
        })
    }
    
    func initTabBar() {
        let barGroup = UITabBarItem()
        barGroup.title = titles[0]
        barGroup.image = UIImage(named: "ic_group")
        barGroup.selectedImage = UIImage(named: "ic_group_active")
        
        let barFeed = UITabBarItem()
        barFeed.title = titles[1]
        barFeed.image = UIImage(named: "ic_feed")
        barFeed.selectedImage = UIImage(named: "ic_feed_active")
        
        let barSettings = UITabBarItem()
        barSettings.title = titles[2]
        barSettings.image = UIImage(named: "ic_settings")
        barSettings.selectedImage = UIImage(named: "ic_settings_active")
        
        tabGroup!.tabBarItem = barGroup
        tabFeed!.tabBarItem = barFeed
        tabSettings!.tabBarItem = barSettings
        
        self.viewControllers = [tabGroup!, tabFeed!, tabSettings!]
        
        self.tabBar.tintColor = Constants.tabarBarTintColor
        self.selectedIndex = 0
    }
}
