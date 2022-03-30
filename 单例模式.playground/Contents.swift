import UIKit

class Singleton {
    static let share = Singleton()
    private init() {}
}

let test1 = Singleton.share
let test2 = Singleton.share
debugPrint(test1 === test2 ? "一样": "不一样")

/// 可销毁的单例
class Singleton2 {
    private static var instance: Singleton2?
    static var share: Singleton2 {
        guard let share = self.instance else {
            let newInstance = Singleton2()
            self.instance = newInstance
            return newInstance
        }
        return share
    }
    
    static func destroy() {
        instance = nil
        debugPrint(instance == nil ? "销毁了": "未销毁")
    }
}

let test3 = Singleton2.share
let test4 = Singleton2.share
debugPrint(test3 === test4 ? "一样": "不一样")
Singleton2.destroy()
