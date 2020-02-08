//
//  STGlassesLoading.swift
//  Citizen
//
//  Created by Karina Karimova on 9/17/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

class STGlassesLoading: UIView {
  
  fileprivate var spotGroup: [CAShapeLayer] = []
  fileprivate let spotCount: Int = 3
  
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

extension STGlassesLoading {
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

extension STGlassesLoading {
  fileprivate func generalGroupAnimation(path: UIBezierPath, needRmoveOnCompletion: Bool, beginTime: CFTimeInterval) -> CAAnimationGroup {
    let pathToLeftAnimation = CAKeyframeAnimation(keyPath: "position")
    pathToLeftAnimation.path = path.cgPath
    pathToLeftAnimation.calculationMode = kCAAnimationPaced
    pathToLeftAnimation.duration = animationDuration / 2.0
    if needRmoveOnCompletion {
      pathToLeftAnimation.fillMode = kCAFillModeForwards
      pathToLeftAnimation.isRemovedOnCompletion = false
    }
    
    let delayGroupAnimation = CAAnimationGroup()
    delayGroupAnimation.animations = [pathToLeftAnimation]
    delayGroupAnimation.duration = animationDuration
    delayGroupAnimation.repeatCount = Float.infinity
    
    if beginTime != 0 {
      delayGroupAnimation.beginTime = CACurrentMediaTime() + beginTime
    }
    
    return delayGroupAnimation
  }
}

extension STGlassesLoading: STLoadingConfig {
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

extension STGlassesLoading: STLoadingable {
  internal func startLoading() {
    guard !isLoading else {
      return
    }
    updateUI()
    isLoading = true
    alpha = 1
    
    let spotLayer1: CAShapeLayer = spotGroup[0]
    let spotLayer2: CAShapeLayer = spotGroup[1]
    let spotLayer3: CAShapeLayer = spotGroup[2]
    
    let radius = bounds.width / CGFloat(spotCount - 1) / 2
    let arcCenterLeft = CGPoint(x: radius, y: spotLayer1.frame.midY)
    let arcCenterRight = CGPoint(x: bounds.width - radius, y: arcCenterLeft.y)
    
    let pathToRight1 = UIBezierPath(arcCenter: arcCenterLeft, radius: radius, startAngle: CGFloat.pi, endAngle: 0, clockwise: true)
    let pathToRight2 = UIBezierPath(arcCenter: arcCenterRight, radius: radius, startAngle: CGFloat.pi, endAngle: 0, clockwise: true)
    pathToRight1.append(pathToRight2)
    
    let pathToRightAnimation1 = CAKeyframeAnimation(keyPath: "position")
    pathToRightAnimation1.path = pathToRight1.cgPath
    pathToRightAnimation1.calculationMode = kCAAnimationPaced
    pathToRightAnimation1.duration = animationDuration
    pathToRightAnimation1.repeatCount = Float.infinity
    spotLayer1.add(pathToRightAnimation1, forKey: "pathToRightAnimation1")
    
    let pathToLeft1 = UIBezierPath(arcCenter: arcCenterLeft, radius: radius, startAngle: 0, endAngle: CGFloat.pi, clockwise: true)
    let spot2Animation = generalGroupAnimation(path: pathToLeft1, needRmoveOnCompletion: true, beginTime: 0)
    spotLayer2.add(spot2Animation, forKey: "spot2Animation")
    
    let pathToLeft2 = UIBezierPath(arcCenter: arcCenterRight, radius: radius, startAngle: 0, endAngle: CGFloat.pi, clockwise: true)
    let spot3Animation = generalGroupAnimation(path: pathToLeft2, needRmoveOnCompletion: false, beginTime: animationDuration / 2.0)
    spotLayer3.add(spot3Animation, forKey: "spot3Animation")
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
