import ObjectMapper
import RealmSwift

class CustomListTransform<T:RealmSwift.Object> : TransformType where T:Mappable {
    public typealias Object = List<T>
    public typealias JSON = [AnyObject]
    
    let mapper = Mapper<T>()
    
    public init(){}
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        let results = List<T>()
        if let value = value as? [AnyObject] {
            for json in value {
                if let obj = mapper.map(JSONObject: json) {
                    results.append(obj)
                }
            }
        }
        return results
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        var results = [AnyObject]()
        if let value = value {
            for obj in value {
                let json = mapper.toJSON(obj)
                results.append(json as AnyObject)
            }
        }
        return results
    }
}
