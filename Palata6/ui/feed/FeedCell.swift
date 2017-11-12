import UIKit
import ActiveLabel
import SwiftGifOrigin

protocol FeedCellDelegate {
    func hashtagDidTapped(hashtag: String)
    func urlDidTapped(url: URL)
}

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var postGroupName: UILabel!
    @IBOutlet weak var postGroupImage: UIImageView!
    @IBOutlet weak var postMessage: ActiveLabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var photoView: UIView!
    
    @IBOutlet weak var photoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var postMessageHeight: NSLayoutConstraint!
    
    let df = DateFormatter(mask: "yyyy-MM-dd HH:mm:ss")  //todo
    let margin: CGFloat = 5.0
    let screenWidth = UIScreen.main.bounds.width
    
    var delegate: FeedCellDelegate?
    var vkPost: VkPost?
    var photos = [VkPhoto]()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard postMessage != nil, postMessageHeight != nil else {
            return
        }
        guard let text = postMessage.text else {
            return
        }
        guard text.isEmpty else {
            return
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        postMessage.enabledTypes = [.hashtag, .url]
        postMessage.handleHashtagTap { hashtag in
            if let _ = self.delegate {
                self.delegate!.hashtagDidTapped(hashtag: hashtag)
            }
        }
        postMessage.handleURLTap { (url: URL) in
            if let _ = self.delegate {
                self.delegate!.urlDidTapped(url: url)
            }
        }
    }
    
    func setPost(post: VkPost, data: [String]) {
        vkPost = post
        postGroupName.text = data[0]
        postDate.text = "Добавлено \(df.string(from: NSDate(timeIntervalSince1970: TimeInterval(post.date!)) as Date))" //todo
        if !post.text.isEmpty || post.text.count != 0 {
            postMessage.font = UIFont.systemFont(ofSize: 14.0)
            postMessage.text = post.text
        } else {
            postMessage.font = UIFont.systemFont(ofSize: 0.0)
            postMessage.text = nil
        }
        
        let like = post.likes
        if like != nil {
            likeLabel.text = String(like!.count!)
            
            if like!.user_likes == 1 {
                likeLabel.alpha = 1.0
            } else {
                likeLabel.alpha = 0.4
            }
        }
        if post.views != nil {
            viewLabel.text = String(post.views!.count!)
        }
        
        photoView.subviews.forEach{ $0.removeFromSuperview() }
        clearAttachment()
        
        if post.attachments != nil {
            let attachments = post.attachments!
            for attachment in attachments {
                switch attachment.type! {
                case "photo":
                    photos.append(attachment.photo!)
                default:
                    break
                }
            }
        }
        photoViewHeight.constant = 0
        
        loadAttachmentData()
        
        postGroupImage.moa.url = data[1]
        postGroupImage.layer.cornerRadius = postGroupImage.frame.width / 2
        postGroupImage.clipsToBounds = true
    }
    
    func setPost(post: VkPost, vkPublic: VkPublic) {
        vkPost = post
        postGroupName.text = vkPublic.name
        postDate.text = "Добавлено \(df.string(from: NSDate(timeIntervalSince1970: TimeInterval(post.date!)) as Date))" //todo
        if !post.text.isEmpty || post.text.count != 0 {
            postMessage.font = UIFont.systemFont(ofSize: 14.0)
            postMessage.text = post.text
        } else {
            postMessage.font = UIFont.systemFont(ofSize: 0.0)
            postMessage.text = nil
        }
        
        let like = post.likes
        if like != nil {
            likeLabel.text = String(like!.count!)
            
            if like!.user_likes == 1 {
                likeLabel.alpha = 1.0
            } else {
                likeLabel.alpha = 0.4
            }
        }
        if post.views != nil {
            viewLabel.text = String(post.views!.count!)
        }
        
        photoView.subviews.forEach{ $0.removeFromSuperview() }
        clearAttachment()
        
        if post.attachments != nil {
            let attachments = post.attachments!
            for attachment in attachments {
                switch attachment.type! {
                case "photo":
                    photos.append(attachment.photo!)
                default:
                    break
                }
            }
        }
        photoViewHeight.constant = 0
        
        loadAttachmentData()
        
        postGroupImage.moa.url = vkPublic.photo_100
        postGroupImage.layer.cornerRadius = postGroupImage.frame.width / 2
        postGroupImage.clipsToBounds = true
    }
    
    func clearAttachment() {
        photos = []
    }
    
    func loadAttachmentData() {
        if photos.count != 0 {
            loadPhotos()
        }
    }
    
    // todo - придумать хитрый механизм постройки плитки
    func loadPhotos() {
        switch photos.count {
        case 1:
            let k = UIScreen.main.bounds.width / CGFloat(photos[0].width)
            let viewHeight =  CGFloat(photos[0].height) * k
            
            photoViewHeight.constant = photoViewHeight.constant + viewHeight
            createImageView(path: getImageUrl(photo: photos[0]), frame: CGRect(origin: CGPoint.zero, size: CGSize(width: screenWidth, height: viewHeight)))
        case 2:
            let width = (screenWidth - margin * CGFloat(3)) / CGFloat(2)
            
            let k1 = width / CGFloat(photos[0].width)
            let k2 = width / CGFloat(photos[1].width)
            
            let viewHeight =  max(CGFloat(photos[0].height) * k1, CGFloat(photos[1].height) * k2)
            photoViewHeight.constant = photoViewHeight.constant + viewHeight
            
            let size = CGSize(width: width, height: viewHeight)
            var frame = CGRect(origin: CGPoint(x: 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[0]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[1]), frame: frame)
        case 3:
            let k = UIScreen.main.bounds.width / CGFloat(photos[0].width)
            var viewHeight =  CGFloat(photos[0].height) * k
            
            photoViewHeight.constant = photoViewHeight.constant + viewHeight
            
            var frame = CGRect(origin: CGPoint.zero, size: CGSize(width: screenWidth, height: viewHeight))
            createImageView(path: getImageUrl(photo: photos[0]), frame: frame)
            
            let width = (screenWidth - margin * CGFloat(3)) / CGFloat(2)
            
            let k1 = width / CGFloat(photos[1].width)
            let k2 = width / CGFloat(photos[2].width)
            
            viewHeight =  max(CGFloat(photos[1].height) * k1, CGFloat(photos[2].height) * k2)
            photoViewHeight.constant = photoViewHeight.constant + viewHeight + margin
            
            let y = frame.maxY + margin
            let size = CGSize(width: width, height: viewHeight)
            frame = CGRect(origin: CGPoint(x: 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[1]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[2]), frame: frame)
        case 4:
            let width = (screenWidth - margin * CGFloat(3)) / CGFloat(2)
            
            var k1 = width / CGFloat(photos[0].width)
            var k2 = width / CGFloat(photos[1].width)
            
            var viewHeight =  max(CGFloat(photos[0].height) * k1, CGFloat(photos[1].height) * k2)
            photoViewHeight.constant = photoViewHeight.constant + viewHeight
            
            var size = CGSize(width: width, height: viewHeight)
            var frame = CGRect(origin: CGPoint(x: 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[0]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[1]), frame: frame)
            
            k1 = width / CGFloat(photos[2].width)
            k2 = width / CGFloat(photos[3].width)
            
            viewHeight =  max(CGFloat(photos[2].height) * k1, CGFloat(photos[3].height) * k2)
            photoViewHeight.constant = photoViewHeight.constant + viewHeight + margin
            
            let y = frame.maxY + margin
            size = CGSize(width: width, height: viewHeight)
            frame = CGRect(origin: CGPoint(x: 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[0]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[1]), frame: frame)
        case 5:
            var width = (screenWidth - margin * CGFloat(3)) / CGFloat(2)
            
            var k1 = width / CGFloat(photos[0].width)
            var k2 = width / CGFloat(photos[1].width)
            
            var viewHeight =  max(CGFloat(photos[0].height) * k1, CGFloat(photos[1].height) * k2)
            photoViewHeight.constant = photoViewHeight.constant + viewHeight
            
            var size = CGSize(width: width, height: viewHeight)
            var frame = CGRect(origin: CGPoint(x: 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[0]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[1]), frame: frame)
            
            width = (screenWidth - margin * CGFloat(4)) / CGFloat(3)
            
            k1 = width / CGFloat(photos[2].width)
            k2 = width / CGFloat(photos[3].width)
            let k3 = width / CGFloat(photos[4].width)
            
            viewHeight =  max(CGFloat(photos[2].height) * k1, CGFloat(photos[3].height) * k2, CGFloat(photos[4].height) * k3)
            photoViewHeight.constant = photoViewHeight.constant + viewHeight + margin
            
            let y = frame.maxY + margin
            size = CGSize(width: width, height: viewHeight)
            frame = CGRect(origin: CGPoint(x: 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[2]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[3]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[4]), frame: frame)
        case 6:
            let width = (screenWidth - margin * CGFloat(4)) / CGFloat(3)
            
            var k1 = width / CGFloat(photos[0].width)
            var k2 = width / CGFloat(photos[1].width)
            var k3 = width / CGFloat(photos[2].width)
            
            var viewHeight =  max(CGFloat(photos[0].height) * k1, CGFloat(photos[1].height) * k2, CGFloat(photos[2].height) * k3)
            photoViewHeight.constant = photoViewHeight.constant + viewHeight
            
            var size = CGSize(width: width, height: viewHeight)
            var frame = CGRect(origin: CGPoint(x: 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[0]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[1]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[2]), frame: frame)
            
            k1 = width / CGFloat(photos[3].width)
            k2 = width / CGFloat(photos[4].width)
            k3 = width / CGFloat(photos[5].width)
            
            viewHeight =  max(CGFloat(photos[3].height) * k1, CGFloat(photos[4].height) * k2, CGFloat(photos[5].height) * k3)
            photoViewHeight.constant = photoViewHeight.constant + viewHeight + margin
            
            let y = frame.maxY + margin
            size = CGSize(width: width, height: viewHeight)
            frame = CGRect(origin: CGPoint(x: 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[3]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[4]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[5]), frame: frame)
        case 7:
            var width = (screenWidth - margin * CGFloat(4)) / CGFloat(3)
            
            var k1 = width / CGFloat(photos[0].width)
            var k2 = width / CGFloat(photos[1].width)
            var k3 = width / CGFloat(photos[2].width)
            
            var viewHeight =  max(CGFloat(photos[0].height) * k1, CGFloat(photos[1].height) * k2, CGFloat(photos[2].height) * k3)
            photoViewHeight.constant = photoViewHeight.constant + viewHeight
            
            var size = CGSize(width: width, height: viewHeight)
            var frame = CGRect(origin: CGPoint(x: 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[0]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[1]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[2]), frame: frame)
            
            width = (screenWidth - margin * CGFloat(5)) / CGFloat(4)
            
            k1 = width / CGFloat(photos[3].width)
            k2 = width / CGFloat(photos[4].width)
            k3 = width / CGFloat(photos[5].width)
            let k4 = width / CGFloat(photos[6].width)
            
            viewHeight =  max(CGFloat(photos[3].height) * k1, CGFloat(photos[4].height) * k2, CGFloat(photos[5].height) * k3, CGFloat(photos[6].height) * k4)
            photoViewHeight.constant = photoViewHeight.constant + viewHeight + margin
            
            let y = frame.maxY + margin
            size = CGSize(width: width, height: viewHeight)
            frame = CGRect(origin: CGPoint(x: 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[3]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[4]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[5]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[6]), frame: frame)
        case 8:
            var width = (screenWidth - margin * CGFloat(3)) / CGFloat(2)
            
            var k1 = width / CGFloat(photos[0].width)
            var k2 = width / CGFloat(photos[1].width)
            
            var viewHeight =  max(CGFloat(photos[0].height) * k1, CGFloat(photos[1].height) * k2)
            photoViewHeight.constant = photoViewHeight.constant + viewHeight
            
            var size = CGSize(width: width, height: viewHeight)
            var frame = CGRect(origin: CGPoint(x: 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[0]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[1]), frame: frame)
            
            width = (screenWidth - margin * CGFloat(4)) / CGFloat(3)
            
            k1 = width / CGFloat(photos[2].width)
            k2 = width / CGFloat(photos[3].width)
            var k3 = width / CGFloat(photos[4].width)
            
            viewHeight =  max(CGFloat(photos[2].height) * k1, CGFloat(photos[3].height) * k2, CGFloat(photos[4].height) * k3)
            photoViewHeight.constant = photoViewHeight.constant + viewHeight + margin
            
            var y = frame.maxY + margin
            size = CGSize(width: width, height: viewHeight)
            frame = CGRect(origin: CGPoint(x: 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[2]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[3]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[4]), frame: frame)
            
            k1 = width / CGFloat(photos[5].width)
            k2 = width / CGFloat(photos[6].width)
            k3 = width / CGFloat(photos[7].width)
            
            viewHeight =  max(CGFloat(photos[5].height) * k1, CGFloat(photos[6].height) * k2, CGFloat(photos[7].height) * k3)
            photoViewHeight.constant = photoViewHeight.constant + viewHeight + margin
            
            y = frame.maxY + margin
            size = CGSize(width: width, height: viewHeight)
            frame = CGRect(origin: CGPoint(x: 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[5]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[6]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[7]), frame: frame)
        case 9:
            let width = (screenWidth - margin * CGFloat(4)) / CGFloat(3)
            
            var k1 = width / CGFloat(photos[0].width)
            var k2 = width / CGFloat(photos[1].width)
            var k3 = width / CGFloat(photos[2].width)
            
            var viewHeight =  max(CGFloat(photos[0].height) * k1, CGFloat(photos[1].height) * k2, CGFloat(photos[2].height) * k3)
            photoViewHeight.constant = photoViewHeight.constant + viewHeight
            
            var size = CGSize(width: width, height: viewHeight)
            var frame = CGRect(origin: CGPoint(x: 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[0]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[1]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[2]), frame: frame)
            
            k1 = width / CGFloat(photos[3].width)
            k2 = width / CGFloat(photos[4].width)
            k3 = width / CGFloat(photos[5].width)
            
            viewHeight =  max(CGFloat(photos[3].height) * k1, CGFloat(photos[4].height) * k2, CGFloat(photos[5].height) * k3)
            photoViewHeight.constant = photoViewHeight.constant + viewHeight + margin
            
            var y = frame.maxY + margin
            size = CGSize(width: width, height: viewHeight)
            frame = CGRect(origin: CGPoint(x: 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[3]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[4]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[5]), frame: frame)
            
            k1 = width / CGFloat(photos[6].width)
            k2 = width / CGFloat(photos[7].width)
            k3 = width / CGFloat(photos[8].width)
            
            viewHeight =  max(CGFloat(photos[6].height) * k1, CGFloat(photos[7].height) * k2, CGFloat(photos[8].height) * k3)
            photoViewHeight.constant = photoViewHeight.constant + viewHeight + margin
            
            y = frame.maxY + margin
            size = CGSize(width: width, height: viewHeight)
            frame = CGRect(origin: CGPoint(x: 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[6]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[7]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[8]), frame: frame)
        case 10:
            var width = (screenWidth - margin * CGFloat(5)) / CGFloat(4)
            
            var k1 = width / CGFloat(photos[0].width)
            var k2 = width / CGFloat(photos[1].width)
            var k3 = width / CGFloat(photos[2].width)
            var k4 = width / CGFloat(photos[3].width)
            
            var viewHeight =  max(CGFloat(photos[0].height) * k1, CGFloat(photos[1].height) * k2, CGFloat(photos[2].height) * k3, CGFloat(photos[3].height) * k4)
            photoViewHeight.constant = photoViewHeight.constant + viewHeight
            
            var size = CGSize(width: width, height: viewHeight)
            var frame = CGRect(origin: CGPoint(x: 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[0]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[1]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[2]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: 0.0), size: size)
            createImageView(path: getImageUrl(photo: photos[3]), frame: frame)
            
            width = (screenWidth - margin * CGFloat(3)) / CGFloat(2)
            
            k1 = width / CGFloat(photos[4].width)
            k2 = width / CGFloat(photos[5].width)
            
            viewHeight =  max(CGFloat(photos[4].height) * k1, CGFloat(photos[5].height) * k2)
            photoViewHeight.constant = photoViewHeight.constant + viewHeight  + margin
            
            var y = frame.maxY + margin
            size = CGSize(width: width, height: viewHeight)
            frame = CGRect(origin: CGPoint(x: 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[4]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[5]), frame: frame)
            
            width = (screenWidth - margin * CGFloat(5)) / CGFloat(4)
            
            k1 = width / CGFloat(photos[6].width)
            k2 = width / CGFloat(photos[7].width)
            k3 = width / CGFloat(photos[8].width)
            k4 = width / CGFloat(photos[9].width)
            
            viewHeight =  max(CGFloat(photos[6].height) * k1, CGFloat(photos[7].height) * k2, CGFloat(photos[8].height) * k3, CGFloat(photos[9].height) * k4)
            photoViewHeight.constant = photoViewHeight.constant + viewHeight + margin
            
            y = frame.maxY + margin
            size = CGSize(width: width, height: viewHeight)
            frame = CGRect(origin: CGPoint(x: 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[6]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[7]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[8]), frame: frame)
            
            frame = CGRect(origin: CGPoint(x: frame.maxX + 5.0, y: y), size: size)
            createImageView(path: getImageUrl(photo: photos[9]), frame: frame)
        default:
            break
        }
    }
    func getImageUrl(photo: VkPhoto) -> String {
        var path = ""
        if let _ = photo.photo_604 {
            path = photo.photo_604!
        }
        if let _ = photo.photo_807 {
            path = photo.photo_807!
        }
        return path;
    }
    
    func createImageView(path: String, frame: CGRect) {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.frame = frame
        imageView.contentMode = .scaleAspectFit
        imageView.moa.url = path
        
        photoView.addSubview(imageView)
    }
}
