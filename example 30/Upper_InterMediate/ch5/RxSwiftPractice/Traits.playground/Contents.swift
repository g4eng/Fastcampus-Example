import RxSwift

let disposeBag = DisposeBag()

enum TraitsError: Error {
case single
case maybe
case completable
}

print("------------ Single 1 ------------")
Single<String>.just("✅")
    .subscribe(onSuccess: {
        print($0)
    }, onFailure: {
        print("error: \($0)")
    }, onDisposed: {
        print("Disposed")
    })
    .disposed(by: disposeBag)

//Observable<String>.just("✅")
//    .subscribe(onNext: {
//
//    }, onError: {
//
//    }, onCompleted: {
//
//    }, onDisposed: {
//
//    })

print("------------ Single 2 ------------")
Observable<String>.create { observer -> Disposable in
    observer.onError(TraitsError.single)
    return Disposables.create()
}
.asSingle()
.subscribe(onSuccess: {
    print($0)
}, onFailure: {
    print("error: \($0.localizedDescription)")
}, onDisposed: {
    print("Disposed")
})
.disposed(by: disposeBag)
// 네트워크 환경에서 json을 주고 받는 환경에서 성공 / 실패 확인용으로

print("------------ Single 3 ------------")
struct SomeJSON: Decodable {
    let name: String
}

enum JSONError: Error {
case decdoingError
}

let json1 = """
{
    "name" : "Yang"
}
"""

let json2 = """
{
    "my_name" : "Yang"
}
"""

func decode(json: String) -> Single<SomeJSON> {
    Single<SomeJSON>.create { observer -> Disposable in
        guard let data = json.data(using: .utf8),
              let json = try? JSONDecoder().decode(SomeJSON.self, from: data) else {
            observer(.failure(JSONError.decdoingError))
            return Disposables.create()
        }
        observer(.success(json))
        return Disposables.create()
    }
}

decode(json: json1)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

decode(json: json2)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

print("------------ Maybe 1 ------------")
Maybe<String>.just("✅")
    .subscribe(onSuccess: {
        print($0)
    }, onError: {
        print($0)
    }, onCompleted: {
        print("Completed")
    }, onDisposed: {
        print("Disposed")
    })
    .disposed(by: disposeBag)

print("------------ Maybe 2 ------------")
let _ = Observable<String>.create { observer -> Disposable in
    observer.onError(TraitsError.maybe)
    return Disposables.create()
}
.asMaybe()
.subscribe(onSuccess: {
    print("성공: \($0)")
}, onError: {
    print("에러: \($0)")
}, onCompleted: {
    print("Completed")
}, onDisposed: {
    print("Disposed")
})
.disposed(by: disposeBag)

print("------------ Completable 1 ------------")
Completable.create { observer -> Disposable in
    observer(.error(TraitsError.completable))
    return Disposables.create()
}
.subscribe(onCompleted: {
    print("completed")
}, onError: {
    print("error: \($0)")
}, onDisposed: {
    print("disposed")
})
.disposed(by: disposeBag)

print("------------ Completable 2 ------------")
Completable.create { observer -> Disposable in
    observer(.completed)
    return Disposables.create()
}
.subscribe(onCompleted: {
    print("completed")
}, onError: {
    print("error: \($0)")
}, onDisposed: {
    print("disposed")
})
.disposed(by: disposeBag)
