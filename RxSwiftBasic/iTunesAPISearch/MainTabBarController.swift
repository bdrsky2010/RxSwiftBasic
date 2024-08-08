//
//  MainTabBarController.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/8/24.
//

import UIKit

final class MainTabBarController: UITabBarController {
    private enum TabOption: CaseIterable {
        case today
        case game
        case app
        case arcade
        case search
        
        var title: String {
            switch self {
            case .today:
                return "투데이"
            case .game:
                return "게임"
            case .app:
                return "앱"
            case .arcade:
                return "아케이드"
            case .search:
                return "검색"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .today:
                return UIImage(systemName: "doc.text.image")
            case .game:
                return UIImage(systemName: "gamecontroller.fill")
            case .app:
                return UIImage(systemName: "square.stack.3d.up.fill")
            case .arcade:
                return UIImage(systemName: "arcade.stick.console.fill")
            case .search:
                return UIImage(systemName: "magnifyingglass")
            }
        }
        
        var viewController: UIViewController {
            switch self {
            case .today:
                return EmptyViewController()
            case .game:
                return EmptyViewController()
            case .app:
                return EmptyViewController()
            case .arcade:
                return EmptyViewController()
            case .search:
                return iTunesSearchViewController()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewControllers: [UINavigationController] = []
        
        TabOption.allCases.forEach { option in
            let vc = option.viewController
            vc.tabBarItem.image = option.image
            vc.tabBarItem.title = option.title
            vc.navigationItem.title = option.title
            vc.navigationItem.largeTitleDisplayMode = .automatic
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.prefersLargeTitles = true
            viewControllers.append(nav)
        }
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .secondarySystemBackground
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
        tabBar.isTranslucent = true
        setViewControllers(viewControllers, animated: true)
    }
}
