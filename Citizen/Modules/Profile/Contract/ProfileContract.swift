//
//  ProfileContract.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

protocol ProfileView: IndicatableView {
  // TODO: Declare view methods
  func updateWith(userData: UserModel)
}

protocol ProfilePresentation: class {
  // TODO: Declare presentation methods
  func viewDidLoad()
  func refresh()
  func didTapLeftButton()
}

protocol ProfileUseCase: class {
  // TODO: Declare use case methods
  func fetchProfileInfo()
}

protocol ProfileInteractorOutput: InteractorOutputProtocol {
  // TODO: Declare interactor output methods
  func gotProfileInfo(data: UserModel)
}

protocol ProfileWireframe: class {
  // TODO: Declare wireframe methods
  func popBack()
}
