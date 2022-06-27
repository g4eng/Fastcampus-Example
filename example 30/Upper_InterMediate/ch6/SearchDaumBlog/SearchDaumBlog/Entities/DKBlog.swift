//
//  DKBlog.swift
//  SearchDaumBlog
//
//  Created by gaeng on 2022/06/27.
//

import Foundation

struct DKBlog: Decodable {
    let documents: [DKDocument]
}

struct DKDocument: Decodable {
    let title: String?
    let name: String?
    let thumbnail: String?
    let datetime: Date?
    
    enum CodingKeys: String, CodingKey {
        case title, thumbnail, datetime
        case name = "blogname"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = try container.decode(String?.self, forKey: .title)
        let name = try container.decode(String?.self, forKey: .name)
        let thumbnail = try container.decode(String?.self, forKey: .thumbnail)
        let datetime = Date.parse(values, key: .datetime)
    }
}

extension Date {
    static func parse<K: CodingKey>(_ values: KeyedDecodingContainer<K>, key: K) -> Date? {
        guard let dateString = try? values.decode(String.self, forKey: key),
              let date = from(dateString: dateString) else {
            return nil
        }
        return date
    }
    
    static func from(dateString: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        df.locale = Locale(identifier: "ko_kr")
        if let date = df.date(from: dateString) {
            return date
        }
        return nil
    }
}
