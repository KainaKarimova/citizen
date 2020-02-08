//
//  SignUpSMSInteractor.swift
//  Citizen
//
//  Created by Karina Karimova on 9/23/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import FirebaseAuth

class SignUpSMSInteractor {
  
  // MARK: Properties
  
  weak var output: SignUpSMSInteractorOutput?
}

extension SignUpSMSInteractor: SignUpSMSUseCase {
  // TODO: Implement use case methods
  
  func signUp(verificationCode: String, userData: UserModel) {
    
    if let verificationID = UserProfileManager.shared.verifiactionId.value {
      
      UserAPIService.signUpWith(verificationID: verificationID, verificationCode: verificationCode, userData: userData) { (result, error) in
        
        if self.output?.handleFirebaseError(error as NSError?, completion: {
          self.output?.goBack()
        }) == false {
          self.output?.signUpSuccess()
        }
      }
    }
  }
}
