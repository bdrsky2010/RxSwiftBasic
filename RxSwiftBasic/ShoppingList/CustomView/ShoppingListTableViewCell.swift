//
//  ShoppingListTableViewCell.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/5/24.
//

import UIKit

import RxSwift
import SnapKit

final class ShoppingListTableViewCell: UITableViewCell {
    static let identifier = "ShoppingListTableViewCell"
    
    let completeButton = UIButton(type: .system)
    let titleLabel = UILabel()
    let starButton = UIButton(type: .system)
    
    let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(completeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(starButton)
        
        completeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(completeButton.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(starButton.snp.leading).offset(-20)
        }
        
        starButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
