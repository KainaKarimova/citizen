//
//  CommonPresenter.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import Firebase

class CommonPresenter {
  weak var indicatableView: IndicatableView?
  
  func handleError(_ error: NSError?) -> Bool {
    if let error = error {
      if error.code == NSURLErrorTimedOut || error.code == -1009 {
        if indicatableView is NetworkHandlingView {
          (indicatableView as! NetworkHandlingView).showNoNetwork()
        }
        indicatableView?.showNetworkError()
      }
      else if error.code == NSURLErrorCancelled {
        // don't show anything if it's cancelled
      }
      else if error.code == 0 {
        indicatableView?.showError(with: error.domain)
      }
      else {
//        indicatableView?.showError(with: error.localizedDescription)
        indicatableView?.show(error.localizedDescription)
      }
      
      return true
    } else {
      if indicatableView is NetworkHandlingView {
        (indicatableView as! NetworkHandlingView).hideNoNetwork()
      }
      return false
    }
  }
  
  func handleErrorMessage(_ error: NSError?) -> Bool {
    if let error = error {
      if error.code == NSURLErrorTimedOut || error.code == -1009 {
        if indicatableView is NetworkHandlingView {
          (indicatableView as! NetworkHandlingView).showNoNetwork()
        }
        indicatableView?.showNetworkError()
      }
      else if error.code == NSURLErrorCancelled {
        // don't show anything if it's cancelled
      }
      else if error.code == 0 {
        indicatableView?.show(error.domain)
      }
      else {
        indicatableView?.show(error.localizedDescription)
      }
      
      return true
    } else {
      if indicatableView is NetworkHandlingView {
        (indicatableView as! NetworkHandlingView).hideNoNetwork()
      }
      return false
    }
  }
  
  func handleFirebaseError(_ error: NSError?, completion: ( () -> Void)?) -> Bool {
    if let error = error {
      switch error.code {
      case AuthErrorCode.invalidVerificationCode.rawValue:
        indicatableView?.showAlertWith(message: "Введен неверный код!", completion: completion)
        return true
      case AuthErrorCode.sessionExpired.rawValue:
        indicatableView?.showAlertWith(message: "Код устарел! Попробуйте снова", completion: completion)
        return true
      default:
        indicatableView?.showAlertWith(message: error.localizedDescription, completion: completion)
        _ = handleError(error)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
          if completion != nil {
            completion!()
          }
        }
        return true
      }
    } else {
      if indicatableView is NetworkHandlingView {
        (indicatableView as! NetworkHandlingView).hideNoNetwork()
      }
      return false
    }
  }
  
}
