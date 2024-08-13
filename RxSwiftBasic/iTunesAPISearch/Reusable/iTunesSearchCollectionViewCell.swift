//
//  iTunesSearchCollectionViewCell.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/11/24.
//

import UIKit

import RxSwift
import SnapKit

final class iTunesSearchCollectionViewCell: UICollectionViewCell {
    static let identifier = "iTunesSearchCollectionViewCell"
    
    private let appIconImage = AppImageView(cornerRadius: 10)
    private let appTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let downloadButton = CapsuleButton(title: "받기", backgroundColor: .systemGray5, textColor: .systemBlue)
    
    private let subContentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    private let ratingView = StarRatingView()
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    private let screenshotStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    private let screenshotImageList = [AppImageView(cornerRadius: 12), AppImageView(cornerRadius: 12), AppImageView(cornerRadius: 12)]
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        contentView.addSubview(appIconImage)
        contentView.addSubview(appTitleLabel)
        contentView.addSubview(downloadButton)
        contentView.addSubview(subContentsStackView)
        subContentsStackView.addArrangedSubview(ratingView)
        subContentsStackView.addArrangedSubview(companyLabel)
        subContentsStackView.addArrangedSubview(categoryLabel)
        contentView.addSubview(screenshotStackView)
        screenshotImageList.forEach { screenshotStackView.addArrangedSubview($0) }
    }
    
    private func configureLayout() {
        appIconImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(20)
            make.size.equalTo(60)
        }
        
        appTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(appIconImage.snp.trailing).offset(12)
            make.centerY.equalTo(appIconImage.snp.centerY)
            make.trailing.equalTo(downloadButton.snp.leading).offset(-12)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(appIconImage.snp.centerY)
            make.width.equalTo(80)
        }
        
        subContentsStackView.snp.makeConstraints { make in
            make.top.equalTo(appIconImage.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        screenshotStackView.snp.makeConstraints { make in
            make.top.equalTo(subContentsStackView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureContent(searchApp: SearchApp) {
        appIconImage.setImage(imageUrl: searchApp.artworkUrl60)
        appTitleLabel.text = searchApp.trackName
        ratingView.setRating(rating: searchApp.averageUserRating)
        companyLabel.text = searchApp.sellerName
        categoryLabel.text = searchApp.genres.first
        screenshotImageList.indices.forEach { i in
            if i < searchApp.screenshotUrls.count {
                screenshotImageList[i].setImage(imageUrl: searchApp.screenshotUrls[i])
            } else {
                screenshotImageList[i].setDefaultImage()
            }
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
