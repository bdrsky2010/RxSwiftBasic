//
//  UIViewController+.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/4/24.
//

import UIKit

extension UIViewController {
    func changeRootViewController(_ rootViewController: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let window = (windowScene.delegate as? SceneDelegate)?.window else { return }
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
