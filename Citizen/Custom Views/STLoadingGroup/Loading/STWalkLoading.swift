//
//  STWalkLoading.swift
//  Citizen
//
//  Created by Karina Karimova on 9/17/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

class STWalkLoading: UIView {
  
  fileprivate var spotGroup: [CAShapeLayer] = []
  fileprivate let spotCount = 4
  
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

extension STWalkLoading {
  fileprivate func setupUI() {
    for _ in 0 ..< spotCount {
      let spotLayer = CAShapeLayer()
      spotLayer.bounds = CGRect(x: 0, y: 0, width: lineWidth, height: lineWidth)
      spotLayer.path = UIBezierPath(ovalIn: spotLayer.bounds).cgPath
      spotLayer.fillColor = loadingTintColor.cgColor
      spotLayer.strokeColor = loadingTintColor.cgColor
      layer.addSublayer(spotLayer)
      spotGroup.append(spotLayer)
    }
  }
  
  fileprivate func updateUI() {
    for i in 0 ..< spotCount {
      let spotLayer = spotGroup[i]
      spotLayer.position = CGPoint(x: CGFloat(i) * bounds.width / CGFloat(spotCount - 1), y: bounds.height / 2.0)
    }
  }
}

extension STWalkLoading: STLoadingConfig {
  var animationDuration: TimeInterval {
    return 0.5
  }
  
  var lineWidth: CGFloat {
    return 30
  }
  
  var loadingTintColor: UIColor {
    return DesignUtil.citizenThemeGreen()
  }
}

extension STWalkLoading: STLoadingable {
  internal func startLoading() {
    guard !isLoading else {
      return
    }
    updateUI()
    isLoading = true
    alpha = 1
    
    let spotLayer1 = spotGroup[0]
    let pathAnimation = CAKeyframeAnimation(keyPath: "position")
    pathAnimation.path = UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0), radius: bounds.width / 2.0, startAngle: CGFloat.pi, endAngle: 0, clockwise: true).cgPath
    pathAnimation.calculationMode = kCAAnimationPaced
    pathAnimation.duration = animationDuration
    pathAnimation.repeatCount = Float.infinity
    spotLayer1.add(pathAnimation, forKey: "pathAnimation")
    
    for i in 1 ..< spotCount {
      let spotLayer = spotGroup[i]
      let positionAnimation = CABasicAnimation(keyPath: "position.x")
      positionAnimation.toValue = spotLayer.position.x - bounds.width / CGFloat(spotCount - 1)
      positionAnimation.duration = animationDuration
      positionAnimation.repeatCount = Float.infinity
      spotLayer.add(positionAnimation, forKey: "positionAnimation")
    }
  }
  
  internal func stopLoading(finish: STEmptyCallback? = nil) {
    guard isLoading else {
      return
    }
    UIView.animate(withDuration: 0.5, animations: {
      self.alpha = 0
    }, completion: { _ in
      self.isLoading = false
      for spotLayer in self.spotGroup {
        spotLayer.removeAllAnimations()
      }
      finish?()
    })
  }
}
