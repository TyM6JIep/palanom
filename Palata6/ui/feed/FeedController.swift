import UIKit

class FeedController: PalataBaseController, UITableViewDelegate, UITableViewDataSource, FeedCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let ids: [String] = ["56106344","123695926","58526040","93330757","148708103","145867934","66287638"]
    
    var refreshControl:UIRefreshControl!
    var posts = [VkPost]()
    var group: VkPublic!
    var offset = 0;
    var count = 20;
    var loadingData = false
    var bar: UINavigationBar!
    
    required init(title: String) {
        super.init(nibName: "FeedController", bundle: nil)
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = group {
            navigationItem.title = group!.name
        } else {
            navigationItem.title = self.title
        }
        if posts.count == 0 {
            refresh()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = self.title
        initTableView()
    }
    func initTableView() {
        tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UIScreen.main.bounds.width
        tableView.separatorColor = Constants.navigationBarBarTintColor
        tableView.tableFooterView = UIView()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
        tableView.addSubview(refreshControl)
    }
    @objc func refresh() {
        posts = []
        offset = 0
        loadData()
    }
    func loadData() {
        showActivityIndicatory()
        loadingData = true
        VkPost.load(id: group.id ?? 0, count: count, offset: offset, success: { (response: VkResponse<VkPost>) in
            self.posts += Utils.sortPostByDate(posts: response.response?.items)
            self.offset += self.count
            self.tableView.reloadData()
            self.endLoad()
        }) { (error: VkError) in
            self.endLoad()
            AlertHelper.showErrorAlert(controller: self, message: error.error_msg)
        }
    }
    func endLoad() {
        self.refreshControl?.endRefreshing()
        self.hideActivityIndicatory()
        self.loadingData = false
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        let index = indexPath.row
        if index < posts.count {
            let post = posts[index]
            cell.setPost(post: post, vkPublic: group)
        }
        cell.delegate = self
        cell.layoutIfNeeded()
        cell.layoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = posts.count - 1
        if !loadingData && indexPath.row == lastElement {
            loadData()
        }
    }
    
    func hashtagDidTapped(hashtag: String) {
        AlertHelper.showSuccessAlert(controller: self, message: "Tapped on \(hashtag)")
    }
    
    func urlDidTapped(url: URL) {
        let controller = WebViewController()
        controller.url = url
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
