//
//  AlertActionConvertible.swift
//  SearchDaumBlog
//
//  Created by gaeng on 2022/06/24.
//

import UIKit

protocol AlertActionConvertible {
    var title: String { get }
    var style: UIAlertActionStyle { get }
}
