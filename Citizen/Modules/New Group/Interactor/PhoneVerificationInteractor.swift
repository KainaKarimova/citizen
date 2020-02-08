//
//  PhoneVerificationInteractor.swift
//  Citizen
//
//  Created by Karina Karimova on 9/27/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import FirebaseAuth

class PhoneVerificationInteractor {
  
  // MARK: Properties
  
  weak var output: PhoneVerificationInteractorOutput?
}

extension PhoneVerificationInteractor: PhoneVerificationUseCase {
  // TODO: Implement use case methods
  
  func verifyCode(_ verificationCode: String) {
    
    if let verificationID = UserProfileManager.shared.verifiactionId.value {
      
      UserAPIService.verifyCode(verificationID: verificationID, verificationCode: verificationCode) { (result, error) in
        if self.output?.handleFirebaseError(error as NSError?, completion: {
          self.output?.goBack()
        }) == false {
          self.output?.verificationSuccess()
        }
      }
    }
    
    
  }
  
  
  func verifyPhoneNumber(_ phone: String) {
    
    UserAPIService.verifyPhoneNumberWith(phone: phone) { (verificationID, error) in
      if self.output?.handleError(error as NSError?) == false {
        self.output?.sentSMS(phone)
      } else {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
          self.output?.goBack()
        })
      }
    }
  }
  
}
