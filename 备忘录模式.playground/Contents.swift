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



