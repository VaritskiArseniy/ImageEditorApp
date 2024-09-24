//
//  Assembly.swift
//  ImageEditorApp
//
//  Created by Арсений Варицкий on 23.09.24.
//

import Foundation
import UIKit

final class Assembly {
    
    func makeMain(output: MainOutput) -> UIViewController {
        let viewModel = MainViewModel(output: output)
        let view = MainViewController(viewModel: viewModel)
        viewModel.view = view
        return view
    }
    
    func makeSettings(output: SettingsOutput) -> UIViewController {
        let viewModel = SettingsViewModel(output: output)
        let view = SettingsViewController(viewModel: viewModel)
        viewModel.view = view
        return view
    }
    
    func makeTabbar(tabs: [TabBarItem]) -> UIViewController {
        let controller = UITabBarController()
        controller.navigationItem.hidesBackButton = true
        controller.tabBar.tintColor = .systemBlue
        controller.tabBar.backgroundColor = .systemGray5
        controller.viewControllers = tabs.compactMap {
            let vc = $0.viewController
            vc.tabBarItem = $0.item
            return vc
        }
        return controller
    }
}
