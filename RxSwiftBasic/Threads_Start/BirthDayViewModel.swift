//
//  BirthDayViewModel.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/6/24.
//

import Foundation

import RxCocoa
import RxSwift

final class BirthDayViewModel {
    struct Input {
        let birthDayDate: ControlProperty<Date>
        let nextTap: ControlEvent<Void>
    }
    
    struct Output {
        let validAge: Observable<Bool>
        let nextTap: ControlEvent<Void>
    }
    
    private let year = BehaviorRelay(value: 0)
    private let month = BehaviorRelay(value: 0)
    private let day = BehaviorRelay(value: 0)
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.birthDayDate
            .bind(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                if let year = component.year, let month = component.month, let day = component.day {
                    owner.year.accept(year)
                    owner.month.accept(month)
                    owner.day.accept(day)
                }
            }
            .disposed(by: disposeBag)
        
        let validAge = Observable.combineLatest(year, month, day)
            .map { year, month, day in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                guard let todayYear = component.year,
                      let todayMonth = component.month,
                      let todayDay = component.day
                else { return false }
                
                if todayYear - year > 17 {
                    return true
                }
                
                if todayYear - year == 17 {
                    if todayMonth > month {
                        return true
                    }
                    
                    if todayMonth == month, todayDay >= day {
                        return true
                    }
                }
                
                return false
            }
        
        return Output(validAge: validAge,
                      nextTap: input.nextTap)
    }
}
