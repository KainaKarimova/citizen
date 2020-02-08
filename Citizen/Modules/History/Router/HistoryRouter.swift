//
//  HistoryRouter.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import UIKit

class HistoryRouter {
  
  // MARK: Properties
  
  weak var view: UIViewController?
  
  // MARK: Static methods
  
  static func setupModule() -> HistoryViewController {
    let viewController = HistoryViewController()
    let presenter = HistoryPresenter()
    let router = HistoryRouter()
    let interactor = HistoryInteractor()
    
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

extension HistoryRouter: HistoryWireframe {
  // TODO: Implement wireframe methods
  func popBack() {
    self.view?.navigationController?.popViewController(animated: true)
  }
}
