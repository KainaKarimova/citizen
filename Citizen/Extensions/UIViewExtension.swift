//
//  UIViewExtension.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

extension UIView {
  
  func addConstraints(format: String, views: UIView...) {
    var viewsDictionary = [String : UIView]()
    for (index, view) in views.enumerated() {
      let key = "v\(index)"
      viewsDictionary[key] = view
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
  }
  
  func shake() {
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = 0.05
    animation.repeatCount = 4
    animation.autoreverses = true
    animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 4, y: self.center.y))
    animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 4, y: self.center.y))
    self.layer.add(animation, forKey: "position")
  }
  
  func addCornerRadiusAnimation(from: CGFloat, to: CGFloat, duration: CFTimeInterval) {
    let animation = CABasicAnimation(keyPath:"cornerRadius")
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    animation.fromValue = from
    animation.toValue = to
    animation.duration = duration
    layer.add(animation, forKey: "cornerRadius")
    layer.cornerRadius = to
  }
  
  func addShadow(cornerRadius: CGFloat = 5.0) {
    layer.cornerRadius = cornerRadius
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
    layer.shadowRadius = 4.0
    layer.shadowOpacity = 0.4
  }
  
  
}
