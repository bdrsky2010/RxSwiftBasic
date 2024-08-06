//
//  PhoneViewModel.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/6/24.
//

import Foundation

import RxCocoa
import RxSwift

final class PhoneViewModel {
    struct Input {
        let first: ControlProperty<String?>
        let second: ControlProperty<String?>
        let third: ControlProperty<String?>
        let nextTap: ControlEvent<Void>
    }
    
    struct Output {
        let firstNumber: BehaviorRelay<String>
        let validFirst: Observable<Bool>
        let validSecond: Observable<Bool>
        let validThird: Observable<Bool>
        let validTotal: Observable<Bool>
        let nextTap: ControlEvent<Void>
    }
    
    private let firstNumber = BehaviorRelay(value: "010")
    
    func transform(input: Input) -> Output {
        let validFirst = input.first.orEmpty
            .map { Int($0) != nil && $0.count == 3 }
        let validSecond = input.second.orEmpty
            .map { Int($0) != nil && $0.count == 4 }
        let validThird = input.third.orEmpty
            .map { Int($0) != nil && $0.count == 4 }
        let validTotal = Observable
            .combineLatest(validFirst, validSecond, validThird) { $0 && $1 && $2 }
        return Output(firstNumber: firstNumber,
                      validFirst: validFirst,
                      validSecond: validSecond,
                      validThird: validThird,
                      validTotal: validTotal,
                      nextTap: input.nextTap)
    }
}
