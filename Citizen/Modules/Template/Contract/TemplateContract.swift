//
//  TemplateContract.swift
//  Citizen
//
//  Created by Karina Karimova on 9/23/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation

protocol TemplateView: IndicatableView {
  // TODO: Declare view methods
}

protocol TemplatePresentation: class {
  // TODO: Declare presentation methods
  func refresh()
  func didTapLeftButton()
}

protocol TemplateUseCase: class {
  // TODO: Declare use case methods
}

protocol TemplateInteractorOutput: InteractorOutputProtocol {
  // TODO: Declare interactor output methods
}

protocol TemplateWireframe: class {
  // TODO: Declare wireframe methods
  func popBack()
}
