//
//  Helper.swift
//  ImgurFeed
//
//  Created by Senthil on 22/03/2025.
//

import Foundation

extension Date {
    
    func formattedDate() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.second, .minute, .hour, .day, .month, .year], from: self, to: now)

        // Calculate time differences
        if let year = components.year, year > 0 {
            return "\(year) year\(year == 1 ? "" : "s") ago"
        }
        if let month = components.month, month > 0 {
            return "\(month) month\(month == 1 ? "" : "s") ago"
        }
        if let day = components.day, day > 0 {
            if day == 1 {
                return "1 day ago"
            } else if day < 7 {
                return "\(day) days ago"
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM d" // Example: "March 21"
                return dateFormatter.string(from: self)
            }
        }
        if let hour = components.hour, hour > 0 {
            return "\(hour)h ago"
        }
        if let minute = components.minute, minute > 0 {
            return "\(minute)m ago"
        }
        if let second = components.second, second > 0 {
            return "Just now"
        }

        return "Just now" // Default fallback
    }
}
