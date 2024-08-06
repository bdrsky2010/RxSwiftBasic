//
//  PasswordViewModel.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/6/24.
//

import Foundation

import RxCocoa
import RxSwift

final class PasswordViewModel {
    struct Input {
        let password: ControlProperty<String?>
        let nextTap: ControlEvent<Void>
    }
    
    struct Output {
        let passwordValid: Observable<Bool>
        let nextTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let passwordValid = input.password.orEmpty
            .map { $0.count >= 8 }
        return Output(passwordValid: passwordValid,
                      nextTap: input.nextTap)
    }
}
