//
//  SignInRouter.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import UIKit
import SideMenuSwift

class SignInRouter {
  
  // MARK: Properties
  
  weak var view: UIViewController?
  
  // MARK: Static methods
  
  static func setupModule() -> SignInViewController {
    let viewController = SignInViewController()
    let presenter = SignInPresenter()
    let router = SignInRouter()
    let interactor = SignInInteractor()
    
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

extension SignInRouter: SignInWireframe {
  // TODO: Implement wireframe methods
  
  func presentMainMenu() {
    RootRouter().presentMainTabScreen(in: UIApplication.shared.keyWindow!)
  }
  
  func presentSignUpPage() {
    let vc = SignUpRouter.setupModule()
    view?.navigationController?.pushViewController(vc, animated: true)
  }
  
  func presentRestorePassword() {
    let vc = ForgotPasswordRouter.setupModule()
    view?.navigationController?.pushViewController(vc, animated: true)
  }
}
