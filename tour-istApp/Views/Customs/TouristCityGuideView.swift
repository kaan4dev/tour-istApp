import SwiftUI

struct TouristCityGuideView: View
{
    var body: some View
    {
        NavigationView
        {
            ScrollView
            {
                VStack(alignment: .leading, spacing: 20)
                {
                    Text("Şehir Rehberi: İstanbul")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("İstanbul, hem tarihi hem de modern kültürü ile zengin bir şehir. İşte İstanbul'da yapmanız gereken bazı aktiviteler ve ziyaret etmeniz gereken yerler:")
                        .font(.body)
                        .foregroundColor(.gray)

                    Divider()

                    VStack(alignment: .leading)
                    {
                        Text("Gidilecek Yerler")
                            .font(.title2)
                            .fontWeight(.bold)

                        ForEach(places, id: \.self) { place in
                            HStack
                            {
                                Image(systemName: "pin.fill")
                                    .foregroundColor(.blue)
                                Text(place)
                                    .font(.body)
                            }
                        }
                    }

                    Divider()

                    VStack(alignment: .leading)
                    {
                        Text("Önerilen Aktiviteler")
                            .font(.title2)
                            .fontWeight(.bold)

                        ForEach(activities, id: \.self)
                        {
                            activity in
                            HStack
                            {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.orange)
                                Text(activity)
                                    .font(.body)
                            }
                        }
                    }

                    Divider()

                    VStack(alignment: .leading)
                    {
                        Text("Şehir Hakkında")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top)

                        Text("İstanbul, Asya ve Avrupa'nın kesişim noktasında yer alıyor. Tarih boyunca birçok medeniyete ev sahipliği yapmış bu şehir, görkemli mimarisi, tarihi yapıları ve çeşitli kültürel etkinlikleri ile ünlüdür.")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
            }
            .navigationBarTitle("İstanbul Rehberi", displayMode: .inline)
        }
    }

    let places = [
        "Ayasofya",
        "Topkapı Sarayı",
        "Sultanahmet Camii",
        "Kapalıçarşı",
        "Galata Kulesi"
    ]

    let activities = [
        "Boğaz turu yapın",
        "Yerel yemekleri deneyin",
        "Beyoğlu'nda yürüyüş yapın",
        "Müzeleri ziyaret edin",
        "Sultanahmet Meydanı'nda dinlenin"
    ]
}

#Preview {
    TouristCityGuideView()
}
