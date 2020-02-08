//
//  SignUpContract.swift
//  Citizen
//
//  Created by Karina Karimova on 9/15/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

protocol SignUpView: IndicatableView {
  // TODO: Declare view methods
  func updateWith(exists: Bool)
}

protocol SignUpPresentation: class {
  // TODO: Declare presentation methods
  func refresh()
  func didTapSignUp(userData: UserModel)
  func didTapClose()
  func checkIfUserExists(_ phone: String)
}

protocol SignUpUseCase: class {
  // TODO: Declare use case methods
  func verifyPhoneNumber(_ phone: String)
}

protocol SignUpInteractorOutput: InteractorOutputProtocol {
  // TODO: Declare interactor output methods
  func sentSMS(_ phone: String)
}

protocol SignUpWireframe: class {
  // TODO: Declare wireframe methods
  func popBack()
  func presentSMSLogin(userData: UserModel)
}
