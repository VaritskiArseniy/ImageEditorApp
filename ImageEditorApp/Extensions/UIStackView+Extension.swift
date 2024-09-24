//
//  UIStackView+Extension.swift
//  ImageEditorApp
//
//  Created by Арсений Варицкий on 23.09.24.
//

import Foundation
import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
