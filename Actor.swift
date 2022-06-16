import SwiftUI

class Counter1 {
    var val: Int = 0
    
    func increment() {
        val = val + 1
        print(val)
    }
}

struct Counter2 {
    var val: Int = 0
    
    mutating func increment() {
        val = val + 1
        print(val)
    }
}

actor Counter3 {
    var val: Int = 0
    
    func increment() {
        val = val + 1
        print(val)
    }
}

struct Actor: View {
    let counter1 = Counter1()
    
    private func func1() {
        DispatchQueue.concurrentPerform(iterations: 100) { _ in
            counter1.increment()
        }
    }
    
    // struct
    @State private var counter2: Counter2 = Counter2()
    private func func2() {
        DispatchQueue.concurrentPerform(iterations: 100) { _ in
            counter2.increment()
        }
    }
    
    // actor
    private let counter3: Counter3 = Counter3()
    private func func3() {
        DispatchQueue.concurrentPerform(iterations: 100) { _ in
            // suspension
            Task { await counter3.increment() }
        }
    }
    
    var body: some View {
        VStack {
            Button { func1() }label: { Text("class") }
            Button { func2() }label: { Text("struct") }
            Button { func3() }label: { Text("actor") }
        }
    }
}

struct foo_Previews: PreviewProvider {
    static var previews: some View {
        Actor()
    }
}
