//
//  BaseViewModel.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/12/24.
//

import Foundation

// 제네릭 구조의 BaseViewModel 프로토콜 구성
protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
