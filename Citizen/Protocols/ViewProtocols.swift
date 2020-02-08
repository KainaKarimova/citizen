//
//  ViewProtocols.swift
//  Citizen
//
//  Created by Karina Karimova on 9/11/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

protocol IndicatableView: class {
  func showActivityIndicator()
  func showError(with message: String)
  func show(_ message: String)
  func showNetworkError()
  func hideActivityIndicator()
  func hideActivityIndicatorWith(completion: @escaping() -> Void)
  func showSuccess()
  func showAlertWith(message: String, completion: (() -> Void)?)
}

protocol NetworkHandlingView: class {
  func showNoNetwork()
  func hideNoNetwork()
  func showEmptyScreen()
}
