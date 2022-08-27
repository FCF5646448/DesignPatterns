import UIKit

var greeting = "装饰器模式"

protocol Shape {
    func draw()
}

class Rectangle: Shape {
    func draw() {
        debugPrint("绘制矩形")
    }
}

class Circle: Shape {
    func draw() {
        debugPrint("绘制圆形")
    }
}

/// 装饰器
protocol ShapeBorderDecorator: Shape {
    var shape: Shape { get }
    
    func setBorder(_ color: UIColor)
}

/// 红色边框装饰器
class RedShapeBorderDecorator: ShapeBorderDecorator {
    var shape: Shape
    
    init(_ shape: Shape) {
        self.shape = shape
    }
    
    func setBorder(_ color: UIColor) {
        debugPrint("是红色的边框")
    }
    
    func draw() {
        shape.draw()
        setBorder(.red)
    }
}

/// 绿色边框装饰器
class GreenShapeBorderDecorator: ShapeBorderDecorator {
    var shape: Shape
    
    init(_ shape: Shape) {
        self.shape = shape
        shape.draw()
        setBorder(.red)
    }
    
    func draw() {
        shape.draw()
        setBorder(.green)
    }
    
    func setBorder(_ color: UIColor) {
        debugPrint("是绿色的边框")
    }
}

// 绘制一个单纯的圆
let circle = Circle()
circle.draw()

/// 绘制一个红色把边框的圆
let redCircle = RedShapeBorderDecorator(circle)
redCircle.draw()

// 绘制一个绿色边框的矩形
GreenShapeBorderDecorator(Rectangle()).draw()
