import RxSwift

let disposeBag = DisposeBag()

print("--------- ignore element --------")
// next event를 무시하고 completed나 error는 무시안함
let 취침모드😴 = PublishSubject<String>()

취침모드😴
    .ignoreElements()
    .subscribe {
//        print("☀️")
        print($0)
    }
    .disposed(by: disposeBag)

취침모드😴.onNext("🔈")
취침모드😴.onNext("🔈")
취침모드😴.onNext("🔈")
취침모드😴.onCompleted()

print("--------- elementAt --------")
let 두번울면깨는사람 = PublishSubject<String>()

두번울면깨는사람
    .element(at: 2) // index에만 해당하는 값을 방출
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

두번울면깨는사람.onNext("🔈")
두번울면깨는사람.onNext("🔈")
두번울면깨는사람.onNext("😳")
두번울면깨는사람.onNext("🔈")

print("--------- filter --------")
// 고차함수 filter랑 똑같은
Observable.of(1, 2, 3, 4, 5, 6, 7, 8)
    .filter { $0 % 2 == 0 }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--------- skip --------")
// 0~n까지 스킵
Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
    .skip(5)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--------- skipWhile --------")
Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
    .skip(while: {
        // 해당 값이 false가 되면 skip 멈추고 방출
        $0 != 6
    })
    .subscribe(onNext: {
      print($0)
    })
    .disposed(by: disposeBag)

print("--------- skipUntil --------")
let 손님 = PublishSubject<String>()
let 문여는시간 = PublishSubject<String>()
손님
    .skip(until: 문여는시간) // 다른 옵저버블에 대해 조건을 걸고 싶다면(예 문여는시간이 방출될 때까지 스킵함)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

손님.onNext("😀")
손님.onNext("😀")
문여는시간.onNext("땡!")
손님.onNext("🥹")

print("--------- take --------")
Observable.of("🏅", "🥈", "🥉", "😎", "😢")
    .take(3) // skip의 반대, n개를 까지만 방출
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--------- takeWhile --------")
Observable.of("🏅", "🥈", "🥉", "😎", "😢")
    .take(while: {
        $0 != "🥉" // skipWhile가 반대 -> 해당 구문이 false일때 방출 멈춤
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

// take <-> skip

print("--------- enumerated --------")
Observable.of("🏅", "🥈", "🥉", "😎", "😢")
    .enumerated()
    .take(while: {
        $0.index < 3
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--------- takeUntil --------")
let 수강신청 = PublishSubject<String>()
let 신청마감 = PublishSubject<String>()

수강신청
    .take(until: 신청마감)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

수강신청.onNext("👧")
수강신청.onNext("👨‍⚖️")
신청마감.onNext("끝")
수강신청.onNext("😳")

print("--------- distinctUntilChanged --------")
// 연달아 반복 제거
Observable.of("저는", "저는", "앵무새", "앵무새", "앵무새", "앵무새", "앵무새", "입니다", "입니다", "입니다", "입니다", "입니다", "저는", "앵무새", "앵무새", "일까요?", "일까요?")
    .distinctUntilChanged()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

