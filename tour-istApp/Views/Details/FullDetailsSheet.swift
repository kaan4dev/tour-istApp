import SwiftUI

// MARK: - Full Details Sheet
struct FullDetailsSheet: View
{
    @Binding var isFullDetailsPresented: Bool

    var post: PostModel
    var body: some View
    {
        VStack
        {
            HStack
            {
                Spacer()
                Button(action: {
                    isFullDetailsPresented.toggle()
                })
                {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            VStack(spacing: 50)
            {
                HStack
                {
                    Image(systemName: "textformat.size")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    
                    Text(post.title)
                        .font(.system(size: 30))
                        .foregroundColor(.gray)
                }
                
                HStack
                {
                    Image(systemName: "mappin")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    
                    Text(post.location)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                HStack
                {
                    Image(systemName: "calendar")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    
                    Text("\(post.date, formatter: dateFormatter)")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                HStack
                {
                    Image(systemName: "info.circle")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    
                    Text(post.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                HStack
                {
                    Image(systemName: "tag")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                    
                    Text(post.price.asCurrencyString())
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                
                HStack
                {
                    Image(systemName: "person")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    
                    Text("Sahibi: \(post.ownerID)")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

#Preview
{
    FullDetailsSheet(
        isFullDetailsPresented: .constant(true),
        post: PostModel(
            id: "1",
            title: "İstanbul Turu",
            description: "Detaylı bir İstanbul turu.",
            ownerID: "10005",
            date: Date(),
            location: "İstanbul",
            isActive: true,
            price: 1200,
            imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQa8BEZilCGiEX2lhzGPeR__yCxH2awTwSMKx3NqyGP9i6uiuv2T8ddzOlUpzyP1u36wcQ&usqp=CAU"
        )
    )
}
