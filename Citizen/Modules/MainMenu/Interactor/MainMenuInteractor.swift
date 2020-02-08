//
//  MainMenuInteractor.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

class MainMenuInteractor {
  
  // MARK: Properties
  
  weak var output: MainMenuInteractorOutput?
}

extension MainMenuInteractor: MainMenuUseCase {
  // TODO: Implement use case methods
  func signOut() {
    UserAPIService.signOut { (error) in
      if self.output?.handleError(error as NSError?) == false {
        self.output?.signOutSuccess()
      }
    }
  }
}
