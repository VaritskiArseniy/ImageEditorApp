//
//  MainViewModel.swift
//  ImageEditorApp
//
//  Created by Арсений Варицкий on 23.09.24.
//

import Foundation

class MainViewModel {
    
    weak var view: MainViewControllerInterface?
    private weak var output: MainOutput?
    
    init(output: MainOutput) {
        self.output = output
    }
}
