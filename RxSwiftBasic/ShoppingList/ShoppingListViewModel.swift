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
        let completeTap: Observable<IndexPath>
        let starTap: Observable<IndexPath>
    }
    
    struct Output {
        var reload: BehaviorRelay<[SectionShopping]>
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
    
    func transform(input: CellInput) -> Output {
        input.completeTap
            .withLatestFrom(sectionShoppingList) { ($0, $1) }
            .bind(with: self) { owner, tuple in
                print("\(tuple.0)")
                let section = tuple.0.section
                let index = tuple.0.row
                var data = tuple.1
                let list = data[section]
                var shopping = list.items[index]
                shopping.isComplete.toggle()
                data[section].items.remove(at: index)
                data[section == 0 ? 1 : 0].items.insert(shopping, at: 0)
            }
            .disposed(by: disposeBag)
        
        return Output(reload: sectionShoppingList)
    }
}
