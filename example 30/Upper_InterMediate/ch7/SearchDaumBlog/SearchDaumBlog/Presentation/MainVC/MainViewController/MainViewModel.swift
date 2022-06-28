//
//  MainViewModel.swift
//  SearchDaumBlog
//
//  Created by gaeng on 2022/06/29.
//

import RxSwift
import RxCocoa
import Foundation

struct MainViewModel {
    let disposeBag = DisposeBag()
    
    let blogListViewModel = BlogListViewModel()
    let searchBarViewModel = SearchBarViewModel()
    
    let alertActionTapped = PublishRelay<MainViewController.AlertAction>()
    let shouldPresentAlert: Signal<MainViewController.Alert>
    
    init(model: MainModel = MainModel()) {
        let blogResult = searchBarViewModel.shouldLoadResult
//            .flatMapLatest { query in
//                SearchBlogNetwork().searchBlog(query: query)
//                model.searchBlog(query)
//            }
            .flatMapLatest(model.searchBlog)
            .share()
            
        let blogValue = blogResult
            .compactMap(model.getBlogValue)
        
        let blogError = blogResult
            .compactMap(model.getBlogError)
        
        // 네트워크를 통해 가져온 값을 cellData로 변환
        let cellData = blogValue
            .map(model.getBlogListCellData)
        
        // FilterView를 선택했을 때 나오는 alertSheet를 선택했을 때 type
        let sortedType = alertActionTapped
            .filter {
                switch $0 {
                case .title, .datetime:
                    return true
                default:
                    return false
                }
            }
            .startWith(.title)
        
        // mainVC -> ListView
        Observable
//            .combineLatest(
//                sortedType,
//                cellData
//            ) { type, data -> [BlogListCellData] in
//                switch type {
//                case .title:
//                    return data.sorted { $0.title ?? "" < $1.title ?? "" }
//                case .datetime:
//                    return data.sorted { $0.datetime ?? Date() > $1.datetime ?? Date() }
//                default:
//                    return data
//                }
//            }
            .combineLatest(sortedType,
                           cellData,
                           resultSelector: model.sort)
            .bind(to: blogListViewModel.blogCellData)
            .disposed(by: disposeBag)

        // 이벤트에 대한 바인드 작업
        let alertSheetForSorting = blogListViewModel.filterViewModel.sortButtonTapped
            .map { _ -> MainViewController.Alert in
                return (title: nil, message: nil, actions: [.title, .datetime, .cancel], style: .actionSheet)
            }
        
        let alertForErrorMessage = blogError
            .map { message -> MainViewController.Alert in
                return (
                    title: "앗!",
                    message: "예상치 못한 오류가 발생했습니다. 잠시 후 다시 시도해주세요. \(message)",
                    actions: [.confirm],
                    style: .alert
                )
            }
        
        self.shouldPresentAlert = Observable
            .merge(
                alertSheetForSorting,
                alertForErrorMessage
            )
            .asSignal(onErrorSignalWith: .empty())
    }
}
