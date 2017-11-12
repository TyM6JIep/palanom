import ObjectMapper

class VkAttachments: Mappable {
    var type: String?
    var photo: VkPhoto?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        type    <- map["type"]
        photo   <- map["photo"]
    }
}
