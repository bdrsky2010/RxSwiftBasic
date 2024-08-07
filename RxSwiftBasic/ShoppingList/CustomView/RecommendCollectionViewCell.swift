//
//  RecommendCollectionViewCell.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/7/24.
//

import UIKit

import SnapKit

final class RecommendCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendCollectionViewCell"
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    func configureLabelText(text: String) {
        titleLabel.text = text
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
