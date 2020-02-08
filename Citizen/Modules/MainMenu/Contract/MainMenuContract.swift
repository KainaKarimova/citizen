//
//  MainMenuContract.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

protocol MainMenuView: IndicatableView {
  // TODO: Declare view methods
}

protocol MainMenuPresentation: class {
  // TODO: Declare presentation methods
  func refresh()
  func didSelect(presentationData: MenuCellPresentation)
}

protocol MainMenuUseCase: class {
  // TODO: Declare use case methods
  func signOut()
}

protocol MainMenuInteractorOutput: InteractorOutputProtocol {
  // TODO: Declare interactor output methods
  func signOutSuccess()
}

protocol MainMenuWireframe: class {
  // TODO: Declare wireframe methods
  func showProfile()
  func showInfo()
  func showHistory()
  func exit()
}
