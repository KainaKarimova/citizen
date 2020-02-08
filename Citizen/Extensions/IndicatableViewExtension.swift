//
//  IndicatableViewExtension.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import PKHUD

extension IndicatableView where Self: UIViewController {
  
  func showActivityIndicator() {
    var onView: UIView!
    if self.navigationController != nil {
      onView = self.navigationController!.view
    } else {
      onView = self.view
    }
    HUD.show(.progress, onView: onView)
  }
  
  func hideActivityIndicator() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      HUD.hide()
    }
  }
  
  func hideActivityIndicatorWith(completion: @escaping() -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      HUD.hide()
      completion()
    }
  }
  
  func showError(with message: String) {
    var onView: UIView!
    if self.navigationController != nil {
      onView = self.navigationController!.view
    } else {
      onView = self.view
    }
    HUD.show(.labeledError(title: Constants.Misc.genericError, subtitle: message), onView: onView)
    HUD.hide(afterDelay: 1.5)
  }
  
  /// without labeledError just message
  func show(_ message: String) {
    var onView: UIView!
    if self.navigationController != nil {
      onView = self.navigationController!.view
    } else {
      onView = self.view
    }
    HUD.show(.label(message), onView: onView)
    HUD.hide(afterDelay: 1.5)
  }
  
  func showNetworkError() {
    var onView: UIView!
    if self.navigationController != nil {
      onView = self.navigationController!.view
    } else {
      onView = self.view
    }
    HUD.show(.labeledError(title: Constants.Misc.genericError, subtitle: Constants.Misc.networkError), onView: onView)
    HUD.hide(afterDelay: 1.5)
  }
  
  func showSuccess() {
    var onView: UIView!
    if self.navigationController != nil {
      onView = self.navigationController?.view
    } else {
      onView = self.view
    }
    HUD.show(.success, onView: onView)
    HUD.hide(afterDelay: 1.5)
  }
  
  func showAlertWith(message: String, completion: (() -> Void)?) {
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
      if completion != nil {
        completion!()
      }
    }
    alert.addAction(okAction)
    
    self.present(alert, animated: true, completion: nil)
  }
  
}
