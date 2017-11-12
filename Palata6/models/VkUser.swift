import ObjectMapper

class VkUser: Mappable {
    var id: Int?
    var first_name: String?
    var last_name: String?
    var photo_100: String?
    var online: Int?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        first_name  <- map["first_name"]
        last_name   <- map["last_name"]
        photo_100   <- map["photo_100"]
        online      <- map["online"]
    }
}
