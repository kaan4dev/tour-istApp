import Foundation

class ApplicationService
{
    //properties
    static let shared = ApplicationService()
    
    //instances
    private var applications: [ApplicationModel] = []
    
    //add application
    func addApplication(postId: String, guideId: String) -> ApplicationModel
    {
        let newApplication = ApplicationModel(
            id: UUID().uuidString,
            postId: postId,
            guideId: guideId,
            status: "pending"
        )
        applications.append(newApplication)
        return newApplication
    }
    
    //get applications
    func getApplications(forPost postId: String) -> [ApplicationModel]
    {
        applications.filter { $0.postId == postId }
    }
    
    //update application
    func updateApplication(application: ApplicationModel)
    {
        if let index = applications.firstIndex(where: { $0.id == application.id })
        {
            applications[index] = application
        }
    }
}
