import RxSwift

let disposeBag = DisposeBag()

print("---------------- Publish Subject -------------------")
let publishSubject = PublishSubject<String>()

publishSubject.onNext("1.... Hi everyone")

let sub1 = publishSubject
    .subscribe(onNext: {
        print($0)
    })
//    .disposed(by: disposeBag)

publishSubject.onNext("2.... Is here?")
publishSubject.onNext("3.... Anybody else?")

sub1.dispose()

let sub2 = publishSubject
    .subscribe(onNext: {
        print($0)
    })
//    .disposed(by: disposeBag)

publishSubject.onNext("4.... Hello?")
publishSubject.onCompleted()

publishSubject.onNext("5.... Exit?")

sub2.dispose()

publishSubject
    .subscribe {
        print("세번째 구독:", $0.element ?? $0)
    }
    .disposed(by: disposeBag)

publishSubject.onNext("6.... Come on")
