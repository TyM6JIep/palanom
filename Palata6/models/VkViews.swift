import ObjectMapper

class VkViews: Mappable {
    
    var count: Int?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        count <- map["count"]
    }
}
