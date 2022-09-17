import UIKit

var greeting = "观察者模式"

// 观察者
protocol Observer: AnyObject {
    var idtifior: String { get }
    func update(subject: State)
}

extension Observer {
    var idtifior: String { return "\(Self.self)" }
}

/// 待观察的状态
protocol State: AnyObject {
    var state: Int { get set }
}

/// 发布者
class Subjuct: State {
    var state: Int = Int(arc4random_uniform(10))
    
    private lazy var observers = [Observer]()
    
    func attach(_ observer: Observer) {
        observers.append(observer)
    }
    
    func detach(_ observer: Observer) {
        if let idx = observers.firstIndex(where: { $0.idtifior == observer.idtifior }) {
            observers.remove(at: idx)
        }
    }
    
    func notify() {
        observers.forEach({ $0.update(subject: self) })
    }
    
    func someBussinessLogic() {
        state = Int(arc4random_uniform(10))
        
        notify()
    }
}

// 观察者A
class ObbserverA: Observer {
    func update(subject: State) {
        if subject.state < 3 {
            print("ObbserverA reacted to the event: state = \(subject.state)")
        }
    }
}

// 观察者B
class ObbserverB: Observer {
    func update(subject: State) {
        if subject.state >= 3 {
            print("ObbserverB reacted to the event: state = \(subject.state)")
        }
    }
}

class Test {
    func test() {
        let subject = Subjuct()
        subject.attach(ObbserverA())
        subject.attach(ObbserverB())
        
        subject.someBussinessLogic()
        subject.someBussinessLogic()
        subject.someBussinessLogic()
        subject.someBussinessLogic()
    }
}

Test().test()


protocol ObserverWrapper {
    var value: AnyObject? { get }
    func set(observer value: AnyObject)
}

/// 分发中心
class ObserverCenter {
    // 弱引用
    private class WeakObjectWrapper: ObserverWrapper {
        private(set) weak var value: AnyObject?
        func set(observer value: AnyObject) {
            self.value = value
        }
    }
    
    // 强引用
    private class StrongObjectWrapper: ObserverWrapper {
        private(set) var value: AnyObject?
        func set(observer value: AnyObject) {
            self.value = value
        }
    }
    
    private var observerWrappers = [ObjectIdentifier: ObserverWrapper]()
    
    func add(observer: AnyObject) {
        let wrapper = WeakObjectWrapper()
        wrapper.set(observer: observer)
        let identifier = ObjectIdentifier(observer)
        observerWrappers[identifier] = wrapper
    }
    
    func addStrong(observer: AnyObject) {
        let wrapper = StrongObjectWrapper()
        wrapper.set(observer: observer)
        let identifier = ObjectIdentifier(observer)
        observerWrappers[identifier] = wrapper
    }
    
    func clear() {
        observerWrappers.removeAll()
    }
    
    var observers: [ObjectIdentifier: AnyObject] {
        return Dictionary(uniqueKeysWithValues: observerWrappers.map { (key, value) in
            return (key, value.value)
        }).compactMapValues { $0 }
    }
    
    func forEachObserver(_ block: (_ key: ObjectIdentifier, _ value: AnyObject) -> Void) {
        observers.forEach { item in
            block(item.key, item.value)
        }
    }
}

// 使用 账号登录登出的监听

protocol AccountObserver: AnyObject { }

protocol AccountLoginObserver: AccountObserver {
    func loginSuccess(_ context: String)
}

protocol AccountLogoutObserver: AccountObserver {
    func logoutSuccess(_ context: String)
}

class Account {
    static let share = Account()
    let observerCenter = ObserverCenter()
    
    func login(completion: ((_ success: Bool) -> Void)? = nil) {
        observerCenter.forEachObserver { key, value in
            if let observer = value as? AccountLoginObserver {
                observer.loginSuccess("")
            }
        }
    }
    
    func logout(completion: ((_ success: Bool) -> Void)? = nil) {
        observerCenter.forEachObserver { key, value in
            if let observer = value as? AccountLogoutObserver {
                observer.logoutSuccess("")
            }
        }
    }
    
    static func loginAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            print("模拟登录")
            share.login { _ in
                print("模拟登录成功")
            }
        }
    }
    
    static func logoutAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            print("模拟登出")
            share.logout { _ in
                print("模拟登出成功")
            }
        }
    }
    
    static func addObserver(_ observer: AccountObserver) {
        share.observerCenter.addStrong(observer: observer)
    }
}

class SceneALogin: AccountLoginObserver {
    func loginSuccess(_ context: String) {
        print("SceneALogin receive login success")
    }
}

class SceneBLogin: AccountLoginObserver {
    func loginSuccess(_ context: String) {
        print("SceneBLogin receive login success")
    }
}

class SceneALogout: AccountLogoutObserver {
    func logoutSuccess(_ context: String) {
        print("SceneALogout receive logout success")
    }
}

class Test2 {
    func test() {
        Account.addObserver(SceneALogin())
        Account.addObserver(SceneBLogin())
        Account.addObserver(SceneALogout())
        
        Account.loginAction()
        Account.logoutAction()
    }
}

Test2().test()
