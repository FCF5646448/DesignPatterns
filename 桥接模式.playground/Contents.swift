import UIKit

var greeting = "桥接模式"

debugPrint("--------------点奶茶，最垃圾写法---------------")
/*
奶茶有：大杯、小杯；
口味有：芒果、草莓；
*/
// 杯子
enum Cap {
    case big // 大杯
    case small // 小杯
}

// 口味
enum Taste {
    case mango // 芒果
    case strawberry // 草莓
}

struct Custom0 {
    // 点奶茶
    func orderMilktea(_ cap: Cap, _ taste: Taste) {
        switch cap {
        case .big:
            switch taste {
            case .mango:
                debugPrint("点了一杯大杯芒果")
            case .strawberry:
                debugPrint("点了一杯大杯草莓")
            }
        case .small:
            switch taste {
            case .mango:
                debugPrint("点了一杯小杯芒果")
            case .strawberry:
                debugPrint("点了一杯小杯草莓")
            }
        }
    }
}

let customer = Custom0()
customer.orderMilktea(.big, .mango)
customer.orderMilktea(.small, .strawberry)

debugPrint("--------------点奶茶，初步优化---------------")

/// 抽象一个奶茶味
protocol MilkTea {
    func orderMilktea(_ cap: Cap)
}

/// 实现一个芒果口味奶茶
struct MangoMilkTea {
    func orderMilktea(_ cap: Cap) {
        switch cap {
        case .big:
            debugPrint("点了一杯大杯芒果")
        case .small:
            debugPrint("点了一杯小杯芒果")
        }
    }
}

/// 实现一个草莓口味奶茶
struct StrawberryMilkTea {
    func orderMilktea(_ cap: Cap) {
        switch cap {
        case .big:
            debugPrint("点了一杯大杯草莓")
        case .small:
            debugPrint("点了一杯小杯草莓")
        }
    }
}

MangoMilkTea().orderMilktea(.big)
StrawberryMilkTea().orderMilktea(.small)


debugPrint("--------------点奶茶，桥接模式优化---------------")
/// 对具体容器进行抽象
protocol CupInterfase {
    func orderaCap() -> String
}

/// 实现一个大杯
struct BigCap: CupInterfase {
    func orderaCap() -> String {
        return "点了一杯大杯"
    }
}

/// 实现一个小杯
struct SmallCap: CupInterfase {
    func orderaCap() -> String {
        return "点了一杯小杯"
    }
}

///------------------------------------
/// 抽象一个奶茶
protocol MilkTeaProtocol {
    var cap: CupInterfase { get set }
    func orderMilktea()
}

/// 实现一个芒果味
struct MangoMilkTea1: MilkTeaProtocol {
    internal var cap: CupInterfase
    
    init(cap: CupInterfase) {
        self.cap = cap
    }
    
    func orderMilktea() {
        debugPrint(cap.orderaCap() + "芒果")
    }
}

/// 实现一个草莓味
struct StrawberryMilkTea1: MilkTeaProtocol {
    internal var cap: CupInterfase
    
    init(cap: CupInterfase) {
        self.cap = cap
    }
    
    func orderMilktea() {
        debugPrint(cap.orderaCap() + "草莓")
    }
}

MangoMilkTea1(cap: BigCap()).orderMilktea()
StrawberryMilkTea1(cap: SmallCap()).orderMilktea()


/// 实现一个中杯
struct MidCap: CupInterfase {
    func orderaCap() -> String {
        return "点了一杯中杯"
    }
}

/// 实现一个葡萄味
struct GrapeMilktea: MilkTeaProtocol {
    var cap: CupInterfase
    init(cap: CupInterfase) {
        self.cap = cap
    }
    
    func orderMilktea() {
        debugPrint(cap.orderaCap() + "葡萄")
    }
}

GrapeMilktea(cap: MidCap()).orderMilktea() // "点了一杯中杯葡萄"
