//
//  HistoryContract.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

protocol HistoryView: IndicatableView {
  // TODO: Declare view methods
}

protocol HistoryPresentation: class {
  // TODO: Declare presentation methods
  func refresh()
  func didTapLeftButton()
}

protocol HistoryUseCase: class {
  // TODO: Declare use case methods
}

protocol HistoryInteractorOutput: InteractorOutputProtocol {
  // TODO: Declare interactor output methods
}

protocol HistoryWireframe: class {
  // TODO: Declare wireframe methods
  func popBack()
}
