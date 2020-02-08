//
//  ChangePasswordContract.swift
//  Citizen
//
//  Created by Karina Karimova on 9/29/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

protocol ChangePasswordView: IndicatableView {
  // TODO: Declare view methods
}

protocol ChangePasswordPresentation: class {
  // TODO: Declare presentation methods
  func refresh()
  func didTapClose()
  func didTapChange(password: String)
}

protocol ChangePasswordUseCase: class {
  // TODO: Declare use case methods
  func changePasswordTo(password: String, phone: String)
}

protocol ChangePasswordInteractorOutput: InteractorOutputProtocol {
  // TODO: Declare interactor output methods
  func changeSuccess()
}

protocol ChangePasswordWireframe: class {
  // TODO: Declare wireframe methods
  func popBack()
}
