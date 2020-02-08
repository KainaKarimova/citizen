//
//  InfoRouter.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import UIKit

class InfoRouter {
  
  // MARK: Properties
  
  weak var view: UIViewController?
  
  // MARK: Static methods
  
  static func setupModule() -> InfoViewController {
    let viewController = InfoViewController()
    let presenter = InfoPresenter()
    let router = InfoRouter()
    let interactor = InfoInteractor()
    
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

extension InfoRouter: InfoWireframe {
  // TODO: Implement wireframe methods
  func popBack() {
    self.view?.navigationController?.popViewController(animated: true)
  }
}
