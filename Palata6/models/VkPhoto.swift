import ObjectMapper

class VkPhoto: Mappable {
    var text: String?
    var date: Int?
    var photo_604: String?
    var photo_807: String?
    var width:  Int = 1
    var height: Int = 1
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        text        <- map["text"]
        date        <- map["date"]
        photo_604   <- map["photo_604"]
        photo_807   <- map["photo_807"]
        width       <- map["width"]
        height      <- map["height"]
    }
}
