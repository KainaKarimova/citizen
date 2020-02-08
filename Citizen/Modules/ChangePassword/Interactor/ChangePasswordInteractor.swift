//
//  ChangePasswordInteractor.swift
//  Citizen
//
//  Created by Karina Karimova on 9/29/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

class ChangePasswordInteractor {
  
  // MARK: Properties
  
  weak var output: ChangePasswordInteractorOutput?
}

extension ChangePasswordInteractor: ChangePasswordUseCase {
  // TODO: Implement use case methods
  func changePasswordTo(password: String, phone: String) {
    UserAPIService.changePasswordTo(newPassword: password, phone: phone) { (error) in
      if self.output?.handleError(error as NSError?) == false {
        self.output?.changeSuccess()
      }
    }
    
  }
}
