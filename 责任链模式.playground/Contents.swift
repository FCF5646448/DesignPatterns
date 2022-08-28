import UIKit
import Darwin

var greeting = "责任链模式"

protocol Handler: AnyObject {
    @discardableResult
    func setNext(handler: Handler) -> Handler
    
    func handle(request: String) -> String?
    
    var nextHandler: Handler? { get set}
}

extension Handler {
    func setNext(handler: Handler) -> Handler {
        self.nextHandler = handler
        
        return handler
    }
    
    func handle(request: String) -> String? {
        return nextHandler?.handle(request: request)
    }
}

class MonkeyHandler: Handler {
    var nextHandler: Handler?
    
    func handle(request: String) -> String? {
        if request == "Banana" {
            return "Monkey: I'll eat the" + request + ".\n"
        }
        return nextHandler?.handle(request: request)
    }
}

class SquirrelHandler: Handler {
    var nextHandler: Handler?
    
    func handle(request: String) -> String? {
        if request == "Nut" {
            return "Squirrel: I'll eat the" + request + ".\n"
        }
        return nextHandler?.handle(request: request)
    }
}

class DogHandler: Handler {
    var nextHandler: Handler?
    
    func handle(request: String) -> String? {
        if request == "MeatBall" {
            return "Dog: I'll eat the" + request + ".\n"
        }
        return nextHandler?.handle(request: request)
    }
}

class Client {
    func test() {
        let monkey = MonkeyHandler()
        let squirrel = SquirrelHandler()
        let dog = DogHandler()
        
        monkey.setNext(handler: squirrel).setNext(handler: dog)
        
        print("Chain: Monkey > Squirrel > Dog\n\n")
        someClientCode(handler: monkey)
        print()
        print("Subchain: Squirrel > Dog\n\n")
        someClientCode(handler: squirrel)
    }
    
    func someClientCode(handler: Handler) {
        let foods = ["Nut", "Banana", "coffee"]
        
        for food in foods {
            print("Client: Who wants a " + food + "?\n")
            guard let result = handler.handle(request: food) else {
                print("  " + food + " was left untouched.\n")
                return
            }
            print("  " + result)
        }
    }
}

Client().test()
