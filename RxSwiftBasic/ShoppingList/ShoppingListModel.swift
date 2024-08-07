//
//  ShoppingListModel.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/5/24.
//

import Foundation
import Differentiator

struct SectionShopping {
    let header: String
    var items: [Item]
}

extension SectionShopping: AnimatableSectionModelType {
    typealias Identity = String
    typealias Item = Shopping
    
    var identity: String {
        return header
    }
    
    init(original: SectionShopping, items: [Shopping]) {
        self = original
        self.items = items
    }
}

struct Shopping: Identifiable {
    let id = UUID()
    let title: String
    var isComplete: Bool
    var isStar: Bool
}

extension Shopping: IdentifiableType, Equatable {
    typealias Identity = UUID
    
    var identity: UUID {
        return id
    }
}

struct ShoppingData {
    static let data = [
        Shopping(title: "그립톡 구매하기", isComplete: true, isStar: true),
        Shopping(title: "사이다 구매", isComplete: false, isStar: false),
        Shopping(title: "아이패드 케이스 최저가 알아보기", isComplete: false, isStar: true),
        Shopping(title: "양말", isComplete: false, isStar: true)
    ]
    
    static let sections: [SectionShopping] = [
        SectionShopping(header: "미완료", items: data.filter { !$0.isComplete }),
        SectionShopping(header: "완료", items: data.filter { $0.isComplete })
    ]
}
