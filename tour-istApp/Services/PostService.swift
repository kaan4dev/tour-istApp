import Foundation
import FirebaseFirestore
import FirebaseAuth

class PostService
{
    //properties
    static let shared = PostService()
    
    //instances
    private var db = Firestore.firestore()
    private var posts: [PostModel] = []
    
    // add post
    func addPost(title: String, description: String, date: Date, location: String, price: Double, imageURL: String?, completion: @escaping (Result<PostModel, Error>) -> Void)
    {
        guard let ownerID = Auth.auth().currentUser?.uid else
        {
            completion(.failure(NSError(domain: "PostServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not log in."])))
            return
        }

        let newPost = PostModel(id: UUID().uuidString, title: title, description: description, ownerID: ownerID, date: date, location: location, isActive: true, price: price, imageURL: imageURL)
        
        do
        {
            let postData = try Firestore.Encoder().encode(newPost)
            db.collection("posts").document(newPost.id).setData(postData)
            {
                error in
                if let error = error
                {
                    completion(.failure(error))
                }
                else
                {
                    self.posts.append(newPost)
                    completion(.success(newPost))
                }
            }
        }
        catch
        {
            completion(.failure(error))
        }
    }
    
    // get posts
    func getPosts(completion: @escaping (Result<[PostModel], Error>) -> Void)
    {
        guard let currentUserID = Auth.auth().currentUser?.uid else
        {
            completion(.failure(NSError(domain: "PostServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı oturumu açmamış."])))
            return
        }
        
        db.collection("posts").whereField("ownerID", isEqualTo: currentUserID).getDocuments
        {
            (snapshot, error) in
            if let error = error
            {
                print("Hata: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else
            {
                print("Can't find any posts.")
                completion(.success([]))
                return
            }
            
            self.posts = documents.compactMap
            {
                document -> PostModel? in
                let data = document.data()
                
                guard let title = data["title"] as? String,
                      let description = data["description"] as? String,
                      let date = (data["date"] as? Timestamp)?.dateValue(),
                      let location = data["location"] as? String,
                      let isActive = data["isActive"] as? Bool,
                      let price = data["price"] as? Double,
                      let id = data["id"] as? String,
                      let ownerID = data["ownerID"] as? String else
                {
                    print("Veri çekilemedi: \(data)")
                    return nil
                }
                return PostModel(id: id, title: title, description: description, ownerID: ownerID, date: date, location: location, isActive: isActive, price: price, imageURL: data["imageURL"] as? String)
            }
            completion(.success(self.posts))
        }
    }
    
    // update post
    func updatePost(post: PostModel, completion: @escaping (Result<Void, Error>) -> Void)
    {
        let postData: [String: Any] =
        [
            "title": post.title,
            "description": post.description,
            "date": Timestamp(date: post.date),
            "location": post.location,
            "isActive": post.isActive,
            "price": post.price,
            "imageURL": post.imageURL as Any,
            "ownerID": post.ownerID
        ]
        
        db.collection("posts").document(post.id).updateData(postData) { error in
            if let error = error
            {
                completion(.failure(error))
            }
            else
            {
                if let index = self.posts.firstIndex(where: { $0.id == post.id })
                {
                    self.posts[index] = post
                }
                completion(.success(()))
            }
        }
    }
    
    // delete post
    func deletePost(id: String, completion: @escaping (Result<Void, Error>) -> Void)
    {
        db.collection("posts").document(id).delete { error in
            if let error = error
            {
                completion(.failure(error))
            }
            else
            {
                if let index = self.posts.firstIndex(where: { $0.id == id })
                {
                    self.posts.remove(at: index)
                }
                completion(.success(()))
            }
        }
    }
}
