//
//  ShoppingListViewModel.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/5/24.
//

import Foundation

import RxCocoa
import RxSwift

final class ShoppingListViewModel {
    struct Input {
        let addTap: Observable<ControlProperty<String>.Element>
    }
    
    struct CellInput {
        let completeTap: ControlEvent<(IndexPath, Shopping)>
        let starTap: ControlEvent<(IndexPath, Shopping)>
    }
    
    struct Output {
        let reload: BehaviorRelay<[SectionShopping]>
    }
    
    private let sectionShoppingList = BehaviorRelay(value: [SectionShopping]())
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        sectionShoppingList.accept(ShoppingData.sections)
        
        input.addTap
            .withLatestFrom(sectionShoppingList) { ($0, $1) }
            .bind(with: self) { owner, tuple in
                let newTitle = tuple.0
                var data = tuple.1
                data[0].items.insert(Shopping(title: newTitle, isComplete: false, isStar: false), at: 0)
                owner.sectionShoppingList.accept(data)
            }
            .disposed(by: disposeBag)
        
        return Output(reload: sectionShoppingList)
    }
    
//    func transform(input: CellInput) -> Output {
//        
//    }
}
