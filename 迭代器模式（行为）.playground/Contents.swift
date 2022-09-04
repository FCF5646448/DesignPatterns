import UIKit

var greeting = "Hello, 迭代器"

class Tree<T> {
    var value: T
    var left: Tree<T>?
    var right: Tree<T>?
    
    init(_ value: T) {
        self.value = value
    }
    
    typealias Block = (T) -> ()
    
    enum IteraionType {
        case inOrder
        case preOrder
        case postOrder
    }
    
    func iterator(_ type: IteraionType) -> AnyIterator<T> {
        var item = [T]()
        switch type {
        case .inOrder:
            inOrder { item.append($0) }
        case .preOrder:
            preOrder { item.append($0) }
        case .postOrder:
            postOrder { item.append($0) }
        }
        
        return AnyIterator(item.makeIterator())
    }
    
    private func inOrder(_ body: Block) {
        left?.inOrder(body)
        body(value)
        right?.inOrder(body)
    }
    
    private func preOrder(_ body: Block) {
        body(value)
        left?.preOrder(body)
        right?.preOrder(body)
    }
    
    private func postOrder(_ body: Block) {
        left?.postOrder(body)
        right?.postOrder(body)
        body(value)
    }
}

func clientCode<T>(iterator: AnyIterator<T>) {
    while case let item? = iterator.next() {
        print(item)
    }
}

let tree = Tree(1)
tree.left = Tree(2)
tree.right = Tree(3)

print("Tree traversal: Inorder")
clientCode(iterator: tree.iterator(.inOrder))

print("\nTree traversal: Preorder")
clientCode(iterator: tree.iterator(.preOrder))

print("\nTree traversal: Postorder")
clientCode(iterator: tree.iterator(.postOrder))
