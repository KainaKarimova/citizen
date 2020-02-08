//
//  SignUpSMSPresenter.swift
//  Citizen
//
//  Created by Karina Karimova on 9/23/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import FirebaseAuth

class SignUpSMSPresenter: CommonPresenter {
  
  // MARK: Properties
  
  weak var view: SignUpSMSView?
  var router: SignUpSMSWireframe?
  var interactor: SignUpSMSUseCase?
}

extension SignUpSMSPresenter: SignUpSMSPresentation {
  // TODO: implement presentation methods
  func refresh() {
    
  }
  func didTapLeftButton() {
    router?.popBack()
  }
  
  func didTapSubmit(verificationCode: String, userData: UserModel) {
    view?.showActivityIndicator()
    interactor?.signUp(verificationCode: verificationCode, userData: userData)
  }
}

extension SignUpSMSPresenter: SignUpSMSInteractorOutput {
  // TODO: implement interactor output methods
  func signUpSuccess() {
    view?.showSuccess()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      UserProfileManager.shared.userLoggedIn()
      RootRouter().presentMainTabScreen(in: UIApplication.shared.keyWindow!)
    }
    
  }
  
  func goBack() {
    view?.hideActivityIndicator()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
      self.router?.popBack()
    })
  }
}
