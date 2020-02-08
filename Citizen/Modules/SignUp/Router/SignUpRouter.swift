//
//  SignUpRouter.swift
//  Citizen
//
//  Created by Karina Karimova on 9/15/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import UIKit

class SignUpRouter {
  
  // MARK: Properties
  
  weak var view: UIViewController?
  
  // MARK: Static methods
  
  static func setupModule() -> SignUpViewController {
    let viewController = SignUpViewController()
    let presenter = SignUpPresenter()
    let router = SignUpRouter()
    let interactor = SignUpInteractor()
    
    viewController.presenter =  presenter
    
    presenter.view = viewController
    presenter.indicatableView = viewController
    presenter.router = router
    presenter.interactor = interactor
    
    router.view = viewController
    
    interactor.output = presenter
    
    return viewController
  }
}

extension SignUpRouter: SignUpWireframe {
  // TODO: Implement wireframe methods
  
  func presentSMSLogin(userData: UserModel) {
    let vc = SignUpSMSRouter.setupModule()
    vc.userData = userData
    view?.navigationController?.pushViewController(vc, animated: true)
  }
  
  func popBack() {
    self.view?.navigationController?.popViewController(animated: true)
  }
  
}
