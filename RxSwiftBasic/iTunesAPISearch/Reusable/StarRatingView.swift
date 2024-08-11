//
//  StarRatingView.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/11/24.
//

import UIKit

import SnapKit

final class StarRatingView: UIView {
    private let horizontalStackView = UIStackView()
    private let starImageViewList = [UIImageView(), UIImageView(), UIImageView(), UIImageView(), UIImageView()]
    private let ratingLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(horizontalStackView)
        starImageViewList.forEach { horizontalStackView.addArrangedSubview($0) }
        addSubview(ratingLabel)
        
        horizontalStackView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(horizontalStackView.snp.trailing)
            make.centerY.equalTo(horizontalStackView.snp.centerY)
            make.trailing.equalToSuperview()
        }
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .equalSpacing
        
        starImageViewList.forEach {
            $0.tintColor = .systemGray
            $0.preferredSymbolConfiguration = .init(font: .systemFont(ofSize: 12))
        }
        
        ratingLabel.textColor = .systemGray
        ratingLabel.font = .systemFont(ofSize: 12)
    }
    
    func setRating(rating: Double) {
        var roundRating = round(rating * 10) / 10 // 소수점 둘째자리에서 반올림
        
        ratingLabel.text = "\(roundRating)"
        
        starImageViewList.forEach {
            if roundRating >= 1 {
                roundRating -= 1
                $0.image = UIImage(systemName: "star.fill")
            } else if roundRating >= 0.5 {
                roundRating = 0
                $0.image = UIImage(systemName: "star.leadinghalf.filled")
            } else {
                $0.image = UIImage(systemName: "star")
            }
        }
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
