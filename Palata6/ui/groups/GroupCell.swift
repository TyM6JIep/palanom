import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupPublicCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setGroup(index: Int, group: VkPublic) {
        groupName.text = group.name
        
        if let _ = group.members_count {
            groupPublicCount.text = Utils.getFollowerTitle(count: group.members_count!)
            groupPublicCount.sizeToFit()
        }
        groupImage.isHidden = false
        groupImage.layer.cornerRadius = groupImage.frame.width / 2
        groupImage.clipsToBounds = true
        
        if let _ = group.photo_100 {
            groupImage.moa.url = group.photo_100!
        }
    }
    
    func initAllPublics() {
        groupImage.isHidden = true
        groupName.text = "Читать всё"
    }
}
