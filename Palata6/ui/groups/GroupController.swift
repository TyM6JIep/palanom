import UIKit
import SwiftyVK

class GroupController: PalataBaseController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let ids: [String] = ["56106344","123695926","58526040","93330757","148708103","145867934","66287638"]
    
    var refreshControl:UIRefreshControl!
    var groups = [VkPublic]()
    
    required init(title: String) {
        super.init(nibName: "GroupController", bundle: nil)
        
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        initTableView()
    }
    @objc func loadData() {
        showActivityIndicatory()
        VkPublic.getGroupInfo(ids: ids.joined(separator: ","), success: { response in
            self.groups = response.response ?? []
            self.tableView.reloadData()
            self.hideActivityIndicatory()
        }, failure: { error in
            self.hideActivityIndicatory()
            AlertHelper.showErrorAlert(controller: self, message: error.error_msg)
        })
    }
    func initTableView() {
        tableView.register(UINib(nibName: "GroupCell", bundle: nil), forCellReuseIdentifier: "GroupCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = CGFloat(55)
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
        
        tableView.addSubview(refreshControl)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count == 0 ? 0 : groups.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
        if indexPath.row == 0 {
            cell.initAllPublics()
        } else {
            cell.setGroup(index: indexPath.row, group: groups[indexPath.row - 1])
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = (tabBarController?.viewControllers?[1] as? UINavigationController)?.viewControllers[0] else {
            return
        }
        if indexPath.row == 0 {
            controller.title = "Все наши здесь"
            (controller as! FeedController).group = nil
        } else {
            let index = indexPath.row - 1
            controller.title = groups[index].name
            (controller as! FeedController).group = groups[index]
            (controller as! FeedController).refresh()
            (controller as! FeedController).tableView.setContentOffset(CGPoint.zero, animated: true)
        }
        tabBarController?.selectedIndex = 1
    }
}
