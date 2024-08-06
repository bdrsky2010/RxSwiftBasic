//
//  LoginViewModel.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/6/24.
//

import Foundation

import RxCocoa
import RxSwift

final class LoginViewModel {
    struct Input {
        let loginTap: ControlEvent<Void>
        let signupTap: ControlEvent<Void>
    }
    
    struct Output {
        let loginTap: ControlEvent<Void>
        let signupTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        return Output(loginTap: input.loginTap,
                      signupTap: input.signupTap)
    }
}
