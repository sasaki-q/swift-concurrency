import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ViewModel()
    
    
    var body: some View {
        NavigationView{
            List(vm.images) { elm in
                HStack {
                    // map → unwrap
                    elm.image.map{
                        Image(uiImage: $0).resizable().aspectRatio(contentMode: .fit)
                    }
                    Text(elm.title)
                }
            }.task {
                do {
                    try await vm.getImages(ids: Array(100...120))
                } catch {
                    print(error)
                }
            }
            .navigationTitle("image app")
            .navigationBarItems(trailing: Button(action: {
                Task {
                    try await vm.getImages(ids: Array(100...120))
                }
            }, label: {Image(systemName: "arrow.clockwise.circle")}))
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
