//
//  SettingsViewModel.swift
//  ImageEditorApp
//
//  Created by Арсений Варицкий on 23.09.24.
//

import Foundation

class SettingsViewModel {
    
    weak var view: SettingsViewControllerInterface?
    private weak var output: SettingsOutput?
    
    init(output: SettingsOutput) {
        self.output = output
    }
}
