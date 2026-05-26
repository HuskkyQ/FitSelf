import SwiftUI

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) ?? self
    }

    var formattedDate: String {
        formatted(.dateTime.month().day().weekday())
    }

    var greetingText: String {
        let hour = Calendar.current.component(.hour, from: self)
        switch hour {
        case 0..<6: return "夜深了"
        case 6..<12: return "早上好"
        case 12..<18: return "下午好"
        default: return "晚上好"
        }
    }
}