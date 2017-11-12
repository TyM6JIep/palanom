import UIKit
import Foundation

class Utils {
    
    class func getFollowerTitle(count: Int) -> String {
        let end: String
        var value = count % 100
        if value > 10 && value < 15 {
            end = "ов"
        } else {
            value = value % 10
            switch value {
            case let value where value == 0:
                end = "ов"
            case let value where value == 1:
                end = ""
            case let value where value > 4:
                end = "ов"
            case let value where value > 1:
                end = "а"
            default:
                end = "ов"
            }
        }
        
        return "\(count.formattedWithSeparator) подписчик\(end)"
    }
    
    class func getUrl(path: String) -> URL {
        return URL(string: Constants.apiUrl + path)!
    }
    
    class func sortPostByDate(posts: [VkPost]?) -> [VkPost] {
        guard let _ = posts else {
            return [VkPost]()
        }
        return posts!.sorted(by: { $0.date! > $1.date! })
    }
}

