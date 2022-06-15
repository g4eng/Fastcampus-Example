import RxSwift

let disposeBag = DisposeBag()

print("----------- toArray ------------")
// 방출되는 것을 배열로
Observable.of("A", "B", "C")
    .toArray()
    .subscribe(onSuccess: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------- map ------------")
Observable.of(Date())
    .map { date -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------- flatMap ------------")
//
//Observable<Observable<String>>
protocol 선수 {
    var 점수: BehaviorSubject<Int> { get }
}

struct 양궁선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 한국국대 = 양궁선수(점수: BehaviorSubject<Int>(value: 10))
let 미국국대 = 양궁선수(점수: BehaviorSubject<Int>(value: 8))

let 올림픽경기 = PublishSubject<선수>()

올림픽경기
    .flatMap { 선수 in
        선수.점수
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

올림픽경기.onNext(한국국대)
한국국대.점수.onNext(10)

올림픽경기.onNext(미국국대)
한국국대.점수.onNext(10)
미국국대.점수.onNext(9)

print("----------- flatMapLatest ------------")
// 변경된 값을 무시한다 --> 서울 방출되고
// Transform the items emitted by an Observable into Observables, then flatten the emissions from those into a single Observable
struct 높이뛰기선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 서울 = 높이뛰기선수(점수: BehaviorSubject<Int>(value: 7))
let 제주 = 높이뛰기선수(점수: BehaviorSubject<Int>(value: 6))

let 전국체전 = PublishSubject<선수>()
전국체전
    .flatMapLatest { 선수 in
        선수.점수
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

전국체전.onNext(서울)
서울.점수.onNext(9)

전국체전.onNext(제주)
서울.점수.onNext(10)
제주.점수.onNext(8)

print("----------- materaialize and dematerialize ------------")
// 옵저버블을 옵저버블의 이벤트로 변환해야 할 때, 옵저버블 속성을 가진 옵저버블 항목을 제어할 수 없고 내부적으로 옵저버블이 종료되는 것을 방지하기 위해 에러이벤트를 처리하고 싶을 때
enum 반칙: Error {
    case 부정출발
}

struct 달리기선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 김토끼 = 달리기선수(점수: BehaviorSubject<Int>(value: 0))
let 박치타 = 달리기선수(점수: BehaviorSubject<Int>(value: 1))

let 달리기100M = BehaviorSubject<선수>(value: 김토끼)

달리기100M
    .flatMapLatest { 선수 in
        선수.점수
            .materialize()
    }
    .filter{
        guard let error = $0.error else {
            return true
        }
        print(error)
        return false
    }
    .dematerialize()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

김토끼.점수.onNext(1)
김토끼.점수.onError(반칙.부정출발)
김토끼.점수.onNext(2)

달리기100M.onNext(박치타)
/*
 next(0)
 next(1)
 error(부정출발)
 next(1)
 */

print("----------- 전화번호 11자리 ------------")
let input = PublishSubject<Int?>()
let list: [Int] = [1]
input
    .flatMap {
        $0 == nil
            ? Observable.empty()
            : Observable.just($0)
    }
    .map { $0! }
    .skip(while: { $0 != 0 })
    .take(11) // 010-1234-5678
    .toArray()
    .asObservable()
    .map {
        $0.map { "\($0)" }
    }
    .map { numbers in
        var numberList = numbers
        numberList.insert("-", at: 3) // 010-
        numberList.insert("-", at: 8) // 010-1234-
        let number = numberList.reduce(" ", +)
        return number
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

input.onNext(10)
input.onNext(0)
input.onNext(nil)
input.onNext(1)
input.onNext(0)
input.onNext(4)
input.onNext(1)
input.onNext(2)
input.onNext(nil)
input.onNext(3)
input.onNext(5)
input.onNext(6)
input.onNext(7)
input.onNext(8)
input.onNext(1)

