//
//  EmptyViewController.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/8/24.
//

import UIKit

import SnapKit

final class EmptyViewController: UIViewController {
    let appImage = AppImageView(cornerRadius: 12)
    let ratingView = StarRatingView()
    let capsuleButton = CapsuleButton(title: "받기", backgroundColor: .systemGray5, textColor: .systemBlue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(appImage)
        view.addSubview(ratingView)
        view.addSubview(capsuleButton)
        
        appImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(60)
        }
        
        ratingView.snp.makeConstraints { make in
            make.top.equalTo(appImage.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        capsuleButton.snp.makeConstraints { make in
            make.top.equalTo(ratingView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        appImage.setImage(imageUrl: "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/8a/6b/be/8a6bbe5d-1874-6827-d23f-d6c62998447d/AppIcon-0-0-1x_U007emarketing-0-0-0-10-0-0-sRGB-85-220.png/60x60bb.jpg")
        
        ratingView.setRating(rating: 4.17)
    }
}
