import Foundation
import FirebaseFirestore

struct UserModel: Codable
{
    let id: String
    let name: String
    let email: String
    let phoneNumber: String
    let registrationDate: Date
    let usersPostCount: Int
    let usersCommentCount: Int
    let usersRating: Int
    let password: String
    let usersLocation: String
    let usersDegree: String
    
    var knownLanguages: [String]
    var gender: Gender
    var travelHistory: [Place]
    var userType: UserType
    var imageURL: String?
}

struct Place: Codable
{
    let name: String
    let dateVisited: Date
}


enum UserType: String, Codable
{
    case tourist = "tourist"
    case guide = "guide"
}

enum Gender: String, Codable
{
    case male = "Male"
    case female = "Female"
    case other = "Other"
}
