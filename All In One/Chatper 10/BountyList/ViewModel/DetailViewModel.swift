//
//  DetailViewModel.swift
//  BountyList
//
//  Created by gaeng on 2022/05/09.
//  Copyright © 2022 com.joonwon. All rights reserved.
//

import Foundation

class DetailViewModel {
    var bountyInfo: BountyInfo?
    
    func update(model: BountyInfo?) {
        bountyInfo = model
    }
}
