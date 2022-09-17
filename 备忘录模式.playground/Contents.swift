import UIKit

var greeting = "Hello, 备忘录模式"

/// 实现文本编辑器的恢复功能

/// 备忘录协议，定义将要存储的东西，将具体的的存储放到具体的类本身中。
protocol Memento {}

/// 具体要存储的Model，与具体的业务场景对应。也可以与具体业务放到一起，这个类不一定有实际作用。
class ConcreteMemento: Memento {
    private(set) var state: String
    private(set) var date: Date
    
    init(state: String) {
        self.state = state
        self.date = Date()
    }
}

/// 具体业务场景，实现具体的存储方法，也接收回撤的存储记录
class Client {
    private var state: String
    
    init(state: String) {
        self.state = state
        debugPrint("Client init state:\(state)")
    }
    
    func changedState() {
        state = String(UUID().uuidString.suffix(4))
    }
    
    /// 返回需要存储的对象
    func save() -> Memento {
        debugPrint("Client save state:\(state)")
        return ConcreteMemento(state: state)
    }
    
    /// 回撤到上一步
    func restore(memento: Memento) {
        guard let memento = memento as? ConcreteMemento else {
            return
        }
        self.state = memento.state
        debugPrint("Client state has changed: \(state)")
    }
}

/// 具体进行备忘录的类，整合缓存和业务，这里的业务可以进一步抽象一下，这样不同的业务可以统一管理。不过正常的使用中，应该是只有一个业务类。
class Caretaker {
    private lazy var mementos = [Memento]()
    private var client: Client
    init(client: Client) {
        self.client = client
    }
    
    // 备份
    func backup() {
        debugPrint("Caretaker: Saving Client's state")
        mementos.append(client.save())
    }
    
    /// 撤销
    func undo() {
        guard !mementos.isEmpty else {
            return
        }
        let removedMemento = mementos.removeLast()
        client.restore(memento: removedMemento)
    }
}

class Test {
    func test() {
        let client = Client(state: "state")
        let clientCaretaker = Caretaker(client: client)
        
        clientCaretaker.backup()
        client.changedState()
        clientCaretaker.backup()
        client.changedState()
        clientCaretaker.backup()
        client.changedState()
        
        clientCaretaker.undo()
        clientCaretaker.undo()
    }
}

Test().test()


// 配置信息类
struct ConfigFile {
    var versionNo: String
    var content: String
    var dateTime: Date
    var operat: String
}

// 备忘录类
class ConfigMemento {
    private var _cofigFile: ConfigFile
    var cofigFile: ConfigFile {
        get {
            return _cofigFile
        }
        set {
            _cofigFile = newValue
        }
    }
    
    init(_ cofigFile: ConfigFile) {
        self._cofigFile = cofigFile
    }
    
    func jsonString() -> String {
        return "{versionNo:\(_cofigFile.versionNo); content: \(_cofigFile.content), dateTime:\(_cofigFile.dateTime), operat:\(_cofigFile.operat)}"
    }
}

class Admin {
    var cursorIdx = 0
    private var list = [ConfigMemento]()
    private var map = [String: ConfigMemento]()
    
    // 新增版本
    func append(_ memento: ConfigMemento) {
        list.append(memento)
        map[memento.cofigFile.versionNo] = memento
        cursorIdx += 1
    }
    
    // 回滚版本
    func undo() -> ConfigMemento? {
        cursorIdx -= 1
        if cursorIdx <= 0 {
            return list.first
        }
        return list[cursorIdx]
    }
 
    // 前进历史配置
    func redo() -> ConfigMemento? {
        cursorIdx += 1
        if cursorIdx >= list.count {
            return list.last
        }
        
        return list[cursorIdx]
    }
    
    func get(_ versionNo: String) -> ConfigMemento? {
        return map[versionNo]
    }
}

class NewTest {
    func test() {
        let admin = Admin()
        
        admin.append(ConfigMemento(ConfigFile(versionNo: "10001", content: "配置内容1", dateTime: Date(), operat: "ethan")))
        
        admin.append(ConfigMemento(ConfigFile(versionNo: "10002", content: "配置内容2", dateTime: Date(), operat: "ethan")))
        
        admin.append(ConfigMemento(ConfigFile(versionNo: "10003", content: "配置内容3", dateTime: Date(), operat: "ethan")))
        
        admin.append(ConfigMemento(ConfigFile(versionNo: "10004", content: "配置内容4", dateTime: Date(), operat: "ethan")))
        
        
        let json = admin.undo()?.jsonString()
        print("回滚：\(json ?? "")")
        
        let json2 = admin.undo()?.jsonString()
        print("回滚：\(json2 ?? "")")
        
        
        let json3 = admin.redo()?.jsonString()
        print("前进：\(json3 ?? "")")
        
        let json4 = admin.redo()?.jsonString()
        print("前进：\(json4 ?? "")")
        
        let json5 = admin.get("10002")?.jsonString()
        print("获取：\(json5 ?? "")")
    }
}

NewTest().test()
