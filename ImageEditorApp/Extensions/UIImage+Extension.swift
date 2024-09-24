//
//  UIImage+Extension.swift
//  ImageEditorApp
//
//  Created by Арсений Варицкий on 23.09.24.
//

import Foundation
import UIKit

extension UIImage {
    func blackAndWhite() -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: "CIPhotoEffectMono")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputCIImage = filter?.outputImage else {
            return nil
        }
        let context = CIContext()

        guard let cgImageResult = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImageResult, scale: self.scale, orientation: self.imageOrientation)
    }
}
