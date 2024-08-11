//
//  CapsuleButton.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/11/24.
//

import UIKit

final class CapsuleButton: UIButton {
    init(title: String, backgroundColor: UIColor, textColor: UIColor) {
        super.init(frame: .zero)
        
        configuration = .borderedProminent()
        configuration?.cornerStyle = .capsule
        configuration?.title = title
        configuration?.contentInsets = .init(top: 8, leading: 20, bottom: 8, trailing: 20)
        configuration?.baseBackgroundColor = backgroundColor
        configuration?.baseForegroundColor = textColor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
