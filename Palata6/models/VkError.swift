import ObjectMapper

class VkError: Mappable {
    
    var error_code: Int?
    var error_msg: String?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        error_code  <- map["error_code"]
        error_msg   <- map["error_msg"]
    }
}
