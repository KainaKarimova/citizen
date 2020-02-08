//
//  SignInContract.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

protocol SignInView: IndicatableView {
  // TODO: Declare view methods
  func updateWith(exists: Bool)
}

protocol SignInPresentation: class {
  // TODO: Declare presentation methods
  func refresh()
  func didTapSignIn(phone: String, password: String)
  func didTapSignUp()
  func didTapForget(phone: String)
  func checkIfUserExists(_ phone: String)
}

protocol SignInUseCase: class {
  // TODO: Declare use case methods
  func signIn(phone: String, password: String)
}

protocol SignInInteractorOutput: InteractorOutputProtocol {
  // TODO: Declare interactor output methods
  func invalidCredentials()
  func signInSuccess()
}

protocol SignInWireframe: class {
  // TODO: Declare wireframe methods
  func presentMainMenu()
  func presentSignUpPage()
  func presentRestorePassword()
}
