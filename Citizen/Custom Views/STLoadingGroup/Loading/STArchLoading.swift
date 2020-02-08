//
//  STArchLoading.swift
//  Citizen
//
//  Created by Karina Karimova on 9/17/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

class STArchLoading: UIView {
  
  fileprivate let spotCount = 3
  fileprivate var spotGroup: [CAShapeLayer] = []
  fileprivate var shadowGroup: [CALayer] = []
  
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

extension STArchLoading {
  fileprivate func setupUI() {
    for _ in 0 ..< spotCount {
      let spotLayer = CAShapeLayer()
      spotLayer.lineCap = "round"
      spotLayer.lineJoin = "round"
      spotLayer.lineWidth = lineWidth
      spotLayer.fillColor = UIColor.clear.cgColor
      spotLayer.strokeColor = loadingTintColor.cgColor
      spotLayer.strokeEnd = 0.000001
      layer.addSublayer(spotLayer)
      spotGroup.append(spotLayer)
      
      spotLayer.shadowColor = UIColor.black.cgColor
      spotLayer.shadowOffset = CGSize(width: 10, height: 10)
      spotLayer.shadowOpacity = 0.2
      spotLayer.shadowRadius = 10
    }
  }
  
  fileprivate func updateUI() {
    for i in 0 ..< spotCount {
      let spotLayer = spotGroup[i]
      let spotWidth = bounds.width * CGFloat((spotCount - i)) * 0.6
      spotLayer.bounds = CGRect(x: 0, y: 0, width: spotWidth, height: spotWidth)
      spotLayer.position = CGPoint(x: bounds.width * 1.1, y: bounds.height / 2.0)
      spotLayer.path = UIBezierPath(arcCenter: CGPoint(x: spotWidth / 2.0 - bounds.width * 0.3, y: spotWidth / 2.0), radius: spotWidth * 0.25, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 2, clockwise: true).cgPath
    }
  }
}

extension STArchLoading: STLoadingConfig {
  var animationDuration: TimeInterval {
    return 1
  }
  
  var lineWidth: CGFloat {
    return 8
  }
  
  var loadingTintColor: UIColor {
    return .white
  }
}

extension STArchLoading: STLoadingable {
  internal func startLoading() {
    guard !isLoading else {
      return
    }
    isLoading = true
    alpha = 1
    
    for i in 0 ..< spotCount {
      let spotLayer = spotGroup[i]
      
      let transformAnimation = CABasicAnimation(keyPath: "position.x")
      transformAnimation.fromValue = bounds.width * 1.1
      transformAnimation.toValue = bounds.width * 0.5
      transformAnimation.duration = animationDuration
      transformAnimation.fillMode = kCAFillModeForwards
      transformAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
      transformAnimation.isRemovedOnCompletion = false
      
      let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
      strokeEndAnimation.fromValue = 0
      strokeEndAnimation.toValue = 1
      
      let strokeStartAniamtion = CABasicAnimation(keyPath: "strokeStart")
      strokeStartAniamtion.fromValue = -1
      strokeStartAniamtion.toValue = 1
      
      let strokeAnimationGroup = CAAnimationGroup()
      strokeAnimationGroup.duration = (animationDuration - TimeInterval(3 - i) * animationDuration * 0.1) * 0.8
      strokeAnimationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
      strokeAnimationGroup.fillMode = kCAFillModeForwards
      strokeAnimationGroup.isRemovedOnCompletion = false
      strokeAnimationGroup.animations = [strokeStartAniamtion, strokeEndAnimation]
      
      let animationGroup = CAAnimationGroup()
      animationGroup.duration = animationDuration
      animationGroup.repeatCount = Float.infinity
      animationGroup.animations = [transformAnimation, strokeAnimationGroup]
      spotLayer.add(animationGroup, forKey: "animationGroup")
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
