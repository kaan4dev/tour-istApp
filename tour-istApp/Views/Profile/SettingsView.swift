import SwiftUI

struct SettingOption: Identifiable
{
    let id = UUID()
    let title: String
    let icon: String
}

struct SettingsView: View
{
    let options: [SettingOption] =
    [
        SettingOption(title: "Profil", icon: "person.fill"),
        SettingOption(title: "Bildirimler", icon: "bell.fill"),
        SettingOption(title: "Gizlilik", icon: "lock.fill"),
        SettingOption(title: "Yardım", icon: "questionmark.circle.fill"),
        SettingOption(title: "Çıkış", icon: "arrow.right.circle.fill")
    ]
    
    var body: some View {
        NavigationView {
            List(options) { option in
                HStack {
                    Image(systemName: option.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.blue)
                    
                    Text(option.title)
                        .font(.headline)
                        .padding(.leading, 8)
                    
                    Spacer()
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Ayarlar")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
}
