//
//  SignInPresenter.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

class SignInPresenter: CommonPresenter {
  
  // MARK: Properties
  
  weak var view: SignInView?
  var router: SignInWireframe?
  var interactor: SignInUseCase?
}

extension SignInPresenter: SignInPresentation {
  // TODO: implement presentation methods
  func refresh() {

  }
  
  func didTapSignIn(phone: String, password: String) {
//    router?.presentMainMenu()
//    Auth.auth().languageCode = "fr"
//    view?.showActivityIndicator()
    view?.showActivityIndicator()
    interactor?.signIn(phone: phone, password: password)
  }
  
  func didTapSignUp() {
    router?.presentSignUpPage()
  }
  
  func didTapForget(phone: String) {
    router?.presentRestorePassword()
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

extension SignInPresenter: SignInInteractorOutput {
  // TODO: implement interactor output methods
  func invalidCredentials() {
    view?.show("Invalid credentials")
  }
  
  func signInSuccess() {
    view?.hideActivityIndicator()
    UserProfileManager.shared.userLoggedIn()
    router?.presentMainMenu()
  }
  
}
