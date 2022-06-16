import Foundation

@MainActor
class ViewModel: ObservableObject {
    private var service: Service = Service()
    
    @Published var images: [ImageViewModel] = []
    
    func getImages(ids: [Int]) async throws {
        do {
//          let getImages = try await service.getImages(ids: ids)
//          self.images = getImages.map(ImageViewModel.init)
            
//          show images immediately
            try await withThrowingTaskGroup(of: ImageModel.self, body: { group in
                for id in ids {
                    group.addTask{ [self] in
                        return try await service.getImage(id: id)
                    }
                }

                for try await model in group {
                    images.append(ImageViewModel(model: model))
                }
            })
        } catch {
            print(error)
        }
    }
}

