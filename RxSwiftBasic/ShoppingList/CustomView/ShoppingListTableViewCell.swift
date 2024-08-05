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
    
    let cellBackgroundView = UIView()
    let completeButton = UIButton(type: .system)
    let titleLabel = UILabel()
    let starButton = UIButton(type: .system)
    
    let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellBackgroundView)
        cellBackgroundView.addSubview(completeButton)
        cellBackgroundView.addSubview(titleLabel)
        cellBackgroundView.addSubview(starButton)
        
        cellBackgroundView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        completeButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(completeButton.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(completeButton.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(starButton.snp.leading).offset(-20)
        }
        
        starButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(starButton.snp.height)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        cellBackgroundView.backgroundColor = .secondarySystemBackground
        cellBackgroundView.layer.cornerRadius = 10
    
        completeButton.configuration = .plain()
        completeButton.configuration?.baseForegroundColor = .systemRed
        
        titleLabel.font = .systemFont(ofSize: 14)
        
        starButton.configuration = .plain()
        starButton.configuration?.baseForegroundColor = .systemYellow
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
