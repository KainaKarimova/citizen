//
//  STBouncyPreloaderLoading.swift
//  Citizen
//
//  Created by Karina Karimova on 9/17/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

class STBouncyPreloaderLoading: UIView {
  
  fileprivate let spotLayer: CAShapeLayer = CAShapeLayer()
  fileprivate let spotReplicatorLayer: CAReplicatorLayer = CAReplicatorLayer()
  fileprivate let spotCount = 3
  
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

extension STBouncyPreloaderLoading {
  fileprivate func setupUI() {
    self.alpha = 0
    
    spotLayer.frame = CGRect(x: 0, y: 0, width: lineWidth, height: lineWidth)
    spotLayer.lineCap = kCALineCapRound
    spotLayer.lineJoin = kCALineJoinRound
    spotLayer.lineWidth = lineWidth
    spotLayer.fillColor = loadingTintColor.cgColor
    spotLayer.strokeColor = loadingTintColor.cgColor
    spotLayer.path = UIBezierPath(ovalIn: spotLayer.bounds).cgPath
    spotReplicatorLayer.addSublayer(spotLayer)
    
    spotReplicatorLayer.instanceCount = spotCount
    spotReplicatorLayer.instanceDelay = animationDuration / 5
    layer.addSublayer(spotReplicatorLayer)
  }
  
  fileprivate func updateUI() {
    spotLayer.frame = CGRect(x: lineWidth / 2.0, y: (bounds.height - lineWidth) / 2.0, width: lineWidth, height: lineWidth)
    spotReplicatorLayer.frame = bounds
    spotReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(bounds.width / CGFloat(spotCount), 0, 0)
  }
}

extension STBouncyPreloaderLoading: STLoadingConfig {
  var animationDuration: TimeInterval {
    return 0.5
  }
  
  var lineWidth: CGFloat {
    return 18
  }
  
  var loadingTintColor: UIColor {
    return DesignUtil.citizenThemeGreen()
  }
}

extension STBouncyPreloaderLoading: STLoadingable {
  internal func startLoading() {
    guard !isLoading else {
      return
    }
    isLoading = true
    
    UIView.animate(withDuration: 0.5) { () -> Void in
      self.alpha = 1
    }
    
    let centerY = bounds.height / 2.0
    let downY = centerY + 25.0
    
    let positionAnimation = CAKeyframeAnimation(keyPath: "position.y")
    positionAnimation.beginTime = CACurrentMediaTime() + 0.5
    positionAnimation.values = [centerY, downY, centerY, centerY]
    positionAnimation.keyTimes = [0.0, 0.33, 0.63, 1.0]
    positionAnimation.repeatCount = Float.infinity
    positionAnimation.duration = animationDuration + 0.4
    spotLayer.add(positionAnimation, forKey: "positionAnimation")
  }
  
  internal func stopLoading(finish: STEmptyCallback? = nil) {
    guard isLoading else {
      return
    }
    UIView.animate(withDuration: 0.5, animations: {
      self.alpha = 0
    }, completion: { _ in
      self.isLoading = false
      self.spotLayer.removeAllAnimations()
      
      finish?()
    })
  }
}
