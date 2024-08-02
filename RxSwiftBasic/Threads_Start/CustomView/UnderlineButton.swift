//
//  UnderlineButton.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/2/24.
//

import UIKit

class UnderlineButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        
        configuration = .plain()
        configuration?.title = title
        configuration?.attributedTitle = AttributedString(NSAttributedString(
            string: title,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
            ]
        ))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
