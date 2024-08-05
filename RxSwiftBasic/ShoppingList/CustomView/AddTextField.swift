//
//  AddTextField.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/5/24.
//

import UIKit

import SnapKit

final class AddTextField: UITextField {
    let textField = UITextField()
    let addButton = UIButton(type: .system)
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        layer.cornerRadius = 10
        backgroundColor = .secondarySystemBackground
        
        addSubview(textField)
        addSubview(addButton)
        
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(addButton.snp.leading).offset(-16)
        }
        
        textField.placeholder = placeholder
        
        addButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        
        addButton.configuration = .borderedProminent()
        addButton.configuration?.baseBackgroundColor = .systemGray5
        addButton.configuration?.attributedTitle = AttributedString(
            NSAttributedString(string: "추가",
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        )
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
