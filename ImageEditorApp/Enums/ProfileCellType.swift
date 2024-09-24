//
//  ProfileCellType.swift
//  ImageEditorApp
//
//  Created by Арсений Варицкий on 24.09.24.
//

import Foundation
import UIKit

enum ProfileCellType {
    case about
    
    var label: String {
        switch self {
        case .about:
            return "About us"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .about:
            return UIImage(resource: R.image.aboutIcon) ?? UIImage()
        }
    }
}
