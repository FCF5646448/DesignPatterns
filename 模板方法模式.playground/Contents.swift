import UIKit

var greeting = "Hello, 模板方法模式"

protocol Garden {
    func prepareSoil()
    func plantSends()
    func waterPlants()
    func prepareGarden()
}

extension Garden {
    func prepareGarden() {
        prepareSoil()
        plantSends()
        waterPlants()
    }
}

final class RoseGarden: Garden {
    func prepare() {
        prepareGarden()
    }
    
    func prepareSoil() {
        debugPrint("prepare soil for rose garden")
    }
    
    func plantSends() {
        debugPrint("plant sends for rose garden")
    }
    
    func waterPlants() {
        debugPrint("water the rose gardan")
    }
}

RoseGarden().prepare()
