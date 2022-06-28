//
//  FilterViewModel.swift
//  SearchDaumBlog
//
//  Created by gaeng on 2022/06/29.
//

import RxSwift
import RxCocoa

struct FilterViewModel {
    // FilterView 외부에서 관찰
    let sortButtonTapped = PublishRelay<Void>()
}
