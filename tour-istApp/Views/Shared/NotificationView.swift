import SwiftUI

struct NotificationView: View
{
    @Binding var isPresented: Bool
    
    @State private var notifications: [NotificationModel] =
    [
        NotificationModel(title: "Yeni Mesaj", message: "Bir rehber size yanıt verdi.", date: Date(), isRead: false),
        NotificationModel(title: "Yeni İlan", message: "Yeni bir ilan eklendi.", date: Date().addingTimeInterval(-86400), isRead: true),
        NotificationModel(title: "Güncelleme", message: "Profil bilgilerinizi güncelleyebilirsiniz.", date: Date().addingTimeInterval(-172800), isRead: false)
    ]
    
    
    var body: some View
    {
        NavigationView
        {
            List
            {
                ForEach(notifications)
                {
                    notification in
                    HStack
                    {
                        Image(systemName: notification.isRead ? "message.badge.fill" : "message.badge.filled.fill")
                        
                        VStack(alignment: .leading)
                        {
                            Text(notification.title)
                                .bold()
                            
                            Text(notification.message)
                            
                            Text("\(formattedDate(notification.date))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Bildirimler")
            .navigationBarItems(trailing: Button(action:
            {
                isPresented = false
            })
            {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
            })
        }
    }
}

#Preview
{
    NotificationView(isPresented: .constant(true))
}
