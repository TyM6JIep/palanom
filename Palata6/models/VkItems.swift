import ObjectMapper

class VkItems<T: Mappable>: Mappable {
    
    var items: [T]?
    var count: Int?
    var groups: [VkPublic]?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        items       <- map["items"]
        count       <- map["count"]
        groups      <- map["groups"]
    }
}
