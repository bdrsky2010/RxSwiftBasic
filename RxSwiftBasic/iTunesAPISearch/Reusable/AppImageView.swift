//
//  AppImageView.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/11/24.
//

import UIKit

import Kingfisher
import SnapKit

final class AppImageView: UIImageView {
    
    init(cornerRadius: CGFloat) {
        super.init(frame: .zero)
        contentMode = .scaleToFill
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
    func setImage(imageUrl: String) {
        kf.setImage(with: URL(string: imageUrl), options: [.transition(.fade(1))])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
