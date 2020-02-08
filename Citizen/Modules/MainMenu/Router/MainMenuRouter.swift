//
//  MainMenuRouter.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import UIKit

class MainMenuRouter {
  
  // MARK: Properties
  
  weak var view: UIViewController?
  
  // MARK: Static methods
  
  static func setupModule() -> MainMenuViewController {
    let viewController = MainMenuViewController()
    let presenter = MainMenuPresenter()
    let router = MainMenuRouter()
    let interactor = MainMenuInteractor()
    
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

extension MainMenuRouter: MainMenuWireframe {
  // TODO: Implement wireframe methods
  func showProfile() {
    let vc = ProfileRouter.setupModule()
    view?.navigationController?.pushViewController(vc, animated: true)
  }
  
  func showInfo() {
    let vc = InfoRouter.setupModule()
    view?.navigationController?.pushViewController(vc, animated: true)
  }
  
  func showHistory() {
    let vc = HistoryRouter.setupModule()
    view?.navigationController?.pushViewController(vc, animated: true)
  }
  
  func exit() {
    
    RootRouter().presentLoginScreen(in: UIApplication.shared.keyWindow!, isFirstLaunch: false)
  }
}
