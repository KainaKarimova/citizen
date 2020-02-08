//
//  ForgotPasswordContract.swift
//  Citizen
//
//  Created by Karina Karimova on 9/29/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

protocol ForgotPasswordView: IndicatableView {
  // TODO: Declare view methods
  func updateWith(exists: Bool)
}

protocol ForgotPasswordPresentation: class {
  // TODO: Declare presentation methods
  func refresh()
  func didTapClose()
  func didTapForget(phone: String)
  func checkIfUserExists(_ phone: String)
}

protocol ForgotPasswordUseCase: class {
  // TODO: Declare use case methods
}

protocol ForgotPasswordInteractorOutput: InteractorOutputProtocol {
  // TODO: Declare interactor output methods
}

protocol ForgotPasswordWireframe: class {
  // TODO: Declare wireframe methods
  func popBack()
  func presentPhoneVerification(phone: String)
  func presentChangePassword(phone: String)
}
