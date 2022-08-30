import UIKit

var greeting = "命令模式"

protocol DoorCommand {
    func execute() -> String
}

final class OpenCommand: DoorCommand {
    let doors:String

    required init(doors: String) {
        self.doors = doors
    }
    
    func execute() -> String {
        return "Opened \(doors)"
    }
}

final class CloseCommand: DoorCommand {
    let doors:String

    required init(doors: String) {
        self.doors = doors
    }
    
    func execute() -> String {
        return "Closed \(doors)"
    }
}

final class HAL9000DoorsOperations {
    let openCommand: DoorCommand
    let closeCommand: DoorCommand
    
    init(doors: String) {
        self.openCommand = OpenCommand(doors:doors)
        self.closeCommand = CloseCommand(doors:doors)
    }
    
    func close() -> String {
        return closeCommand.execute()
    }
    
    func open() -> String {
        return openCommand.execute()
    }
}

let podBayDoors = "Pod Bay Doors"
let doorModule = HAL9000DoorsOperations(doors:podBayDoors)

doorModule.open()
doorModule.close()

//---------------------------------------------
protocol Command {
    func execute()
}

// 一个简单的命令
class SimpleCommand: Command {
    private var payload: String
    
    init(_ payload: String) {
        self.payload = payload
    }
    
    func execute() {
        debugPrint("SimpleCommand: See, I can do simple things like printing (" + payload + ")")
    }
}

// 复杂命令》包含一个接收者。当操作ComplexCommand命令后，就可以操作接收者里的方法
class ComplexCommand: Command {
    private var receiver: Receiver
    private var a: String
    private var b: String
    
    init(_ receiver: Receiver, _ a: String, _ b: String) {
        self.receiver = receiver
        self.a = a
        self.b = b
    }
    
    func execute() {
        debugPrint("ComplexCommand: Complex stuff should be done by a receiver object.\n")
        receiver.doSomething(a)
        receiver.doSomethingElse(b)
    }
}

// 消息接收者
class Receiver {
    func doSomething(_ a: String) {
        debugPrint("Receiver: Working on (" + a + ")\n")
    }
    
    func doSomethingElse(_ b: String) {
        debugPrint("Receiver: alse Working on (" + b + ")\n")
    }
}

/// 调用者
class Invoker {
    private var onStart: Command?
    private var onFinish: Command?
    
    func setOnStart(_ command: Command) {
        onStart = command
    }
    
    func setOnFinish(_ command: Command) {
        onFinish = command
    }
    
    func doSomethingImport() {
        print("Invoker: Does anybody want something done before I begin?")
        
        onStart?.execute()
        
        print("Invoker: ...doing something really important...")
        print("Invoker: Does anybody want something done after I finish?")
        
        onFinish?.execute()
    }
}

let invoker = Invoker()
invoker.setOnStart(SimpleCommand("Say Hi!"))

let receiver = Receiver()
invoker.setOnFinish(ComplexCommand(receiver, "Send email", "Save report"))
invoker.doSomethingImport()
