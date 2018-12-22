import Foundation
import ObjectMapper
public class DateFormatTransform: TransformType {
    
    
    public typealias Object = NSDate
    public typealias JSON = String
    
    
    var dateFormat:DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df
    }()
    
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat.dateFormat = dateFormat
    }
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if let dateString = value as? String {
            return self.dateFormat.date(from: dateString) as! DateFormatTransform.Object
        }
        return nil
    }
    
    public func transformToJSON(_ value: NSDate?) -> JSON? {
        if let date = value {
            return self.dateFormat.string(from: date as Date)
        }
        return nil
   }
}
   
