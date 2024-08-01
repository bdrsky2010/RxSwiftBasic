//
//  FilledButton.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/1/24.
//

import UIKit

class FilledButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        
        configuration = .plain()
        layer.cornerRadius = 10
        configuration?.title = title
        configuration?.baseBackgroundColor = .gray
        configuration?.attributedTitle = AttributedString(NSAttributedString(
            string: title,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        ))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
