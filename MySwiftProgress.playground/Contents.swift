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
var a: Int  = 1232

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
    enum Importance {
        case unimportant
        case important
        case ordinary
    }
    var id = UUID().uuidString
    var text: String
    var importance: Importance = .ordinary
    var deadLine: Date? = nil
}
extension TodoItem {
    var json : Any  {
        return 1
    }
    static func parse(json: Any) -> TodoItem? {
        
        return nil
    }
}

class FileCache {
    
}

