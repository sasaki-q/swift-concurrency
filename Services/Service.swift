//
//  Service.swift
//  ImageApp
//
//  Created by Teppei Sasaki on 2022/06/16.
//

import Foundation

enum MyError: Error {
    case first
    case second
    case third
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
    
    func gerImages(ids: [Int]) async throws -> [RandomImage] {
        var images: [RandomImage] = []
        
        for id in ids {
            let image = try await getImage(id: id)
            images.append(image)
        }
        
        return images
    }
    
    private func getImage(id: Int) async throws -> RandomImage {
        guard let imageUrl = Constants.getImageUrl() else { throw MyError.first }
        guard let quoteUrl = Constants.getQuoteUrl else { throw MyError.first }
        
        
        /**
         
             ※ Not Concurrency
             let (imageRes, _) = try await session.data(from: imageUrl)
             let (quoteRes, _) = try await session.data(from: quoteUrl)
             
             guard let quote = try? decoder.decode(Quote.self, from: quoteRes) else {
                 throw MyError.second
             }
         
         */
        
        // Concurrency
        async let (imageRes, _) = session.data(from: imageUrl)
        async let (quoteRes, _) = session.data(from: quoteUrl)
        
        guard let quote = try? decoder.decode(Quote.self, from: try await quoteRes) else {
            throw MyError.second
        }
        
        return RandomImage(image: try await imageRes, quote: quote)
    }
}

