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
        let recommendTap: ControlEvent<Recommend>
        let delete: ControlEvent<IndexPath>
    }
    
    struct CellInput {
        let completeTap: Observable<UUID>
        let starTap: Observable<UUID>
        let disposeBag: DisposeBag
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
        
        input.recommendTap
            .map { $0.title }
            .withLatestFrom(sectionShoppingList) { ($0, $1) }
            .bind(with: self) { owner, tuple in
                let recommend = tuple.0 + " 구매하기"
                var data = tuple.1
                data[0].items.insert(Shopping(title: recommend, isComplete: false, isStar: false), at: 0)
                owner.sectionShoppingList.accept(data)
            }
            .disposed(by: disposeBag)
        
        input.delete
            .withLatestFrom(sectionShoppingList) { ($0, $1) }
            .bind(with: self) { owner, tuple in
                let indexPath = tuple.0
                var data = tuple.1
                data[indexPath.section].items.remove(at: indexPath.row)
                owner.sectionShoppingList.accept(data)
            }
            .disposed(by: disposeBag)
        
        return Output(reload: sectionShoppingList)
    }
    
    func transform(input: CellInput) -> Output {
        input.completeTap
            .withLatestFrom(sectionShoppingList) { ($0, $1) }
            .bind(with: self) { owner, tuple in
                let id = tuple.0
                var data = tuple.1
                
                for i in 0..<data.count {
                    for j in 0..<data[i].items.count {
                        if data[i].items[j].id == id {
                            let section = i
                            let index = j
                            var shopping = data[section].items[index]
                            
                            shopping.isComplete.toggle()
                            data[section].items.remove(at: index)
                            if section == 0 {
                                data[1].items.insert(shopping, at: 0)
                            } else {
                                data[0].items.append(shopping)
                            }
                            owner.sectionShoppingList.accept(data)
                            return
                        }
                    }
                }
            }
            .disposed(by: input.disposeBag)
        
        input.starTap
            .withLatestFrom(sectionShoppingList) { ($0, $1) }
            .bind(with: self) { owner, tuple in
                let id = tuple.0
                var data = tuple.1
                
                for i in 0..<data.count {
                    for j in 0..<data[i].items.count {
                        if data[i].items[j].id == id {
                            let section = i
                            let index = j
                            
                            data[section].items[index].isStar.toggle()
                            owner.sectionShoppingList.accept(data)
                            return
                        }
                    }
                }
            }
            .disposed(by: input.disposeBag)
        
        return Output(reload: sectionShoppingList)
    }
}
