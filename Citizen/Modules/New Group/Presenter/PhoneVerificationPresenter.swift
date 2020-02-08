//
//  PhoneVerificationPresenter.swift
//  Citizen
//
//  Created by Karina Karimova on 9/27/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import FirebaseAuth

class PhoneVerificationPresenter: CommonPresenter {
  
  // MARK: Properties
  
  weak var view: PhoneVerificationView?
  var router: PhoneVerificationWireframe?
  var interactor: PhoneVerificationUseCase?
  var successCompletion: (() -> Void)?
}

extension PhoneVerificationPresenter: PhoneVerificationPresentation {
  
  // TODO: implement presentation methods
  func didLoad(phone: String) {
    view?.showActivityIndicator()
    interactor?.verifyPhoneNumber(phone)
  }
  
  func refresh() {
    
  }
  func didTapLeftButton() {
    router?.popBack()
  }
  
  func didTapSubmit(verificationCode: String) {
    view?.showActivityIndicator()
    interactor?.verifyCode(verificationCode)
  }
}

extension PhoneVerificationPresenter: PhoneVerificationInteractorOutput {
  // TODO: implement interactor output methods
  func verificationSuccess() {
    view?.showSuccess()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
      
      if self.successCompletion != nil {
        self.successCompletion!()
      }
    }
    
  }
  
  func goBack() {
    view?.hideActivityIndicator()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
      self.router?.popBack()
    })
  }
  
  func sentSMS(_ phone: String) {
    view?.hideActivityIndicator()
    view?.sentSMS()
  }
}
