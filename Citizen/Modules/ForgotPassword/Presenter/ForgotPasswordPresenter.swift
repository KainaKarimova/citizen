//
//  ForgotPasswordPresenter.swift
//  Citizen
//
//  Created by Karina Karimova on 9/29/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

class ForgotPasswordPresenter: CommonPresenter {
  
  // MARK: Properties
  
  weak var view: ForgotPasswordView?
  var router: ForgotPasswordWireframe?
  var interactor: ForgotPasswordUseCase?
}

extension ForgotPasswordPresenter: ForgotPasswordPresentation {
  // TODO: implement presentation methods
  func refresh() {
    
  }
  
  func didTapClose() {
    router?.popBack()
  }
  
  func didTapForget(phone: String) {
    router?.presentPhoneVerification(phone: phone)
  }
  
  func checkIfUserExists(_ phone: String) {
    UserAPIService.checkIfUserExists(phoneNumber: phone) { (exists, error) in
      if self.handleError(error as NSError?) == false {
        if let exists = exists {
          self.view?.updateWith(exists: exists)
        }
      }
    }
  }
}

extension ForgotPasswordPresenter: ForgotPasswordInteractorOutput {
  // TODO: implement interactor output methods
  
}
