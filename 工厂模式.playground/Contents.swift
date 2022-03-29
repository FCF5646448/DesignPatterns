import UIKit

debugPrint("------------------ 简单工厂 ----------------")

/// 抽象产品：定义一堆类似服务端的协议或父类，用于承载一些公共的属性或方法，由子类或实现来实现具体产品
protocol Service {
    var url: String { get }
}
/// 具体产品：开发环境类
struct DevService: Service {
    var url: String { return "https://dev.host/"}
}
/// 具体产品：发布环境类
struct RelService: Service {
    var url: String { return "https://rel.host/"}
}
/// 工厂类：根据实际环境来获取最终服务。是简单工厂模式的关键
struct EnvironmentFacory {
    enum EnvironmentType {
        case dev
        case rel
    }
    
    // 如果要加新的服务类型，则就会破坏这里的代码。 违反了开闭原则
    static func create(_ environment: EnvironmentType) -> Service {
        switch environment {
        case .dev:
            return DevService()
        case .rel:
            return RelService()
        }
    }
}

debugPrint(EnvironmentFacory.create(.dev).url)
debugPrint("简单工厂：优势：代码少，逻辑清晰。缺点：扩展性不好，违反了开闭原则;")


debugPrint("------------------ 工厂方法 ----------------")
/// 抽象产品：定义一堆类似服务端的协议或父类，用于承载一些公共的属性或方法，由子类或实现来实现具体产品
protocol Service1 {
    var url: String { get }
}
/// 抽象工厂：工厂协议，将具体产品的实例化推迟到具体类中进行。
protocol Service1Factory {
    func create() -> Service1
}

/// 具体产品：开发环境类
struct DevService1: Service1 {
    var url: String { return "https://dev.host/"}
}
/// 具体工厂实现：开发环境工厂
struct DevService1Factory: Service1Factory {
    func create() -> Service1 { DevService1() }
}
/// 具体产品：发布环境类
struct RelService1: Service1 {
    var url: String { return "https://rel.host/"}
}
/// 具体工厂实现：发布环境工厂
struct RelService1Factory: Service1Factory {
    func create() -> Service1 { RelService1() }
}

// 直接使用具体产品的工厂实现，后续增加新的类型只要实现对应协议及工厂方法即可。
debugPrint(DevService1Factory().create().url)
debugPrint("工厂方法：去掉了简单工厂中的工厂类，完全符合了开闭原则，且扩展性高，使用者不用担心具体实现。 缺点就是每增加一个产品，则必须增加一个具体产品实现和一个具体工厂实现，增加了系统复杂度")


debugPrint("------------------ 抽象工厂 ----------------")
/// 抽象产品：定义host协议
protocol Service2 {
    var url: String { get }
}
/// 抽象产品：定义path协议
protocol Path2 {
    var path: String { get }
}

/// 具体产品：开发服务
struct DevService2: Service2 {
    var url: String { return "https://dev.host/" }
}
/// 具体产品：开发路径
struct DevPath2: Path2 {
    var path: String { return "test/" }
}
/// 具体产品：发布服务
struct RelServicee2: Service2 {
    var url: String { return "https://rel.host/" }
}
/// 具体产品：发布路径
struct RelPath2: Path2 {
    var path: String { return "release/" }
}

/// 抽象工厂
protocol RequestFactory {
    func createService2() -> Service2
    func createPath2() -> Path2
}

/// 具体工厂
struct DevFactory: RequestFactory {
    func createService2() -> Service2 { return DevService2() }
    func createPath2() -> Path2 { return DevPath2() }
}
/// 具体工厂
struct RelFactory: RequestFactory {
    func createService2() -> Service2 { return RelServicee2() }
    func createPath2() -> Path2 { return  RelPath2() }
}

let dev = DevFactory()
debugPrint(dev.createService2().url + dev.createPath2().path)

debugPrint("抽象工厂：抽象工厂是工厂方法的升级版，主要用于解决一类产品的实现。工厂方法里一个工厂只能创建一个具体的产品，而抽象工厂则能创建一类类型的多种具体产品。抽象工厂增加新的产品")
