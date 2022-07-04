//
//  KLDocument.swift
//  FindCVS
//
//  Created by gaeng on 2022/07/04.
//

import Foundation

struct KLDocument: Decodable {
    let placeName: String
    let addressName: String
    let roadAddressName: String
    let x: String
    let y: String
    let distance: String
    
    private enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case placeName = "place_name"
        case roadAddressName = "road_address_name"
        case distance, x, y
    }
}
