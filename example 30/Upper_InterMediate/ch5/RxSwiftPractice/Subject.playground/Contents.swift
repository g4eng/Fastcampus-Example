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

print("---------------- Behavior Subject -------------------")
enum SubjectError: Error {
    case error1
}

let behaviorSubject = BehaviorSubject<String>(value: "0. 초기값")
behaviorSubject.onNext("1. 1번값")

behaviorSubject.subscribe {
    print("첫번째 구독: ", $0.element ?? $0)
}
.disposed(by: disposeBag)

//behaviorSubject.onError(SubjectError.error1)

behaviorSubject.subscribe {
    print("두번째 구독: ", $0.element ?? $0)
}
.disposed(by: disposeBag)

// behaviorSubject의 value 값은 try 구문으로 가져올 수 있다.
let value = try? behaviorSubject.value()
print(value)

// Rx에서는 거의 사용하지 않음

print("---------------- Replay Subject -------------------")
// 몇개에 이벤트에 대한 버퍼 선언 가능(bufferSize)
let replySubject = ReplaySubject<String>.create(bufferSize: 2)
replySubject.onNext("1. 여러분")
replySubject.onNext("2. 힘내세요")
replySubject.onNext("3. 어렵지만")

replySubject.subscribe {
    print("첫 번째 구독: ", $0.element ?? $0)
}
.disposed(by: disposeBag)

replySubject.subscribe {
    print("두 번째 구독: ", $0.element ?? $0)
}
.disposed(by: disposeBag)

replySubject.onNext("4. 할 수 있어요")
replySubject.onError(SubjectError.error1)
replySubject.dispose()

replySubject.subscribe {
    print("세 번째 구독: ", $0.element ?? $0)
}
.disposed(by: disposeBag)
