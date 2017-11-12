import ObjectMapper

class VkLikes: Mappable {
    var count: Int?
    var user_likes: Int?
    var can_like: Int?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        count       <- map["count"]
        user_likes  <- map["user_likes"]
        can_like    <- map["can_like"]
    }
}
