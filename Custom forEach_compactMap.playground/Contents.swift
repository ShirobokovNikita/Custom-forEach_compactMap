import UIKit
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

extension Array {
    
    func customForEach(_ body: (Element) -> Void) {
        var iter = 0
        let lock = NSRecursiveLock()
        
        DispatchQueue.concurrentPerform(iterations: self.count) { _ in
            lock.lock()
            body(self[iter])
//            print("index: \(index)")
            iter += 1
            lock.unlock()
        }
//        print("End of Function")
    }
}

extension Array {
    
    // MARK: - Здесь индекс приходит от concurrentPerform
    
    func customCompactMap<T>(_ transform: (Element) -> T?) -> [T] {
        var returnArray = [(Int, T)]()
        var returnValue = [T]()
        
        let lock = NSRecursiveLock()
        DispatchQueue.concurrentPerform(iterations: self.count) { index in
            if let value = transform(self[index]) {
                lock.lock()
                let cortege: (Int, T) = (index, value)
                returnArray.append(cortege)
                lock.unlock()
            }
        }
        let sorted = returnArray.sorted(by: { $0.0 < $1.0 })
        for i in 0..<sorted.count {
            returnValue.append(sorted[i].1)
        }
        return returnValue
    }
    
    // MARK: - Здесь я индекс сам вычисляю, это легально? Ощущение, что я весь смысл этого задания тем самым ломаю
    
    func customCompactMap2<T>(_ transform: (Element) -> T?) -> [T] {
        var iter = 0
        let lock = NSRecursiveLock()
        var returnValue = [T]()
        
        DispatchQueue.concurrentPerform(iterations: self.count) { _ in
            lock.lock()
            if let value = transform(self[iter]) {
                returnValue.append(value)
                iter += 1
                lock.unlock()
            }
        }
        return returnValue
    }
}

var array = ["1", "Two", "3three", "7", "2", "nil", "3", "4"]
var array2 = ["1", "2", "3", "7", "10", "4", "5", "nil"]
var array3 = [2, 3, 5, 7, 11]
var array5 = [Int]()

array3.customForEach { element in
//    print("element: \(element)")
    array5.append(element * 2)
    print(array5)
}

//let array4 = array2.customCompactMap { str in
//    Int(str)
//}
//print(array4)

let array4 = array2.customCompactMap2({ str in
    Int(str)
})
print(array4)

