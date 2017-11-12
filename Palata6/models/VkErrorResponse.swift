import Foundation
import ObjectMapper

class VkErrorResponse: Mappable {
    
    var error: VkError?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        error   <- map["error"]
    }
}
