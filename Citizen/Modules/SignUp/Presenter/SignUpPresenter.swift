//
//  SignUpPresenter.swift
//  Citizen
//
//  Created by Karina Karimova on 9/15/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

class SignUpPresenter: CommonPresenter {
  
  // MARK: Properties
  
  weak var view: SignUpView?
  var router: SignUpWireframe?
  var interactor: SignUpUseCase?
  
  var userData: UserModel?
}

extension SignUpPresenter: SignUpPresentation {
  // TODO: implement presentation methods
  func refresh() {
    
  }
  
  func didTapSignUp(userData: UserModel) {
    
    self.userData = userData
    
    guard let phone = userData.phone else { return }
    
    view?.showActivityIndicator()
    interactor?.verifyPhoneNumber(phone)
  }
  
  func didTapClose() {
    router?.popBack()
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

extension SignUpPresenter: SignUpInteractorOutput {
  // TODO: implement interactor output methods
  func sentSMS(_ phone: String) {
    self.view?.hideActivityIndicator()
    //    self.view?.showSuccess()
    if let userData = self.userData {
      router?.presentSMSLogin(userData: userData)
    }
  }
}
