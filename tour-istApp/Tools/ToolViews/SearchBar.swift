import SwiftUI

// MARK: - SearchBar Component
struct SearchBar: View
{
    // MARK: Properties
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

    // MARK: - Magnifying Glass Icon
    private var magnifyingGlassIcon: some View
    {
        Image(systemName: "magnifyingglass")
            .foregroundColor(.gray)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 8)
    }

    // MARK: - Clear Button
    private var clearButton: some View
    {
        Button(action: clearSearchText)
        {
            Image(systemName: "multiply.circle.fill")
                .foregroundColor(.gray)
                .padding(.trailing, 8)
        }
    }

    // MARK: - Actions
    private func clearSearchText()
    {
        text = ""
    }
}

// MARK: - Preview Container
struct SearchBarPreviewContainer: View
{
    // MARK: State
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

// MARK: - Preview
#Preview
{
    SearchBarPreviewContainer()
}
