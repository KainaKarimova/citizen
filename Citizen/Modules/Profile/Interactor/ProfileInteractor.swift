//
//  ProfileInteractor.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

class ProfileInteractor {
  
  // MARK: Properties
  
  weak var output: ProfileInteractorOutput?
}

extension ProfileInteractor: ProfileUseCase {
  // TODO: Implement use case methods
  func fetchProfileInfo() {
    UserAPIService.fetchProfileInfo { (response, error) in
      if self.output?.handleError(error as NSError?) == false {
        if let data = response {
          let userData = UserModel(dataObject: data)
          self.output?.gotProfileInfo(data: userData)
        }
      }
    }
  }
}
