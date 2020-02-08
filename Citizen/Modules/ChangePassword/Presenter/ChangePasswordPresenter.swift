//
//  ChangePasswordPresenter.swift
//  Citizen
//
//  Created by Karina Karimova on 9/29/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

class ChangePasswordPresenter: CommonPresenter {
  
  // MARK: Properties
  
  weak var view: ChangePasswordView?
  var router: ChangePasswordWireframe?
  var interactor: ChangePasswordUseCase?
  var phone: String?
  var successCompletion: (() -> Void)?
  var onBackAction: (() -> Void)?
}

extension ChangePasswordPresenter: ChangePasswordPresentation {
  // TODO: implement presentation methods
  func refresh() {
    
  }
  
  func didTapClose() {
    if let action = onBackAction {
      action()
    } else {
      router?.popBack()
    }
  }
  
  func didTapChange(password: String) {
    view?.showActivityIndicator()
    interactor?.changePasswordTo(password: password, phone: phone ?? "")
  }
  
}

extension ChangePasswordPresenter: ChangePasswordInteractorOutput {
  // TODO: implement interactor output methods
  func changeSuccess() {
    view?.showSuccess()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      
      if self.successCompletion != nil {
        self.successCompletion!()
      }
    }
  }
  
}
