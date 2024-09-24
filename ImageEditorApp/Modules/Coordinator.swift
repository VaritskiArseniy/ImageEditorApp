//
//  Coordinator.swift
//  ImageEditorApp
//
//  Created by Арсений Варицкий on 23.09.24.
//

import Foundation
import UIKit

final class Coordinator {
    
    private let assembly: Assembly
    private var navigationController = UINavigationController()
    
    init(assembly: Assembly) {
        self.assembly = assembly
    }
    
    func startMain(window: UIWindow) {
        let mainViewController = assembly.makeMain(output: self)
        let settingsViewController = assembly.makeSettings(output: self)
        
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
        
        let tabs: [TabBarItem] = [
            .init(
                item: .init(
                    title: "Main",
                    image: UIImage(systemName: "photo.artframe"),
                    tag: .zero),
                viewController: mainNavigationController
            ),
            .init(
                item: .init(
                    title: "Settings",
                    image: UIImage(systemName: "gear"),
                    tag: 1),
                viewController: settingsNavigationController
            )
        ]
        
        let viewController = assembly.makeTabbar(tabs: tabs)
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension Coordinator: MainOutput { }
extension Coordinator: SettingsOutput { }
