//
//  TitleTextFieldCellViewModel.swift
//  KarrotWrite
//
//  Created by gaeng on 2022/06/30.
//

import RxCocoa
import RxSwift

struct TitleTextFieldCellViewModel {
    let titleText = PublishRelay<String?>()
}
