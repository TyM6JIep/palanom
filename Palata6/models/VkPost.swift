import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class VkPost: Mappable {
    
    var id: Int?
    var owner_id: Int?
    var date: Int?
    var text = ""
    var likes: VkLikes?
    var views: VkViews?
    var attachments: [VkAttachments]?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        owner_id        <- map["owner_id"]
        date            <- map["date"]
        text            <- map["text"]
        likes           <- map["likes"]
        views           <- map["views"]
        attachments     <- map["attachments"]
    }
    
    class func load(id: Int, count: Int, offset: Int, success:((VkResponse<VkPost>) -> Void)!, failure:((VkError) -> Void)!) {
        let params: [String: String] = [
            "owner_id" : String(-id),
            "access_token": Settings.instance.token!,
            "v": "5.67" //todo
        ]
        
        Alamofire.request(Utils.getUrl(path: "wall.get"), method: .get, parameters: params, encoding: URLEncoding.default)
            .validate()
            .responseObject(completionHandler: { (response: DataResponse<VkResponse<VkPost>>) in
                switch response.result {
                case .success:
                    success(response.result.value!)
                case .failure:
                    failure(parseError(response: response))
                }
            }
        )
    }
    
    internal class func parseError<T>(response: DataResponse<T>) -> VkError {
        var status = 500
        if let htmlResponse = response.response {
            status = htmlResponse.statusCode
        }
        let error = Mapper<VkError>().map(JSONString: "{\"error\":{\"error_code\":\"\(status)\", \"error_msg\": \"error\"}") //todo
        if let d = response.data, d.count != 0 {
            if let json = String(data: d, encoding: .utf8) {
                if let response = Mapper<VkError>().map(JSONString: json) {
                    return response
                } else {
                    return error!
                }
            } else {
                return error!
            }
        } else {
            return error!
        }
    }
}
