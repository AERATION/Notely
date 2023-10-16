import Foundation

extension DateFormatter {
    
    func getFormattedDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setDateFormat()
        return dateFormatter.string(from: date)
    }
    
    private func setDateFormat() {
        self.dateFormat = "dd MMM yyyy"
    }
}
