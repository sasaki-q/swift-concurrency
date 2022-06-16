import Foundation
import UIKit

// Data → byte
struct ImageModel: Decodable {
    let image: Data
    let title: Title
}

struct Title: Decodable {
    let content: String
}

struct ImageViewModel: Identifiable {
    let id = UUID()
    let model: ImageModel
    
    var image: UIImage? { UIImage(data: model.image) }
    var title: String { model.title.content }
}
