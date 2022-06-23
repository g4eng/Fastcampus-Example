import RxSwift
import RxCocoa
import PlaygroundSupport

let disposeBag = DisposeBag()

print("------------- replay ------------")
let 인사말 = PublishSubject<String>()
let 반복하는앵무새 = 인사말.replay(1)

반복하는앵무새.connect()

인사말.onNext("1. Hello")
인사말.onNext("2. hi")

반복하는앵무새
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------------- replayAll ------------")
let 닥터스트레인지 = PublishSubject<String>()
let 타임스톤 = 닥터스트레인지.replayAll()
타임스톤.connect()
닥터스트레인지.onNext("도르마무")
닥터스트레인지.onNext("거래를 하러왔다")

타임스톤
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------------- buffer ------------")
//let source = PublishSubject<String>()
//
//var count = 0
//let timer = DispatchSource.makeTimerSource()
//timer.schedule(deadline: .now() + 2, repeating: .seconds(1))
//timer.setEventHandler {
//    count += 1
//    source.onNext("\(count)")
//}
//timer.resume()
//source
//    .buffer(timeSpan: .seconds(2), count: 2, scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("------------- window ------------")
// return 값이 observable
//let 만들어낼최대Observable수 = 1
//let 만들시간 = RxTimeInterval.seconds(2)
//
//let window = PublishSubject<String>()
//var windowCount = 0
//let windowTimerSource = DispatchSource.makeTimerSource()
//windowTimerSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
//windowTimerSource.setEventHandler {
//    windowCount += 1
//    window.onNext("\(windowCount)")
//}
//windowTimerSource.resume()
//
//window
//    .window(timeSpan: 만들시간, count: 만들어낼최대Observable수, scheduler: MainScheduler.instance)
//    .flatMap { windowObservable -> Observable<(index: Int, element: String)> in
//        return windowObservable.enumerated()
//    }
//    .subscribe(onNext: {
//        print("\($0.index)번째 observable element \($0.element)")
//    })
//    .disposed(by: disposeBag)

print("------------- delaySubscription ------------")
// 구독만 뒤로미루는...
//let delaySource = PublishSubject<String>()
//var delayCount = 0
//let delayTimeSource = DispatchSource.makeTimerSource()
//delayTimeSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
//delayTimeSource.setEventHandler {
//    delayCount += 1
//    delaySource.onNext("\(delayCount)")
//}
//delayTimeSource.resume()
//
//delaySource
//    .delaySubscription(.seconds(5), scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("------------- delay ------------")
// -> 시퀀즈 자체를 뒤로 미루는 3초가 지난 시점부터 구독(그때부터 이벤트 방출)
//let delaySubject = PublishSubject<Int>()
//
//var delayCount = 0
//let delayTimerSource = DispatchSource.makeTimerSource()
//delayTimerSource.schedule(deadline: .now(), repeating: .seconds(1))
//delayTimerSource.setEventHandler {
//    delayCount += 1
//    delaySubject.onNext(delayCount)
//}
//delayTimerSource.resume()
//
//delaySubject
//    .delay(.seconds(3), scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("------------- interval ------------")
//Observable<Int>
//    .interval(.seconds(3), scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("------------- timer ------------")
// dueTime 언제 구독할건지 period는 interval의 첫번째 인자랑 같음
//Observable<Int>
//    .timer(.seconds(5), period: .seconds(2), scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("----------- timeout ------------")
// timeout 연산자를 이 시간내로 이벤트가 발생하지 않으면 error 방출
let 누르지않으면에러 = UIButton(type: .system)
누르지않으면에러.setTitle("눌러", for: .normal)
누르지않으면에러.sizeToFit()

PlaygroundPage.current.liveView = 누르지않으면에러
누르지않으면에러.rx.tap
    .do(onNext: {
        print("tap")
    })
    .timeout(.seconds(5), scheduler: MainScheduler.instance)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
