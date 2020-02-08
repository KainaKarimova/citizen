//
//  SignUpSMSContract.swift
//  Citizen
//
//  Created by Karina Karimova on 9/23/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

protocol SignUpSMSView: IndicatableView {
  // TODO: Declare view methods
}

protocol SignUpSMSPresentation: class {
  // TODO: Declare presentation methods
  func refresh()
  func didTapLeftButton()
  func didTapSubmit(verificationCode: String, userData: UserModel)
}

protocol SignUpSMSUseCase: class {
  // TODO: Declare use case methods
  func signUp(verificationCode: String, userData: UserModel)
}

protocol SignUpSMSInteractorOutput: InteractorOutputProtocol {
  // TODO: Declare interactor output methods
  func signUpSuccess()
  func goBack()
}

protocol SignUpSMSWireframe: class {
  // TODO: Declare wireframe methods
  func popBack()
}
