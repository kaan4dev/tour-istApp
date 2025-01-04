import SwiftUI

struct OwnProfileView: View {
    var user: UserModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    if let profileImageURL = user.imageURL, let url = URL(string: profileImageURL) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 100, height: 100)
                                .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                        } placeholder: {
                            ProgressView()
                                .frame(width: 50, height: 50)
                        }
                    }

                    Spacer()

                    VStack(alignment: .leading, spacing: 8) {
                        Text(user.name)
                            .font(.title)
                            .bold()
                            .foregroundColor(.primary)

                        Text(user.gender.rawValue)
                            .font(.title3)
                            .foregroundColor(.secondary)

                        Text(user.userType.rawValue)
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.blue.opacity(0.1))
                )
                .padding()

                Divider()

                VStack(alignment: .leading, spacing: 20) {
                    InfoField(label: "Katılma Tarihi", value: formattedDate(user.registrationDate))
                    InfoField(label: "İlan Sayısı", value: "\(user.usersPostCount)")
                    InfoField(label: "Aldığı Yorumlar", value: "\(user.usersCommentCount)")
                    InfoField(label: "Değerlendirme Puanı", value: String(format: "%.1f", Double(user.usersRating) / 10.0)) // Assuming a rating scale of 1-10
                    InfoField(label: "Son Gezdiği Yerler", value: user.travelHistory.map { $0.name }.joined(separator: ", "))
                    InfoField(label: "Konum", value: user.usersLocation)
                    InfoField(label: "Eğitim Seviyesi", value: user.usersDegree)
                    InfoField(label: "Bildiği Diller", value: user.knownLanguages.joined(separator: ", "))
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color(UIColor.systemBackground)) // Arka plan rengi ayarlandı
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }

    // Date formatter to display the date in a user-friendly format
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}

struct InfoField: View {
    var label: String
    var value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .padding(.vertical, 5)
                .padding(.horizontal)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)

            Spacer()

            Text(value)
                .font(.body)
                .padding(.horizontal)
        }
        .padding(.vertical, 5)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    OwnProfileView(user: UserModel(
        id: UUID().uuidString,
        name: "Justin Bieber",
        email: "justin@gmail.com",
        phoneNumber: "905324568982",
        registrationDate: Date(),
        usersPostCount: 24,
        usersCommentCount: 50,
        usersRating: 48,
        password: "12341234",
        usersLocation: "Los Angeles, USA",
        usersDegree: "Lisans",
        knownLanguages: ["English", "French"],
        gender: .male,
        travelHistory: [
            Place(name: "Paris", dateVisited: Date()),
            Place(name: "Tokyo", dateVisited: Date())],
        userType: .tourist,
        imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSD6VmmMYYORrGXZqqeykcWCXJtxdIX7U7B3vrPQEwNVd2FbrzuVp4ymsTNGD-My8cGpmA&usqp=CAU"
    ))
}
