import UIKit
import RxSwift

print("------- Just ---------")
Observable<Int>.just(1)
    .subscribe(onNext: {
        print($0)
    })

print("------- Of1 ---------")
Observable<Int>.of(1, 2, 3, 4, 5)
    .subscribe(onNext: {
        print($0)
    })

print("------- Of2 ---------")
Observable.of([1, 2, 3, 4, 5]) // just를 사용한 것과 동일 (Array<Int>)
    .subscribe(onNext: {
        print($0)
    })

print("------- From ---------")
Observable.from([1, 2, 3, 4, 5])
    .subscribe(onNext: {
        print($0)
    })
// array만 받음 -> Array를 순차적으로 방출

print("------- Subscribe1 ---------")
Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }

print("------- Subscribe2 ---------")
Observable.of(1, 2, 3)
    .subscribe {
        if let element = $0.element {
            print(element)
        }
    }

print("------- Subscribe3 ---------")
Observable.of(1, 2, 3)
    .subscribe(onNext: {
        print($0)
    })

print("------- Empty ---------")
Observable<Void>.empty()
    .subscribe {
        print($0)
    }
// onNext: { }, onCompleted: { print("completed") } -> 타입조차 주지않았기 때문에 completed를 방출하지 않았음
// empty는 언제 쓸까? -> 즉시 종료할 수 있는, 0개의 값을 옵저버블을 사용하기 위해

print("------- Never ---------")
Observable.never()
    .debug("never")
    .subscribe(onNext: {
        print($0)
    },
    onCompleted: {
        print("Completed")
    })
// 아무 것도 방출 X

print("------- Range ---------")
Observable.range(start: 1, count: 9)
    .subscribe(onNext: {
        print("2 * \($0) = \(2 * $0)")
    })
// start부터 count까지 반복

print("------- Dispose ---------")
Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }
    .dispose()
// dispose를 통해 구독 취소 (Observable 종료)
// 이벤트 방출 더 이상 되지않음

print("------- DisposeBag ---------")
let disposeBag = DisposeBag()

Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)
// 각각의 구독에 대해서 dispose 관리하기는 효율적이지 않기 때문에 disposeBag을 이용해 dispose들을 담아놓고 할당 해제될 때 모든 dispose를 날림
// -> 하지않으면 메모리 누수...

print("------- Create 1 ---------")
Observable.create { observer -> Disposable in
    observer.onNext(1) // 1
    // == observer.on(.next(1))
    observer.onCompleted()
    // == observer.on(.completed)
    observer.onNext(2)
    // == observer.on(.next(2))
    return Disposables.create()
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)

// create -> @escaping 임 AnyObserver를 취한 다음 Disposable을 리턴
// onNext를 옵저버에 추가 1 ==

print("------- Create 2 ---------")
enum MyError: Error {
    case anError
}

Observable<Int>.create { observer -> Disposable in
    observer.onNext(1)
    observer.onError(MyError.anError)
    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}
.subscribe(onNext: {
    print($0)
}, onError: {
    print($0)
}, onCompleted: {
    print("Completed")
}, onDisposed: {
    print("Disposed")
})
.disposed(by: disposeBag)
// completed도 하지않고 error도 하지 않고 dispose를 하지 않으면 계속 구독하므로 메모리 누수

print("------- deferred 1 ---------")
Observable.deferred {
    Observable.of(1, 2, 3)
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)
// 언제?

print("------- deferred 2 ---------")
var 뒤집기: Bool = false

let factory: Observable<String> = Observable.deferred {
    뒤집기 = !뒤집기
    
    if 뒤집기 {
        return Observable.of("☝️")
    } else {
        return Observable.of("👆")
    }
}

for _ in 0...3 {
    // 구독할때마다 한번씩 방출함(deferred 에서)
    factory.subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
}

