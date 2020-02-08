//
//  PhoneVerificationRouter.swift
//  Citizen
//
//  Created by Karina Karimova on 9/27/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import UIKit

class PhoneVerificationRouter {
  
  // MARK: Properties
  
  weak var view: UIViewController?
  
  // MARK: Static methods
  
  static func setupModule(phone: String, completion: (() -> Void)? ) -> PhoneVerificationViewController {
    let viewController = PhoneVerificationViewController()
    let presenter = PhoneVerificationPresenter()
    let router = PhoneVerificationRouter()
    let interactor = PhoneVerificationInteractor()
    
    viewController.presenter =  presenter
    viewController.phoneNumber = phone
    
    presenter.view = viewController
    presenter.indicatableView = viewController
    presenter.router = router
    presenter.interactor = interactor
    presenter.successCompletion = completion
    
    router.view = viewController
    
    interactor.output = presenter
    
    return viewController
  }
}

extension PhoneVerificationRouter: PhoneVerificationWireframe {
  // TODO: Implement wireframe methods
  func popBack() {
    self.view?.navigationController?.popViewController(animated: true)
  }
}
