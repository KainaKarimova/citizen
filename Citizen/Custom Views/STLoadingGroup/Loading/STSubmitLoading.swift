//
//  STSubmitLoading.swift
//  Citizen
//
//  Created by Karina Karimova on 9/17/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

class STSubmitLoading: UIView {
  
  fileprivate let cycleLayer: CAShapeLayer = CAShapeLayer()
  
  internal var isLoading: Bool = false
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  override func didMoveToWindow() {
    super.didMoveToWindow()
    updateUI()
  }
}

extension STSubmitLoading {
  fileprivate func setupUI() {
    cycleLayer.lineCap = kCALineCapRound
    cycleLayer.lineJoin = kCALineJoinRound
    cycleLayer.lineWidth = lineWidth
    cycleLayer.fillColor = UIColor.clear.cgColor
    cycleLayer.strokeColor = loadingTintColor.cgColor
    cycleLayer.strokeEnd = 0
    
    layer.addSublayer(cycleLayer)
  }
  
  fileprivate func updateUI() {
    cycleLayer.bounds = bounds
    cycleLayer.position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
    cycleLayer.path = UIBezierPath(ovalIn: bounds).cgPath
  }
}

extension STSubmitLoading: STLoadingConfig {
  var animationDuration: TimeInterval {
    return 1
  }
  
  var lineWidth: CGFloat {
    return 4
  }
  
  var loadingTintColor: UIColor {
    return .white
  }
}

extension STSubmitLoading: STLoadingable {
  internal func startLoading() {
    guard !isLoading else {
      return
    }
    isLoading = true
    
    self.alpha = 1
    
    let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
    strokeEndAnimation.fromValue = 0
    strokeEndAnimation.toValue = 0.25
    strokeEndAnimation.fillMode = kCAFillModeForwards
    strokeEndAnimation.isRemovedOnCompletion = false
    strokeEndAnimation.duration = animationDuration / 4.0
    cycleLayer.add(strokeEndAnimation, forKey: "strokeEndAnimation")
    
    let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
    rotateAnimation.fromValue = 0
    rotateAnimation.toValue = Double.pi * 2
    rotateAnimation.duration = animationDuration
    rotateAnimation.beginTime = CACurrentMediaTime() + strokeEndAnimation.duration
    rotateAnimation.repeatCount = Float.infinity
    cycleLayer.add(rotateAnimation, forKey: "rotateAnimation")
  }
  
  internal func stopLoading(finish: STEmptyCallback? = nil) {
    guard isLoading else {
      return
    }
    
    let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
    strokeEndAnimation.toValue = 1
    strokeEndAnimation.fillMode = kCAFillModeForwards
    strokeEndAnimation.isRemovedOnCompletion = false
    strokeEndAnimation.duration = animationDuration * 3.0 / 4.0
    cycleLayer.add(strokeEndAnimation, forKey: "catchStrokeEndAnimation")
    
    UIView.animate(withDuration: 0.3, delay: strokeEndAnimation.duration, options: UIViewAnimationOptions(), animations: { () -> Void in
      self.alpha = 0
    }, completion: { _ in
      self.cycleLayer.removeAllAnimations()
      self.isLoading = false
      finish?()
    })
  }
}
