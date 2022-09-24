import UIKit
import Foundation

var greeting = "Hello, 访问者模式"

protocol Place {
    func visitor(boss: Boss)
    
    func visitor(employee: Employee)
}

protocol Visitor {
    func accept(visitor: Place)
}

class Boss: Visitor {
    func accept(visitor: Place) {
        visitor.visitor(boss: self)
    }
}

class Employee: Visitor {
    func accept(visitor: Place) {
        visitor.visitor(employee: self)
    }
}


class House: Place {
    func visitor(boss: Boss) {
        debugPrint("老板在家工作")
    }
    
    func visitor(employee: Employee) {
        debugPrint("员工在家看电视")
    }
}

class Office: Place {
    func visitor(boss: Boss) {
        debugPrint("老板在公司划水")
    }
    
    func visitor(employee: Employee) {
        debugPrint("员工在公司加班")
    }
}

let boss = Boss()
let employee = Employee()
let hourse = House()
let office = Office()
boss.accept(visitor: hourse)
boss.accept(visitor: office)

employee.accept(visitor: hourse)
employee.accept(visitor: office)


