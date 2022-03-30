import UIKit

debugPrint("-----------原型模式-----------")
// 遵守Copying协议的基类
class BaseClass: NSCopying, Equatable {
    private var intValue = 1
    private var stringValue = "Value"
    
    required init(intValue: Int = 1, stringValue: String = "Value") {
        self.intValue = intValue
        self.stringValue = stringValue
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let prototype = type(of: self).init()
        prototype.intValue = intValue
        prototype.stringValue = stringValue
        return prototype
    }
    
    static func == (lhs: BaseClass, rhs: BaseClass) -> Bool {
        return (lhs.intValue == rhs.intValue && lhs.stringValue == rhs.stringValue)
    }
}

class SubClass: BaseClass {
    private var boolValue = true
    func copy()  -> Any {
        return copy(with: nil)
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        guard let prototype = super.copy(with: zone) as? SubClass else {
            return SubClass()
        }
        prototype.boolValue = boolValue
        return prototype
    }
}

let original = SubClass(intValue: 2, stringValue: "value")
if let copy = original.copy() as? SubClass {
    debugPrint(" copyClass and original is \(copy == original ? "same": "diff")")
}

