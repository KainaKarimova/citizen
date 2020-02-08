//
//  ChangePasswordRouter.swift
//  Citizen
//
//  Created by Karina Karimova on 9/29/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import UIKit

class ChangePasswordRouter {
  
  // MARK: Properties
  
  weak var view: UIViewController?
  
  // MARK: Static methods
  
  static func setupModule(phone: String?, completion: (() -> Void)?, onBackAction: (() -> Void)?) -> ChangePasswordViewController {
    let viewController = ChangePasswordViewController()
    let presenter = ChangePasswordPresenter()
    let router = ChangePasswordRouter()
    let interactor = ChangePasswordInteractor()
    
    viewController.presenter =  presenter
    
    presenter.successCompletion = completion
    presenter.onBackAction = onBackAction
    presenter.phone = phone
    
    presenter.view = viewController
    presenter.indicatableView = viewController
    presenter.router = router
    presenter.interactor = interactor
    
    router.view = viewController
    
    interactor.output = presenter
    
    return viewController
  }
}

extension ChangePasswordRouter: ChangePasswordWireframe {
  // TODO: Implement wireframe methods
  
  func popBack() {
    self.view?.navigationController?.popViewController(animated: true)
  }
  
}
