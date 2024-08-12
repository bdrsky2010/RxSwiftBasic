//
//  iTunesDetailScreenshotCollectionViewCell.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/12/24.
//

import UIKit

import SnapKit

final class iTuneDetailScreenshotCollectionViewCell: UICollectionViewCell {
    static let identifier = "iTuneDetailScreenshotCollectionViewCell"
    
    private let screenshotImage = AppImageView(cornerRadius: 12)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(screenshotImage)
        screenshotImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setImage(imageUrl: String) {
        screenshotImage.setImage(imageUrl: imageUrl)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
