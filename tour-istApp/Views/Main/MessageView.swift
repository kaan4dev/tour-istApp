import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let sender: String
    let text: String
}

struct MessageView: View {
    let messages: [Message] =
    [
        Message(sender: "Ali", text: "Merhaba! Nasılsın?"),
        Message(sender: "Ayşe", text: "Bugün planların neler?"),
        Message(sender: "Murat", text: "Yeni ilan ekledin mi?"),
        Message(sender: "Fatma", text: "Rehberlik hizmetin hakkında daha fazla bilgi alabilir miyim?"),
        Message(sender: "Emre", text: "Sana nasıl yardımcı olabilirim?")
    ]
    
    var body: some View {
        NavigationView {
            List(messages) { message in
                HStack(alignment: .top) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text(message.sender)
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        Text(message.text)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Mesajlar")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MessageView()
}
