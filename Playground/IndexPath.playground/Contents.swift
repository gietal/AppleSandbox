//: Playground - noun: a place where people can play

import Foundation

public extension IndexPath {
    public func index(atPosition idx: Int) -> Element? {
        if idx < 0 || idx >= self.count {
            return nil
        }
        return self[idx]
    }
    
    func indexPathByRemovingFirst() -> IndexPath {
        var newIndexPath = IndexPath()
        
        for index in 1 ..< self.count {
            newIndexPath.append(self.index(atPosition: index)!)
        }
        return newIndexPath
    }

}
let index = IndexPath(indexes: [1, 2, 3, 4])

print(index)
print(index[3])
print(index.index(atPosition: 4))

print(index.indexPathByRemovingFirst())

