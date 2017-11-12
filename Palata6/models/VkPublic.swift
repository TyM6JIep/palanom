import AlamofireObjectMapper
import ObjectMapper
import Alamofire

class VkPublic: Mappable {
    var id: Int?
    var name: String?
    var screen_name: String?
    var photo_100: String?
    var members_count: Int?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
        screen_name     <- map["screen_name"]
        photo_100       <- map["photo_100"]
        members_count   <- map["members_count"]
    }
    
    class func getGroupInfo(ids: String, success:((VkArrayResponse<VkPublic>) -> Void)!, failure:((VkError) -> Void)!) {
        let params: [String: String] = [
            "group_ids" : ids,
            "fields": "members_count",
            "access_token": Settings.instance.token!,
            "v": "5.62"
        ]
        Alamofire.request(Utils.getUrl(path: "groups.getById"), method: .get, parameters: params, encoding: URLEncoding.default)
            .validate()
            .responseObject(completionHandler: { (response: DataResponse<VkArrayResponse<VkPublic>>) in
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

