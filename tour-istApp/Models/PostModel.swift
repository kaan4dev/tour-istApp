import Foundation

struct PostModel: Identifiable, Codable
{
    let id: String
    var title: String
    var description: String
    var ownerID: String
    var date: Date
    var location: String
    var isActive: Bool
    var price: Double
    var imageURL: String?
}

