import UIKit

debugPrint("--------------简单生成器---------------")
struct Theme {
    let textColor: UIColor
    let backgroundColor: UIColor
}
///  简单Theme生成器
struct ThemeBuild {
    enum Style {
        case light
        case dark
    }
    
    func build(_ style: Style) -> Theme {
        switch style {
        case .light:
            return Theme(textColor: .black, backgroundColor: .white)
        case .dark:
            return Theme(textColor: .white, backgroundColor: .black)
        }
    }
}

let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
view.backgroundColor = ThemeBuild().build(.light).backgroundColor
debugPrint(view)

debugPrint("-------------多配置生成器----------------")

class URLBuilder {
    private var components: URLComponents
    init() {
        components = URLComponents()
    }
    
    func set(scheme: String) -> URLBuilder {
        self.components.scheme = scheme
        return self
    }
    
    func set(host: String) -> URLBuilder {
        self.components.host = host
        return self
    }
    
    func set(port: Int) -> URLBuilder {
        self.components.port = port
        return self
    }
    
    func set(path: String) -> URLBuilder {
        var path = path
        if !path.hasPrefix("/") {
            path = "/" + path
        }
        self.components.path = path
        return self
    }
    
    func build() -> URL? {
        return self.components.url
    }
}

let url = URLBuilder().set(scheme: "https").set(host: "localHost").set(path: "api/v1").set(port: 9999).build()
if let urlStr = url?.absoluteString {
    debugPrint(urlStr)
}

debugPrint("-------------主管生成器----------------")

class Car {
    var seats: String?
    var engine: String?
    var gps: String?
    
    var description: String {
        return "car seats:\(seats ?? "") engine:\(engine ?? "") gps:\(gps ?? "")"
    }
}

protocol Builder {
    func reset()
    func setSeats(_ seats: String)
    func setEngine(_ engine: String)
    func setGPS(_ gps: String)
    func getCar() -> Car
}

class CarBuilder: Builder {
    private var car: Car
    
    init() {
        car = Car()
    }
    
    func reset() {
        car = Car()
    }
    
    func setSeats(_ seats: String) {
        car.seats = seats
    }
    
    func setEngine(_ engine: String) {
        car.engine = engine
    }
    
    func setGPS(_ gps: String) {
        car.gps = gps
    }
    
    func getCar() -> Car {
        return car
    }
}

class Director {
    func constructSportsCar(_ builder: Builder) {
        builder.reset()
        builder.setSeats("凳子")
        builder.setEngine("引擎")
        builder.setGPS("GPS")
    }
}

let director = Director()
let builder = CarBuilder()
director.constructSportsCar(builder)
let car = builder.getCar()
debugPrint(car.description)


debugPrint("--------------使用频率高的场景---------------")
// 常见场景
class Model {
    let id: Int
    var name: String?
    var scene: Int?
    var type: String?
    
    init(id: Int) {
        self.id = id
    }
    
    convenience init(id: Int, name: String) {
        self.init(id: id)
        self.name = name
    }
    
    convenience init(id: Int, name: String, scene: Int?) {
        self.init(id: id)
        self.name = name
        self.scene = scene
    }
    
    convenience init(id: Int, name: String, scene: Int?, type: String?) {
        self.init(id: id)
        self.name = name
        self.scene = scene
        self.type = type
    }
}

class Model1 {
    let id: Int
    var name: String?
    var scene: Int?
    var type: String?
    
    required init(id: Int) {
        self.id = id
    }
    
    var description: String {
        return "model1 id:\(id) name:\(name ?? "") scene:\(scene ?? -1) type:\(type ?? "")"
    }
}

/// 使用范型的话，这个Builder可以构造Model1的子类
class Builder1<T: Model1> {
    private let m: T
    required init(_ id: Int) {
        m = T.init(id: id)
    }
    
    func setName(_ name: String?) {
        m.name = name
    }
    
    func setScene(_ scene: Int?) {
        m.scene = scene
    }
    
    func setType(_ type: String?) {
        m.type = type
    }
    
    func build() -> T {
        return m
    }
}

class subModel1: Model1 {}

var builder1 = Builder1<subModel1>.init(1) // Model1
builder1.setName("test")
builder1.setType("生成器")
let result1 = builder1.build()
debugPrint(result1.description)
