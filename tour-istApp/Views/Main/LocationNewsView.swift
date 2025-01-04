import SwiftUI
import Combine

struct LocationNewsView: View
{
    @State private var location: String = ""
    @State private var news: [NewsItem] = []
    @State private var isLoading: Bool = false
    private let apiKey = "180207e5d3e9495cae41cd1473f80337"

    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 16) {
                    TextField("Konum girin", text: $location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)

                    Button(action: fetchNews) {
                        Text("Konumla İlgili Haberleri Getir")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                }
                .padding()

                if isLoading {
                    ProgressView("Yükleniyor...")
                        .padding()
                }

                if news.isEmpty && !isLoading {
                    Text("Haber bulunamadı, lütfen geçerli bir konum girin.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(news) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.title)
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text(item.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.1), radius: 3, x: 0, y: 1)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Yerel Haberler")
            .background(Color(UIColor.systemGroupedBackground))
        }
    }

    func fetchNews() {
        guard !location.isEmpty else { return }
        isLoading = true

        let formattedLocation = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://newsapi.org/v2/everything?q=\(formattedLocation)&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }

            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(NewsAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    news = result.articles.map {
                        NewsItem(title: $0.title, description: $0.description ?? "Açıklama bulunamadı")
                    }
                }
            } catch {
                print("Hata: \(error)")
            }
        }.resume()
    }
}

struct NewsItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

struct NewsAPIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let title: String
    let description: String?
}

#Preview {
    LocationNewsView()
}
