import UIKit

var greeting = "Hello, 中介者模式"

/// 定义一个New
struct News: Equatable {
    let id: Int
    let title: String
    var likeCount: Int
    
    static func ==(lhs: News, rhs: News) -> Bool {
        return lhs.id == rhs.id
    }
}

/// 中介者
protocol LikeUpdatable: AnyObject {
    /// 每个场景都有唯一的id
    var identifier: String { get }
    
    /// 每个场景都监听其他场景发出的点赞消息
    func likeAdded(to news: News)
    
    /// 接收其他场景发出的取消点赞消息
    func likeRemoved(from news: News)
}

extension LikeUpdatable {
    var identifier: String {
        return "\(type(of: Self.self))"
    }
}

/// 点赞中介者
class LikeMeditor: LikeUpdatable {
    private var scenes: [LikeUpdatable] = []
    
    /// 注册场景
    func registerScenes(scene: LikeUpdatable) {
        scenes.append(scene)
    }
    
    /// 移除场景
    func removeScenes(scene: LikeUpdatable) {
        for (index, item) in scenes.enumerated() where scene.identifier == item.identifier {
            scenes.remove(at: index)
            return
        }
    }
    
    /// 某一个场景触发点赞会调用这个方法，然后这个方法给每个场景发送点赞消息
    func likeAdded(to news: News) {
        scenes.forEach({ $0.likeAdded(to: news) })
    }
    
    /// 某一个场景触发取消点赞会调用这个方法，然后这个方法给每个场景发送取消点赞消息
    func likeRemoved(from news: News) {
        scenes.forEach({ $0.likeRemoved(from: news) })
    }
}

/// 使用场景
class NewsFeedVC: LikeUpdatable {
    private var newsArr: [News] = []
    private weak var meditor: LikeMeditor?
    
    init(_ meditor: LikeMeditor?, _ newsArr: [News]) {
        self.meditor = meditor
        self.newsArr = newsArr
    }
    
    /// 接收到点赞，更新数据
    func likeAdded(to news: News) {
        for (index, item) in newsArr.enumerated() where item == news {
            var newNews = item
            newNews.likeCount += 1
            self.newsArr[index] = newNews
            debugPrint("NewsFeed receive a liked news with id: \(newNews.id) count: \(newNews.likeCount)")
        }
    }
    
    /// 接收到取消点赞，更新消息
    func likeRemoved(from news: News) {
        for (index, item) in newsArr.enumerated() where item == news {
            var newNews = item
            newNews.likeCount -= 1
            self.newsArr[index] = newNews
            debugPrint("NewsFeed receive a unliked news with id: \(newNews.id) count: \(newNews.likeCount) ")
        }
    }
    
    /// 当前场景触发点赞（对每个news都进行点赞，实际场景应该只有一个news）
    func liketnClicked() {
        debugPrint("NewsFeed liketnClicked")
        newsArr.forEach({ meditor?.likeAdded(to: $0) })
    }
    
    /// 当前场景触发取消点赞（对每个news都进行取消点赞，实际场景应该只有一个news）
    func unlikeClicked() {
        debugPrint("NewsFeed unlikeClicked")
        newsArr.forEach({ meditor?.likeRemoved(from: $0) })
    }
}

class NewsDetailVC: LikeUpdatable {
    private var news: News
    private weak var meditor: LikeMeditor?
    
    init(_ meditor: LikeMeditor?, _ news: News) {
        self.meditor = meditor
        self.news = news
    }
    
    func likeAdded(to news: News) {
        guard news == self.news else {
            return
        }
        self.news.likeCount += 1
        debugPrint("NewsDetail receive a liked news with id: \(self.news.id) count: \(self.news.likeCount) ")
    }
    
    func likeRemoved(from news: News) {
        guard news == self.news else {
            return
        }
        self.news.likeCount -= 1
        debugPrint("NewsDetail receive a unliked news with id: \(self.news.id) count: \(self.news.likeCount) ")
    }
    
    func liketnClicked() {
        debugPrint("NewsDetail liketnClicked")
        meditor?.likeAdded(to: self.news)
    }
    
    func unlikeClicked() {
        debugPrint("NewsDetail unlikeClicked")
        meditor?.likeRemoved(from: self.news)
    }
}

class CommandVC: LikeUpdatable {
    private var numOfGivenLikes: Int
    
    init(_  numOfGivenLikes: Int) {
        self.numOfGivenLikes = numOfGivenLikes
    }
    
    func likeAdded(to news: News) {
        numOfGivenLikes += 1
        debugPrint("CommandVC receive a liked news with numOfGivenLikes:\(numOfGivenLikes) ")
    }
    
    func likeRemoved(from news: News) {
        self.numOfGivenLikes -= 1
        debugPrint("CommandVC receive a unliked news with numOfGivenLikes:\(numOfGivenLikes)")
    }
}

/// 使用
class Test {
    func test() {
        let newsArr = [News(id: 1, title: "News1", likeCount: 1),
                       News(id: 2, title: "News2", likeCount: 2)]
        let numOfGivenLikes = newsArr.reduce(0, { $0 + $1.likeCount })
        let mediator = LikeMeditor()
        let feedVC = NewsFeedVC(mediator, newsArr)
        let newDetail = NewsDetailVC(mediator, newsArr.first!)
        let commandVC = CommandVC(numOfGivenLikes)
        
        mediator.registerScenes(scene: feedVC)
        mediator.registerScenes(scene: newDetail)
        mediator.registerScenes(scene: commandVC)
        
        feedVC.liketnClicked()
        newDetail.unlikeClicked()
    }
}

Test().test()
