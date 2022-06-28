//
//  BlogListViewModel.swift
//  SearchDaumBlog
//
//  Created by gaeng on 2022/06/29.
//

import RxSwift
import RxCocoa

struct BlogListViewModel {
    let filterViewModel = FilterViewModel()
    
    // MainVC -> BlogListView
    let blogCellData = PublishSubject<[BlogListCellData]>()
    let cellData: Driver<[BlogListCellData]>
    
    init() {
        self.cellData = blogCellData
            .asDriver(onErrorJustReturn: [])
    }
}
