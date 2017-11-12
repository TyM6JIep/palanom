import ObjectMapper

class VkResponse<T: Mappable>: Mappable {
    
    var response: VkItems<T>?
    var execute_errors: String?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        response        <- map["response"]
        execute_errors  <- map["execute_errors"]
    }
}

