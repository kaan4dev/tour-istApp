import Foundation
import FirebaseFirestore

class UserService
{
    // instances
    static let shared = UserService()

    private let db = Firestore.firestore()
    
    // register user
    func registerUser(user: UserModel, completion: @escaping (Error?) -> Void)
    {
        let userRef = db.collection("users").document(user.id)
        
        let userData: [String: Any] =
        [
            "id": user.id,
            "name": user.name,
            "email": user.email,
            "phoneNumber": user.phoneNumber,
            "gender": user.gender.rawValue,
            "password": user.password,
            "userType": user.userType.rawValue,
            "imageURL": user.imageURL ?? "",
            "registrationDate": user.registrationDate,
            "usersPostCount": user.usersPostCount,
            "usersCommentCount": user.usersCommentCount,
            "usersRating": user.usersRating,
            "usersLocation": user.usersLocation,
            "usersDegree": user.usersDegree,
            "knownLanguages": user.knownLanguages,
            "travelHistory": user.travelHistory.map
            {
                travel in
                [
                    "name": travel.name,
                    "dateVisited": travel.dateVisited
                ]
            }
        ]
        
        userRef.setData(userData) { error in
            completion(error)
        }
    }
    
    // get users
    func getUser(userID: String, completion: @escaping (Result<UserModel, Error>) -> Void)
    {
        db.collection("users").document(userID).getDocument
            {
                document, error in
                if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists, let data = document.data()
            else
            {
                completion(.failure(NSError(domain: "UserServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found."])))
                return
            }
            
            // convert Firestore's Timestamp to Date for registrationDate
            let registrationDate = (data["registrationDate"] as? Timestamp)?.dateValue() ?? Date()
            
            // convert Firestore's Timestamp to Date for each dateVisited in travelHistory
            let travelHistory: [Place] = (data["travelHistory"] as? [[String: Any]])?.compactMap
                {
                place in
                guard
                    let name = place["name"] as? String,
                    let timestamp = place["dateVisited"] as? Timestamp
                else
                {
                    return nil
                }
                let dateVisited = timestamp.dateValue()
                return Place(name: name, dateVisited: dateVisited)
            } ?? []
            
            // decode the user data, now with Date conversions
            let user = UserModel(
                id: data["id"] as? String ?? "",
                name: data["name"] as? String ?? "",
                email: data["email"] as? String ?? "",
                phoneNumber: data["phoneNumber"] as? String ?? "",
                registrationDate: registrationDate,
                usersPostCount: data["usersPostCount"] as? Int ?? 0,
                usersCommentCount: data["usersCommentCount"] as? Int ?? 0,
                usersRating: data["usersRating"] as? Int ?? 0,
                password: data["password"] as? String ?? "",
                usersLocation: data["usersLocation"] as? String ?? "",
                usersDegree: data["usersDegree"] as? String ?? "",
                knownLanguages: data["knownLanguages"] as? [String] ?? [],
                gender: Gender(rawValue: data["gender"] as? String ?? "Other") ?? .other,
                travelHistory: travelHistory,
                userType: UserType(rawValue: data["userType"] as? String ?? "tourist") ?? .tourist,
                imageURL: data["imageURL"] as? String
            )
            
            completion(.success(user))
        }
    }
}
