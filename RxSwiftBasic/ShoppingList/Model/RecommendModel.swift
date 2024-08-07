//
//  RecommendModel.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/7/24.
//

import Foundation
import Differentiator

struct SectionRecommend {
    var items: [Item]
}

extension SectionRecommend: SectionModelType {
    typealias Item = Recommend
    
    init(original: SectionRecommend, items: [Recommend]) {
        self = original
        self.items = items
    }
}

struct Recommend: Hashable, Identifiable {
    let id = UUID()
    let title: String
}

struct RecommendData {
    static let data = [
        Recommend(title: "베어본"),
        Recommend(title: "키캡"),
        Recommend(title: "스위치"),
        Recommend(title: "모니터"),
        Recommend(title: "스피커"),
        Recommend(title: "에어팟맥스"),
        Recommend(title: "플스5"),
        Recommend(title: "닌텐도스위치"),
        Recommend(title: "핸드크림"),
        Recommend(title: "마우스")
    ]
    
    static let sections = [SectionRecommend(items: data)]
}
