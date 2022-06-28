//
//  DetailWriteFormCellViewModel.swift
//  KarrotWrite
//
//  Created by gaeng on 2022/06/30.
//

import RxSwift
import RxCocoa

struct DetailWriteFormCellViewModel {
    // View -> ViewModel
    let contentValue = PublishRelay<String?>()
}
