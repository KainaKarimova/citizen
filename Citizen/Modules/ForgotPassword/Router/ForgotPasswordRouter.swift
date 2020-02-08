//
//  ForgotPasswordRouter.swift
//  Citizen
//
//  Created by Karina Karimova on 9/29/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import UIKit
import SideMenuSwift

class ForgotPasswordRouter {
  
  // MARK: Properties
  
  weak var view: UIViewController?
  
  // MARK: Static methods
  
  static func setupModule() -> ForgotPasswordViewController {
    let viewController = ForgotPasswordViewController()
    let presenter = ForgotPasswordPresenter()
    let router = ForgotPasswordRouter()
    let interactor = ForgotPasswordInteractor()
    
    viewController.presenter = presenter
    presenter.view = viewController
    presenter.indicatableView = viewController
    presenter.router = router
    presenter.interactor = interactor
    
    router.view = viewController
    
    interactor.output = presenter
    
    return viewController
  }
}

extension ForgotPasswordRouter: ForgotPasswordWireframe {
  func popBack() {
    self.view?.navigationController?.popViewController(animated: true)
  }
  
  // TODO: Implement wireframe methods
  
  func presentPhoneVerification(phone: String) {
    let vc = PhoneVerificationRouter.setupModule(phone: phone) {
      self.presentChangePassword(phone: phone)
    }
    view?.navigationController?.pushViewController(vc, animated: true)
  }
  
  func presentChangePassword(phone: String) {
    let vc = ChangePasswordRouter.setupModule(phone: phone, completion: {
      RootRouter().presentLoginScreen(in: UIApplication.shared.keyWindow!, isFirstLaunch: false)
    }) {
      self.view?.navigationController?.popToViewController(self.view!, animated: true)
    }
    
    view?.navigationController?.pushViewController(vc, animated: true)
  }
}
