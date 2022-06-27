//
//  SearchBlogAPI.swift
//  SearchDaumBlog
//
//  Created by gaeng on 2022/06/27.
//

import Foundation

struct SearchBlogAPI {
    static let scheme = "https"
    static let host = "dapi.kakao.com"
    static let path = "/v2/search/" 
    
    func searchBlog(query: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = Self.scheme
        components.host = Self.host
        components.path = Self.path + "blog"
        components.queryItems = [
            URLQueryItem(name: "query", value: query)
        ]
        
        return components
    }
}
