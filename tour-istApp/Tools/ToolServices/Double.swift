import Foundation

extension Double
{
    func asCurrencyString() -> String
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

func formattedDate(_ date: Date) -> String
{
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: date)
}

let dateFormatter: DateFormatter =
{
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
