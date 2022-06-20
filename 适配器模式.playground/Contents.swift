import UIKit

debugPrint("-------------适配器模式------------")

struct OldTarget {
    let width: Float
    let height: Float
    
    init(width: Float, height: Float) {
        self.width = width
        self.height = height
    }
}

// 构建一个协议
protocol TargetProtocol {
    var width: Float { get }
    var height: Float { get }
}

/// 新target持有旧target
struct NewTarget: TargetProtocol {
    private let oldTarget: OldTarget
    
    var width: Float {
        return oldTarget.width
    }
    
    var height: Float {
        return oldTarget.height
    }
    
    init(_ target: OldTarget) {
        self.oldTarget = target
    }
}

let target = OldTarget(width: 32.0, height: 32.0)
let newFormat = NewTarget(target)
debugPrint(newFormat.width, newFormat.height)
