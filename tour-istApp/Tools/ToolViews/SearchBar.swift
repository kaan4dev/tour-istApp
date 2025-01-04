import SwiftUI

struct SearchBar: View
{
    // properties
    @Binding var text: String

    var body: some View
    {
        HStack
        {
            TextField("Search...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack
                    {
                        magnifyingGlassIcon

                        if !text.isEmpty
                        {
                            clearButton
                        }
                    }
                )
                .padding(.horizontal, 10)
        }
    }

    // magnifying glass icon
    private var magnifyingGlassIcon: some View
    {
        Image(systemName: "magnifyingglass")
            .foregroundColor(.gray)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 8)
    }

    // clear button
    private var clearButton: some View
    {
        Button(action: clearSearchText)
        {
            Image(systemName: "multiply.circle.fill")
                .foregroundColor(.gray)
                .padding(.trailing, 8)
        }
    }

    // clear search text
    private func clearSearchText()
    {
        text = ""
    }
}

// preview
struct SearchBarPreviewContainer: View
{
    @State private var searchText = ""

    var body: some View
    {
        VStack
        {
            SearchBar(text: $searchText)
            Text("Search text: \(searchText)")
        }
    }
}
