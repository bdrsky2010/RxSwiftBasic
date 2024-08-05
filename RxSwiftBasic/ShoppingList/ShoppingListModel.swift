//
//  ShoppingListModel.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/5/24.
//

import Foundation

struct SectionShopping {
    let header: String
    var list: [Shopping]
}

struct Shopping: Hashable, Identifiable {
    let id = UUID()
    let title: String
    var isComplete: Bool
    var isStar: Bool
}

struct ShoppingData {
    static let data = [
        Shopping(title: "그립톡 구매하기", isComplete: true, isStar: true),
        Shopping(title: "사이다 구매", isComplete: false, isStar: false),
        Shopping(title: "아이패드 케이스 최저가 알아보기", isComplete: false, isStar: true),
        Shopping(title: "양말", isComplete: false, isStar: true)
    ]
    
    static let sections: [SectionShopping] = [
        SectionShopping(header: "전체", list: data),
        SectionShopping(header: "완료", list: data.filter { $0.isComplete })
    ]
}
