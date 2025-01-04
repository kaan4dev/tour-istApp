import Foundation

struct NotificationModel: Identifiable
{
    let id = UUID()
    let title: String
    let message: String
    let date: Date
    let isRead: Bool
}

