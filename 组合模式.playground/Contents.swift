import UIKit

var greeting = "组合模式, playground"

debugPrint("----------简单组合模式------------")

protocol Graphic {
    func print()
}

/// 组合节点
struct CompositeG: Graphic {
    private var childGs = [Graphic]()
    
    mutating func add(graphic: Graphic) {
        childGs.append(graphic)
    }
    
    mutating func add(compositeG: CompositeG) {
        childGs.append(compositeG)
    }
    
    func print() {
        childGs.forEach { g in
            g.print()
        }
    }
}

/// 叶子节点
struct LeafG: Graphic {
    func print() {
        debugPrint("LeafG")
    }
}

struct Demo {
    func test() {
        let g0 = LeafG()
        let g1 = LeafG()
        let g2 = LeafG()
        let g3 = LeafG()
        
        var c0 = CompositeG()
        c0.add(graphic: g0)
        c0.add(graphic: g1)
        
        var c1 = CompositeG()
        c1.add(graphic: g2)
        
        var c2 = CompositeG()
        c2.add(graphic: g3)
        c2.add(compositeG: c0)
        c2.add(compositeG: c1)
        
        c2.print()
    }
}

Demo().test() // 无论加多少遍，最终都是只会把叶子节点打印一遍


/*
 iOS中，视图本身就非常符合组合模式的概念。所以如果涉及到对视图的一些操作。可以考试使用组合模式来设计。
 案例：假设给应用换肤：
 * ViewController 需要换背景色
 * UIView需要换背景色
 * UILabel除了背景色还有文本颜色
 * UIButton除了背景色还有title颜色
 */

debugPrint("----------主题------------")
/// 先定制一套主题（与组合无关）
protocol Theme {
    var backgroundColor: UIColor { get }
}

protocol BtnTheme: Theme {
    var textColor: UIColor { get }
    var highlightedColor: UIColor { get }
}

protocol LabelTheme: Theme {
    var textColor: UIColor { get }
}

debugPrint("----------组合模式------------")
// 定义一个协议：组合协议，公有接口
protocol Component {
    // 应用主题
    func accept<T: Theme>(theme: T)
}

// UIView 实现协议
extension UIView: Component {}
// UIView 的默认实现
extension Component where Self: UIView {
    func accept<T: Theme>(theme: T) {
        backgroundColor = theme.backgroundColor
    }
}

// UIViewController 实现协议
extension UIViewController: Component {}
// UIViewController 的默认实现
extension Component where Self: UIViewController {
    func accept<T: Theme>(theme: T) {
        view.accept(theme: theme)
        view.subviews.forEach({ $0.accept(theme: theme) })
    }
}

// UILabel 的默认实现
extension Component where Self: UILabel {
    func accept<T: LabelTheme>(theme: T) {
        backgroundColor = theme.backgroundColor
        textColor = theme.textColor
    }
}

// // UILabel 的默认实现 的默认实现
extension Component where Self: UIButton {
    func accept<T: BtnTheme>(theme: T){
        backgroundColor = theme.backgroundColor
        setTitleColor(theme.textColor, for: .normal)
        setTitleColor(theme.highlightedColor, for: .highlighted)
    }
}


debugPrint("----------使用------------")
/// 实现默认的按钮主题
struct DefaultBtnTheme: BtnTheme {
    var backgroundColor: UIColor = .orange
    var textColor: UIColor = .red
    var highlightedColor: UIColor = .white
    
    var description: String { return "Default Btn Theme" }
}

/// 实现夜间的按钮主题
struct NightBtnTheme: BtnTheme {
    var backgroundColor: UIColor = .black
    var textColor: UIColor = .white
    var highlightedColor: UIColor = .red
    
    var description: String { return "Night Btn Theme" }
}

/// 实现默认的label主题
struct DefaultLabelTheme: LabelTheme {
    var backgroundColor: UIColor = .black
    var textColor: UIColor = .red
    
    var description: String { return "Default Label Theme" }
}

/// 实现默认的label主题
struct NightLabelTheme: LabelTheme {
    var backgroundColor: UIColor = .black
    var textColor: UIColor = .white
    
    var description: String { return "Night Label Theme" }
}

class TestController: UIViewController {
    class ContentView: UIView {
        var titleLabel = UILabel()
        var btn = UIButton()
        
        init() {
            super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            setUp()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setUp() {
            addSubview(titleLabel)
            addSubview(btn)
            
            titleLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
            btn.frame = CGRect(x: 0, y: 100, width: 200, height: 100)
        }
    }
    
    override func loadView() {
        view = ContentView()
    }
}

struct SwiftTheme {
    func apply<T: Theme>(theme: T, for component: Component) {
        component.accept(theme: theme)
    }
    
    func switchTheme(_ isNight: Bool) {
        if isNight {
            apply(theme: NightLabelTheme(), for: TestController())
            apply(theme: NightBtnTheme(), for: TestController())
        } else {
            apply(theme: DefaultLabelTheme(), for: TestController())
            apply(theme: DefaultBtnTheme(), for: TestController())
        }
    }
}
