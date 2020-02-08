//
//  PhoneVerificationContract.swift
//  Citizen
//
//  Created by Karina Karimova on 9/27/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

protocol PhoneVerificationView: IndicatableView {
  // TODO: Declare view methods
  func sentSMS()
}

protocol PhoneVerificationPresentation: class {
  // TODO: Declare presentation methods
  func didLoad(phone: String)
  func refresh()
  func didTapLeftButton()
  func didTapSubmit(verificationCode: String)
}

protocol PhoneVerificationUseCase: class {
  // TODO: Declare use case methods
  func verifyCode(_ verificationCode: String)
  func verifyPhoneNumber(_ phone: String)
}

protocol PhoneVerificationInteractorOutput: InteractorOutputProtocol {
  // TODO: Declare interactor output methods
  func verificationSuccess()
  func goBack()
  
  
  
  
  func sentSMS(_ phone: String)
}

protocol PhoneVerificationWireframe: class {
  // TODO: Declare wireframe methods
  func popBack()
}
