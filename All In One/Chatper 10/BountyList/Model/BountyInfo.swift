//
//  BountyInfo.swift
//  BountyList
//
//  Created by gaeng on 2022/05/09.
//  Copyright © 2022 com.joonwon. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct BountyInfo {
    let name: String
    let bounty: Int
    
    var image: UIImage? {
        return UIImage(named: "\(name).jpg")
    }
    
    init(name: String, bounty: Int) {
        self.name = name
        self.bounty = bounty
    }
}
