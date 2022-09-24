import UIKit

var greeting = "状态模式"
// 番茄工作状态：闲时、工作、短休息、长休息
protocol StateType: Hashable {}
protocol EventType: Hashable {}
/// 封装一个状态转移结构体
struct Transition<S: StateType, E: EventType> {
    let event: E
    let fromState: S
    let toState: S
    
    init(event: E, fromState: S, toState: S) {
        self.event = event
        self.fromState = fromState
        self.toState = toState
    }
}

/// 状态机
class StateMachine<S: StateType, E: EventType> {
    // 将回调和转移进行绑定
    private struct Operation<S: StateType, E: EventType> {
        let transition: Transition<S, E>
        let triggerCallBack: (Transition<S, E>) -> Void
    }
    
    private var routes = [S: [E: Operation<S, E>]]()
    private(set) var currentState: S
    private(set) var lastState: S? // 上一次状态
    
    init(_ initialState: S) {
        self.currentState = initialState
    }
    
    // 状态分发，可能多个转态触发转移事件
    func listen(_ event: E, transit fromStates: [S], to toState: S, callback: @escaping (Transition<S, E>) -> Void) {
        fromStates.forEach {
            listen(event, transit: $0, to: toState, callback: callback)
        }
    }
    
    /// 监听
    func listen(_ event: E,
                transit fromState: S,
                to toState: S,
                callback: @escaping (Transition<S, E>) -> Void) {
        var route = routes[fromState] ?? [:]
        let transition = Transition(event: event, fromState: fromState, toState: toState)
        let operation = Operation(transition: transition, triggerCallBack: callback)
        route[event] = operation
        routes[fromState] = route
    }
    
    func trigger(_ event: E) {
        guard let route = routes[currentState]?[event] else { return }
        route.triggerCallBack(route.transition)
        lastState = currentState
        currentState = route.transition.toState
    }
}


enum State: StateType {
    case idle // 空闲
    case work // 工作
    case shortBreak // 短休息
    case longBreak // 长休息
    
    var name: String {
        return "\(self.hashValue)"
    }
}

enum Event: EventType {
    case startWork // 开始工作
    case startShortBreak // 开始短休息
    case startLongBreak // 开始长休息
    case backToIdle // 回归空闲
    
    var name: String {
        return "\(self.hashValue)"
    }
}

/// 状态模式 demo2
final class Context {
    private var state: State2 = UnauthorizedState()
    
    var isAuthorized: Bool {
        return state.isAuthorized(context: self)
    }
    
    var userId: String? {
        return state.unserId(context: self)
    }
    
    func changeStateToAuthorized(_ userId: String) {
        state = AuthorizedState(userId)
    }
    
    func changeStateToUnauthorized() {
        state = UnauthorizedState()
    }
}


protocol State2 {
    func isAuthorized(context: Context) -> Bool
    
    func unserId(context: Context) -> String?
}

class AuthorizedState: State2 {
    let userId: String
    
    init(_ userId: String) { self.userId =  userId }
    
    func isAuthorized(context: Context) -> Bool { return true }
    
    func unserId(context: Context) -> String? { return userId }
}

class UnauthorizedState: State2 {
    func isAuthorized(context: Context) -> Bool { return false }
    
    func unserId(context: Context) -> String? { return nil }
}


class Test {
    func test() {
        let stateMachine = StateMachine<State, Event>(.idle)
        stateMachine.listen(.startWork, transit: .idle, to: .work) { t in
            debugPrint("\(t.fromState) 触发了 \(t.event), 状态变更成了 \(t.toState)")
        }
        
        stateMachine.listen(.backToIdle, transit: .work, to: .idle) { t in
            debugPrint("\(t.fromState) 触发了 \(t.event), 状态变更成了 \(t.toState)")
        }
        
        stateMachine.listen(.startShortBreak, transit: .work, to: .shortBreak) { t in
            debugPrint("\(t.fromState) 触发了 \(t.event), 状态变更成了 \(t.toState)")
        }
        
        stateMachine.listen(.startLongBreak, transit: .work, to: .longBreak) { t in
            debugPrint("\(t.fromState) 触发了 \(t.event), 状态变更成了 \(t.toState)")
        }
        
        
        stateMachine.trigger(.startWork)
        
        stateMachine.trigger(.startShortBreak)
        
        
        debugPrint("状态模式 demo2")
        let userContext = Context()
        debugPrint("用户 isauthorized: \(userContext.isAuthorized), uid: \(userContext.userId ?? "nil")")
        userContext.changeStateToAuthorized("admin")
        debugPrint("用户 isauthorized: \(userContext.isAuthorized), uid: \(userContext.userId ?? "nil")")
        userContext.changeStateToUnauthorized()
        debugPrint("用户 isauthorized: \(userContext.isAuthorized), uid: \(userContext.userId ?? "nil")")
    }
}

Test().test()
