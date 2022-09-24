import UIKit

var greeting = "Hello, 策略模式"

protocol DomainModel {
    var id: Int { get }
}

struct User: DomainModel {
    var id: Int
    var username: String
}

protocol DataSource {
    func loadModels<T: DomainModel>() -> [T]
}

class MemoryStoragge<Model>: DataSource {
    private lazy var items = [Model]()
    func add(_ items: [Model]) {
        self.items.append(contentsOf: items)
    }
    
    func loadModels<T>() -> [T] where T : DomainModel {
        guard T.self == User.self else { return [] }
        return items as! [T]
    }
}

class CoreDataStorage: DataSource {
    func loadModels<T>() -> [T] where T : DomainModel {
        guard T.self == User.self else { return [] }
        let firstUser = User(id: 3, username: "username3")
        let secondUser = User(id: 4, username: "username4")
        
        return [firstUser, secondUser] as! [T]
    }
}

class RealmStorage: DataSource {
    func loadModels<T>() -> [T] where T : DomainModel {
        guard T.self == User.self else { return [] }
        let firstUser = User(id: 5, username: "username5")
        let secondUser = User(id: 6, username: "username6")
        
        return [firstUser, secondUser] as! [T]
    }
}

class ListController {
    private var dataSource: DataSource?
    
    func update(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    func displayModels() {
        guard let dataSource = dataSource else {
            return
        }
        let models = dataSource.loadModels() as [User]
        models.forEach({ debugPrint($0) })
    }
}

class Test {
    func test() {
        let controller = ListController()
        let memoryStorage = MemoryStoragge<User>()
        memoryStorage.add(userFromNet())
        clientCode(use: controller, with: memoryStorage)
        clientCode(use: controller, with: CoreDataStorage())
        clientCode(use: controller, with: RealmStorage())
    }
    
    func clientCode(use controller: ListController, with dataSource: DataSource) {
        controller.update(dataSource: dataSource)
        controller.displayModels()
    }
    
    private func userFromNet() -> [User] {
        let firstUser = User(id: 1, username: "username1")
        let secondUser = User(id: 2, username: "username2")
        
        return [firstUser, secondUser]
    }
}

Test().test()


/*
/// 不同的消息类型
enum MessageType: CaseIterable {
    case text
    case image
    case vidio
}

struct MessageModel {
    var type: MessageType
    var content: String // 不同的类型，content对应不同的内容
}

protocol MessageCellItem {
    var identifior: String { get }
    var type: MessageType { get }
    
    func setModel(_ messagge: MessageModel)
}

extension MessageCellItem {
    var identifior: String { return "cell.identify.\(Self.self)" }
//    var cellType: UITableViewCell.Type { return Self.self}
}

struct MessageCellContext {
    var cellItem: MessageCellItem
    var type: MessageType
}

struct TextMessaggeCellItem: MessageCellItem {
    
}

class TextMessageCell: UITableViewCell {
    var type: MessageType { .text }
    
    func setModel(_ messagge: MessageModel) {
        debugPrint("text cell, text: \(messagge.content)")
    }
}

class ImageMessageCell: UITableViewCell, MessageCell {
    var type: MessageType { .image }
    
    func setModel(_ messagge: MessageModel) {
        debugPrint("image cell, url: \(messagge.content)")
    }
}

class VideoMessageCell: UITableViewCell, MessageCell {
    var type: MessageType { .vidio }
    
    func setModel(_ messagge: MessageModel) {
        debugPrint("video cell, url: \(messagge.content)")
    }
}

class ContentView: UIView, UITableViewDataSource {
    let cellTypes: [MessageCellContext] = [MessageCellContext(cell: <#MessageCell#>, type: .text),
                                           MessageCellContext(cell: <#MessageCell#>, type: .image),
                                           MessageCellContext(cell: <#MessageCell#>, type: .vidio)]
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRect.zero)
        for cellItem in cellTypes {
            tableView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellReuseIdentifier: <#T##String#>)
            tableView.register(cellItem.cell.self, forCellReuseIdentifier: cellItem.cell.identifior)
        }
        return tableView
    }()
    
    private var dataSources: [MessageModel] = []
    
    func receiveNewMessage(_ message: MessageModel) {
        dataSources.append(message)
        tableView.performBatchUpdates {
            tableView.insertRows(at: [IndexPath(row: dataSources.count - 1, section: 0)], with: .bottom)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = dataSources[indexPath.row]
        let type = message.type
        guard let cellType = cellTypes.first(where: { $0.type == type }),
              let relCell = tableView.dequeueReusableCell(withIdentifier: cellType.cell.identifior, for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        relCell.setModel(message)
        return relCell
    }
}
*/
