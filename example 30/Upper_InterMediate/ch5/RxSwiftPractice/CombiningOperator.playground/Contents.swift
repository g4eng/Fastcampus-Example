import RxSwift

let disposeBag = DisposeBag()

print("----------------------- startWith ---------------------")
// 초기값이 필요한 상황에 사용
let 노랑반 = Observable.of("👧", "👧", "👧")
노랑반
    .enumerated()
    .map { index, element in
        element + "어린이" + "\(index)"
    }
    .startWith("👨‍⚖️")  // 구독 전에 붙여야함
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------------------- concat1 ---------------------")
let 노랑반어린이들 = Observable.of("👧", "👧", "👧")
let 선생님 = Observable<String>.of("👨‍⚖️")

let 줄서서걷기 = Observable
    .concat([선생님, 노랑반어린이들])
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------------------- concat2 ---------------------")
선생님
    .concat(노랑반어린이들)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------------------- concatMap ---------------------")  // flatMap
let 어린이집: [String: Observable<String>] = [
    "노랑반": Observable.of("👧", "👧", "👧"),
    "파랑반": Observable.of("😳", "😳")
]

Observable.of("노랑반", "파랑반")
    .concatMap { 반 in
        어린이집[반] ?? .empty()
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------------------- merge1 ---------------------")

let 강북 = Observable.from(["강북구", "성북구", "동대문구", "종로구"])
let 강남 = Observable.from(["강남구", "강동구", "영등포구", "양천구"])

Observable.of(강북, 강남)
    .merge()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------------------- merge2 ---------------------")
Observable.of(강북, 강남)
    .merge(maxConcurrent: 1) // 한 옵저버블이 완료되기 전까지 다른거 안받음
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------------------- combineLatest1 ---------------------")
let 성 = PublishSubject<String>()
let 이름 = PublishSubject<String>()

let 성명 = Observable
    .combineLatest(성, 이름) { 성,이름 in
        성 + 이름
    }

성명
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

성.onNext("김")
이름.onNext("똘똘")
이름.onNext("경모")
이름.onNext("은수")
성.onNext("최")
성.onNext("박")
성.onNext("이")

print("----------------------- combineLatest2 ---------------------")
let 날짜표시형식 = Observable<DateFormatter.Style>.of(.short, .long)
let 현재날짜 = Observable<Date>.of(Date())

let 현재날짜표시 = Observable
    .combineLatest(
        날짜표시형식,
        현재날짜,
        resultSelector: { 형식, 날짜 -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = 형식
            return dateFormatter.string(from: 날짜)
        }
    )

현재날짜표시
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------------------- combineLatest3 ---------------------")
let lastName = PublishSubject<String>()
let firstName = PublishSubject<String>()
let fullName = Observable
    .combineLatest([firstName, lastName]) { name in
        name.joined(separator: " ")
    }

fullName
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

lastName.onNext("Kim")
firstName.onNext("Paul")
firstName.onNext("Kyle")
firstName.onNext("Leo")

print("----------------------- zip ---------------------")
enum 승패 {
    case 승
    case 패
}

let 승부 = Observable<승패>.of(.승, .패, .승, .승, .패)
let 선수 = Observable<String>.of("한국", "스위스", "미국", "브라질", "일본")

let 시합결과 = Observable
    .zip(승부, 선수) { 결과, 대표선수 in
        return 대표선수 + "선수" + " \(결과)"
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------------------- withLatestFrom1 ---------------------")
let trigger = PublishSubject<Void>()
let 달리기선수 = PublishSubject<String>()

trigger
    .withLatestFrom(달리기선수) // 처음께 방출되어야 파라미터가 제일 마지막께 방출됨
    // .distinctUntilChanged() // 이거 쓰면 sample이랑 똑같아짐
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

달리기선수.onNext("🏃‍♂️")
달리기선수.onNext("🏃‍♂️🏃‍♂️")
달리기선수.onNext("🏃‍♂️🏃‍♂️🏃‍♂️")
trigger.onNext(Void())
    
print("----------------------- sample ---------------------")
let 출발 = PublishSubject<Void>()
let f1선수 = PublishSubject<String>()

f1선수
    .sample(출발)  // 단 한번만 방출됨
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

f1선수.onNext("🚗")
f1선수.onNext("🚗     🚙")
f1선수.onNext("🚗     🚙      🏎")
출발.onNext(Void())
출발.onNext(Void())
출발.onNext(Void())

print("----------------------- amb ---------------------")
let 버스1 = PublishSubject<String>()
let 버스2 = PublishSubject<String>()
let 버스스탑 = 버스1.amb(버스2)
// 먼저 방출되는걸 구독하고 나머지는 무시
버스스탑
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

버스2.onNext("버스2 - 승객0: 😀")
버스1.onNext("버스1 - 승객0: 👧")
버스1.onNext("버스1 - 승객1: 😳")
버스2.onNext("버스2 - 승객1: 🥹")
버스1.onNext("버스1 - 승객2: 😴")
버스2.onNext("버스2 - 승객2: 😢")

print("----------------------- switchLatest ---------------------")
let 학생1 = PublishSubject<String>()
let 학생2 = PublishSubject<String>()
let 학생3 = PublishSubject<String>()

let 손들기 = PublishSubject<Observable<String>>()

let 손든사람만말할수있는교실 = 손들기.switchLatest()
// 손들기(source observable)
손든사람만말할수있는교실
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

손들기.onNext(학생1) // 학생1이 마지막 시퀀스 -> 학생1에 대한 이벤트만 구독
학생1.onNext("학생1: 저는 학생1입니다")
학생2.onNext("학생2: 저는 학생2입니다")

손들기.onNext(학생2) // 학생2가 마지막이니 학생1 말은 무시
학생2.onNext("학생2: 야발랄라")

손들기.onNext(학생3)
학생2.onNext("학생2: 울랄라")
학생1.onNext("학생1: 안키모")
학생3.onNext("학생3: 저는 학생3입니다")

print("----------------------- reduce ---------------------")
Observable.from((1...10))
//    .reduce(0, accumulator: { summary, newValue in
//        return summary + newValue
//    })
//    .reduce(0) { summary, newValue in
//        return summary + newValue
//    }
    .reduce(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------------------- scan ---------------------")
Observable.from((1...10))
    .scan(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
