import SwiftUI

struct GuideTravelHistory: View
{
    // MARK: - Data
    let pastTours: [Tour] =
    [
        Tour(title: "Samsun Gezisi", date: "1 Eylül 2024"),
        Tour(title: "İstanbul Turu", date: "15 Eylül 2024"),
        Tour(title: "Kapadokya Macerası", date: "22 Eylül 2024"),
        Tour(title: "Antalya Plajı", date: "29 Eylül 2024")
    ]
    
    // MARK: - Body
    var body: some View
    {
        NavigationView
        {
            List(pastTours, id: \.title)
            { tour in
                tourRowView(tour: tour)
            }
            .navigationTitle("Geçmiş Etkinlikler")
        }
    }
    // MARK: - Tour Row View
    private func tourRowView(tour: Tour) -> some View
    {
        HStack
        {
            VStack(alignment: .leading)
            {
                Text(tour.title)
                    .font(.headline)
                Text(tour.date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
    }
}
// MARK: - Tour Model
struct Tour
{
    let title: String
    let date: String
}

#Preview
{
    GuideTravelHistory()
}
