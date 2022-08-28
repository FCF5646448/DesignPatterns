import UIKit

var greeting = "享元模式"

/// view重用池
class ViewReusePool {
    // 使用中的池子
    private var usingViewsSet = Set<UIView>()
    // 缓存池子
    private var poolViewSet = Set<UIView>()
    
    // 从缓存池中取一个View
    func dequeueReusableView() -> UIView {
        if let view = poolViewSet.popFirst() {
            usingViewsSet.insert(view)
            return view
        } else {
            let newView = UIView(frame: .zero)
            usingViewsSet.insert(newView)
            return newView
        }
    }
    
    // 重置池子
    func resetPool() {
        while let view = usingViewsSet.popFirst() {
            poolViewSet.insert(view)
        }
    }
}
