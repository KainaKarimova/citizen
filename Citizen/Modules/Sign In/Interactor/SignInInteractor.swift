//
//  SignInInteractor.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import FirebaseAuth

class SignInInteractor {
  
  // MARK: Properties
  
  weak var output: SignInInteractorOutput?
}

extension SignInInteractor: SignInUseCase {
  // TODO: Implement use case methods
  
  func signIn(phone: String, password: String) {
    UserAPIService.signInWith(phoneNumber: phone, password: password) { (authResult, error) in
      if self.output?.handleError(error as NSError?) == false {
        self.output?.signInSuccess()
      }
    }
  }
  
}
