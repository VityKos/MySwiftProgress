import Foundation
import Darwin

extension Int {
    var lenght: Int {
        return String(self).count
    }
    
    subscript(_ index: Int) -> Character? {
        
        if index+1 > String(self).count {
            return nil
        }
        return Array(String(self))[index]
    }
    subscript (_ value : ClosedRange<Int>) -> String {
        get {
            return String(self)[value]
        }
        set {
            self = Int(String(self)[value])!
        }
    }
}
extension String {
    subscript (_ value : ClosedRange<Int>) -> String {
        get {
            var string = self
            var temp = ""
            var index = 0
            value.lowerBound < 1 ? (index = 1) : (index = value.lowerBound)
            for i in value {
                if i > self.count {break}
                else if i > 0 {
                    temp.append(string.remove(at: string.index(string.index(string.startIndex, offsetBy: index-1), offsetBy: 0)))
                }
            }
            return temp
        }
        set {
            var string = self
            var index = 0
            value.lowerBound < 1 ? (index = 1) : (index = value.lowerBound)
            for i in value {
                if i > self.count {break}
                else if i > 0 {
                    string.remove(at: string.index(string.index(string.startIndex, offsetBy: index-1), offsetBy: 0))
                }
            }
            self = newValue + string
        }
    }
}
extension Int8 {
    func binary() -> String {
        var result = ""
        for i in 0..<8 {
            let mask = 1 << i
            let set = Int(self) & mask != 0
            result = (set ? "1" : "0") + result
        }
        return result
    }
}
extension Bool {
    init (_ value: Int) {
        self.init(value != 0)
    }
}

enum dividerErrors : Error {
    case divideByZero
}

class Point2d  {
    var x: Int
    var y: Int
    func distanceToCenter() -> Double {
        return sqrt(Double(x*x+y*y))
    }
    init(xValue: Int = 0 , yValue: Int = 0) {
        self.x = xValue
        self.y = yValue
    }
    deinit {
        print("Point 2d was deleted:(")
    }
}
class Point3d  : Point2d {
    var z: Int
    override func distanceToCenter() -> Double {
        return sqrt(Double(x*x+y*y+z*z))
    }
    
    init (xValue:Int = 0, yValue: Int = 0, zValue: Int = 0) {
        self.z = zValue
        super.init(xValue: xValue, yValue: yValue)
    }
    deinit {
        print("Point 3d was deleted ")
    }
}


public struct TodoItem {
    enum Importance: String {
        case unimportant = "unimportant"
        case important = "important"
        case ordinary = "ordinary"
    }
    let id: String
    let text: String
    let importance: Importance
    let deadLine: Date?
    
    init(id: String =  UUID().uuidString, text: String, deadLine: Date? = nil, importance: Importance = .ordinary) {
        self.id = id
        self.text = text
        self.deadLine = deadLine
        self.importance = importance
    }
}

extension TodoItem {
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    //create data json
    var json : Data {
        var object_dict: [String: Any] = [
            "id": self.id,
            "text": self.text,
            "importance": self.importance.rawValue,
        ]
        if let date = self.deadLine {
            object_dict["deadLine"] = date.timeIntervalSince1970
        }
        do {
            return try JSONSerialization.data(withJSONObject: object_dict, options: .prettyPrinted)
        } catch {print(error.localizedDescription)}
        return Data()
    }
    static func parse(json: Data) throws -> TodoItem? {
        do {
            let decoded = try JSONSerialization.jsonObject(with: json, options: .topLevelDictionaryAssumed)
            if let dictFromJson = decoded as? [String: Any] {
                return TodoItem(
                    id: dictFromJson["id"] as! String,
                    text: dictFromJson["text"] as! String,
                    deadLine: Date(timeIntervalSince1970: dictFromJson["deadLine"] as! TimeInterval),
                    importance: TodoItem.Importance(rawValue: dictFromJson["importance"] as! String)!
                )
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
class FileCache {
    enum SerializationError: Error {
        case missing(String)
        case invalid(String)
    }
    private(set) var list: [TodoItem] = []
    func add(item: TodoItem) {
        list.append(item)
    }
    func remove(byId id: String) throws {
        var index: Int = -1
        for i in 0..<list.count {
            if list[i].id == id {
                index = i
            }
        }
        if index == -1  {
            throw SerializationError.invalid("id")
        }
        list.remove(at: index)
    }
}

var test = TodoItem(text: "Need to bay bread", deadLine: Date(), importance: .important)
print(test.id)
print(test.importance)
print(test.text)
if let a = try TodoItem.parse(json: test.json ) {
    print(a.text)
    print(a.deadLine!)
}
