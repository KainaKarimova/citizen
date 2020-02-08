//
//  STZhiHuLoading.swift
//  Citizen
//
//  Created by Karina Karimova on 9/17/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

class STZhiHuLoading: UIView {
  
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

extension STZhiHuLoading {
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
    cycleLayer.frame = bounds
    cycleLayer.path = UIBezierPath(ovalIn: bounds).cgPath
  }
}

extension STZhiHuLoading: STLoadingConfig {
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

extension STZhiHuLoading: STLoadingable {
  internal func startLoading() {
    guard !isLoading else {
      return
    }
    isLoading = true
    self.alpha = 1
    
    let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
    strokeStartAnimation.fromValue = -1
    strokeStartAnimation.toValue = 1.0
    
    let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
    strokeEndAnimation.fromValue = 0
    strokeEndAnimation.toValue = 1.0
    
    let animationGroup = CAAnimationGroup()
    animationGroup.duration = animationDuration
    animationGroup.repeatCount = Float.infinity
    animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
    cycleLayer.add(animationGroup, forKey: "animationGroup")
    
    let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
    rotateAnimation.fromValue = 0
    rotateAnimation.toValue = Double.pi * 2
    rotateAnimation.repeatCount = Float.infinity
    rotateAnimation.duration = animationDuration * 4
    cycleLayer.add(rotateAnimation, forKey: "rotateAnimation")
  }
  
  internal func stopLoading(finish: STEmptyCallback? = nil) {
    guard isLoading else {
      return
    }
    
    UIView.animate(withDuration: 0.2, animations: { () -> Void in
      self.alpha = 0
    }, completion: { _ in
      self.cycleLayer.removeAllAnimations()
      self.isLoading = false
      finish?()
    })
  }
}
