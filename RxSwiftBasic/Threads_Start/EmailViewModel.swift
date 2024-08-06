//
//  EmailViewModel.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/6/24.
//

import Foundation

import RxCocoa
import RxSwift

final class EmailViewModel {
    struct Input {
        let id: ControlProperty<String?>
        let domain: ControlProperty<String?>
        let nextTap: ControlEvent<Void>
    }
    
    struct Output {
        let emailValid: Observable<Bool>
        let nextTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let idValid = input.id.orEmpty
            .map { $0.count > 0 }
        
        let domainValid = input.domain.orEmpty
            .map { $0.count > 0 }
        
        let emailValid = Observable.combineLatest(idValid, domainValid) { $0 && $1 }
        
        return Output(emailValid: emailValid,
                      nextTap: input.nextTap)
    }
}
