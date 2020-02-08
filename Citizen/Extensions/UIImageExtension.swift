//
//  UIImageExtension.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
  public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    guard let cgImage = image?.cgImage else { return nil }
    self.init(cgImage: cgImage)
  }
  
  func makeImageWithColorAndSize(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  func convertToGrayScale() -> UIImage {
    let context = CIContext(options: nil)
    
    var inputImage = CIImage.init(image: self)
    let options: [String: AnyObject] = [CIDetectorImageOrientation:1 as AnyObject]
    let filters = inputImage!.autoAdjustmentFilters(options: options)
    
    for filter: CIFilter in filters {
      filter.setValue(inputImage, forKey: kCIInputImageKey)
      inputImage = filter.outputImage
    }
    
    let cgImage = context.createCGImage(inputImage!, from: inputImage!.extent)
    
    let currentFilter = CIFilter(name: "CIPhotoEffectTonal")
    currentFilter?.setValue(CIImage.init(image: UIImage(cgImage: cgImage!)), forKey: kCIInputImageKey)
    
    let output = currentFilter!.outputImage
    let cgimg = context.createCGImage(output!, from: output!.extent)
    let processedImage = UIImage(cgImage: cgimg!)
    return processedImage
  }
  
  func scaleDownIfNeeded() -> UIImage? {
    let width = self.size.width
    let height = self.size.height
    
    var scaleFactor: CGFloat = 1.0
    
    if height >= width && height >= 1500.0 {
      scaleFactor = 1500.0 / height
    } else if width >= 1500.0 {
      scaleFactor = 1500.0 / width
    }
    
    if scaleFactor < 1.0 {
      let newHeight = height * scaleFactor
      let newWidth = width * scaleFactor
      UIGraphicsBeginImageContext(CGSize.init(width: newWidth, height: newHeight))
      self.draw(in: CGRect(x: 0.0, y: 0.0, width: newWidth, height: newHeight))
      let newImg = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return newImg
    }
    
    return nil
  }
  
  convenience init?(imageName: String) {
    self.init(named: imageName)!
    accessibilityIdentifier = imageName
  }
  
  func imageWithColor (newColor: UIColor?) -> UIImage? {
    
    if let newColor = newColor {
      UIGraphicsBeginImageContextWithOptions(size, false, scale)
      
      let context = UIGraphicsGetCurrentContext()!
      context.translateBy(x: 0, y: size.height)
      context.scaleBy(x: 1.0, y: -1.0)
      context.setBlendMode(.normal)
      
      let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
      context.clip(to: rect, mask: cgImage!)
      
      newColor.setFill()
      context.fill(rect)
      
      let newImage = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext()
      newImage.accessibilityIdentifier = accessibilityIdentifier
      return newImage
    }
    
    if let accessibilityIdentifier = accessibilityIdentifier {
      return UIImage(imageName: accessibilityIdentifier)
    }
    
    return self
  }
  
  
  public func getPixelColor(pos: CGPoint) -> UIColor {
    
    let pixelData = self.cgImage!.dataProvider!.data
    let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
    
    let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
    
    let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
    let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
    let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
    let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
    
    return UIColor(red: r, green: g, blue: b, alpha: a)
  }
  
}
