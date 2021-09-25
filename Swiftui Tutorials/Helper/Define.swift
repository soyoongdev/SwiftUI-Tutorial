//
//  Define.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 13/09/2021.
//

import SwiftUI


enum MusicApiCall: String {
    case InsertMusic = "InsertMusic"
    case UpdateMusic = "UpdateMusic"
    case GetAllMusic = "GetAllMusic"
    case DeleteMusic = "DeleteMusic"
}


enum PostType: Int {
    case POST = 0                // Bài viết
    case BANNER = 1              // Banner quảng cáo
    case HOUSE_TEMPLATE = 2      // Mẫu nhà
    case KNOWLEDGE = 3           // Kiến thức xây nhà
    case BRANCH = 4              // Chi nhánh
    case CONSTRUCTION = 5        // Công trình
    case VIDEO = 6               // Video
    case PROMOTION = 7           // Ưu đãi

}

public extension DateFormatter {
    static let iso8601MT: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    static let MT_Today: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    static let MT_Past: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yy hh:mm a"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    static let MT_US_Date: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
