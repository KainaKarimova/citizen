//
//  SignUpInteractor.swift
//  Citizen
//
//  Created by Karina Karimova on 9/15/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

class SignUpInteractor {
  
  // MARK: Properties
  
  weak var output: SignUpInteractorOutput?
}

extension SignUpInteractor: SignUpUseCase {
  // TODO: Implement use case methods
  
  func verifyPhoneNumber(_ phone: String) {
    
    UserAPIService.verifyPhoneNumberWith(phone: phone) { (verificationID, error) in
      if self.output?.handleError(error as NSError?) == false {
        self.output?.sentSMS(phone)
      }
    }
  }
  
}
