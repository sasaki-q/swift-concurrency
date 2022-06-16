import Foundation

enum MyError: Error {
    case invalidUrl
    case decodeError
}

struct Constants {
    static func getImageUrl() -> URL? {
        return URL(string: "https://picsum.photos/200/300?uuid=\(UUID().uuidString)")
    }
    
    static let getQuoteUrl: URL? = URL(string: "https://api.quotable.io/random")
}

class Service {
    var session: URLSession = URLSession.shared
    var decoder: JSONDecoder = JSONDecoder()
    
    func getImages(ids: [Int]) async throws -> [ImageModel] {
        var images: [ImageModel] = []
        
//        for id in ids {
//            let image = try await getImage(id: id)
//            images.append(image)
//        }
        
        try await withThrowingTaskGroup(of: (Int, ImageModel).self, body: { group in
            for id in ids {
                group.addTask{ [self] in
                        return (id, try await getImage(id: id))
                }
            }

            for try await (_, image) in group {
                images.append(image)
            }
        })
        
        return images
    }
    
    func getImage(id: Int) async throws -> ImageModel {
        guard let imageUrl = Constants.getImageUrl() else { throw MyError.invalidUrl }
        guard let quoteUrl = Constants.getQuoteUrl else { throw MyError.invalidUrl }
        
//        let (imageRes, _) = try await session.data(from: imageUrl)
//        let (quoteRes, _) = try await session.data(from: quoteUrl)
//
//        guard let quote = try? decoder.decode(Quote.self, from: quoteRes) else {
//            throw MyError.second
//        }
//
//        return ImageModel(image: imageRes, quote: quote)

        
        async let (imageRes, _) = session.data(from: imageUrl)
        async let (titleRes, _) = session.data(from: quoteUrl)
        
        guard let title = try? decoder.decode(Title.self, from: try await titleRes) else {
            throw MyError.decodeError
        }
        
        return ImageModel(image: try await imageRes, title: title)
    }
}


