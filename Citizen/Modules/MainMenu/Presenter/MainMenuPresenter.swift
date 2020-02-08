//
//  MainMenuPresenter.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import UIKit

class MainMenuPresenter: CommonPresenter {
  
  // MARK: Properties
  
  weak var view: MainMenuView?
  var router: MainMenuWireframe?
  var interactor: MainMenuUseCase?
}

extension MainMenuPresenter: MainMenuPresentation {
  // TODO: implement presentation methods
  func refresh() {
    
  }
  
  func didSelect(presentationData: MenuCellPresentation) {
    switch presentationData.type {
    case .profile:
      router?.showProfile()
    case .info:
      router?.showInfo()
    case .history:
      router?.showHistory()
    case .exit:
      view?.showActivityIndicator()
      interactor?.signOut()
    }
  }
}

extension MainMenuPresenter: MainMenuInteractorOutput {
  // TODO: implement interactor output methods
  func signOutSuccess() {
    view?.hideActivityIndicator()
    UserProfileManager.shared.userLoggedOut()
  }
}
