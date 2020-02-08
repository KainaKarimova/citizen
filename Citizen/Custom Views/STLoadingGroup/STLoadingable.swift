//
//  STLoadingable.swift
//  Citizen
//
//  Created by Karina Karimova on 9/17/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

typealias STEmptyCallback = () -> ()

protocol STLoadingable {
  var isLoading: Bool { get }
  
  func startLoading()
  func stopLoading(finish: STEmptyCallback?)
}

protocol STLoadingConfig {
  var animationDuration: TimeInterval { get }
  var lineWidth: CGFloat { get }
  var loadingTintColor: UIColor { get }
}
